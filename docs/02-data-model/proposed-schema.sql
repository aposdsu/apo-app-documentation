-- Chapter tracking system: starting schema
-- PostgreSQL 14+
--
-- A single-chapter design. There is deliberately no chapter/section/region hierarchy;
-- see docs/02-data-model/00-domain-model.md for why, and for what adding it later costs.
--
-- REVISION NOTE, 2026-08-28. This file was rewritten after the authenticated walkthrough
-- of APOonline. The changes are explained in docs/02-data-model/01-how-the-vendor-differs.md.
-- The biggest ones:
--   * requirement no longer has a term_id. Requirements outlive terms; credits are what
--     get counted inside a term window.
--   * account_type and membership_status are now two different tables, because the real
--     product has two levels and chapters define their own at the lower level.
--   * privileges are granted from two places, account types and officer positions.
--   * a requirement can be split into categories, and every goal is two numbers.
--   * a credit records whether it came from a chapter event or from outside.
--
-- Tested on PostgreSQL 16.15. The file applies clean, and `scripts/validate_schema.sql`
-- seeds it with fake data and checks that the two views return the right numbers and that
-- twenty constraints each reject what they claim to reject. To re-run both:
--
--   createdb apo
--   psql -d apo -v ON_ERROR_STOP=1 -f docs/02-data-model/proposed-schema.sql
--   psql -d apo -v ON_ERROR_STOP=1 -f scripts/validate_schema.sql
--
-- This is a starting point to argue with, not an answer.

BEGIN;

-- Case-insensitive email: 'Kingsley@x.edu' and 'kingsley@x.edu' are the same person,
-- and a plain-text UNIQUE would happily accept both.
CREATE EXTENSION IF NOT EXISTS citext;

-- ---------------------------------------------------------------------------
-- Terms.
--
-- The real product does not store terms at all. It stores the month and day each term
-- begins and works the window out on the fly (raw/pages/memberhome_action-setterm.md).
-- We keep real rows instead: they can be named, corrected, and joined against.
-- ---------------------------------------------------------------------------

CREATE TABLE term (
    id           bigserial PRIMARY KEY,
    name         text        NOT NULL UNIQUE,          -- 'Fall 2026'
    starts_on    date        NOT NULL,
    ends_on      date        NOT NULL,
    created_at   timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT term_dates_ordered CHECK (ends_on > starts_on)
);

-- Exactly one current term, enforced by the database rather than by hope.
CREATE TABLE current_term (
    lock    boolean PRIMARY KEY DEFAULT true,
    term_id bigint  NOT NULL REFERENCES term(id),
    CONSTRAINT current_term_singleton CHECK (lock)
);

-- ---------------------------------------------------------------------------
-- People
-- ---------------------------------------------------------------------------

CREATE TABLE member (
    id             bigserial PRIMARY KEY,
    first_name     text        NOT NULL,
    middle_name    text,
    last_name      text        NOT NULL,
    suffix         text,
    preferred_name text,                                -- the site calls this "nickname"
    email          citext      NOT NULL UNIQUE,         -- login e-mail
    contact_email  citext,                              -- optional second address
    phone          text,
    major          text,
    -- The real site stores pledge class and graduation class as a term word plus a year.
    pledge_class_term text CHECK (pledge_class_term IN ('Spring','Summer','Fall','Winter')),
    pledge_class_year integer,
    grad_class_term   text CHECK (grad_class_term IN ('Spring','Summer','Fall','Winter')),
    grad_class_year   integer,
    birthday       date,
    joined_on      date,
    -- NOTE: there is deliberately no `big_member_id` column here. The real product lets a
    -- member have more than one big AND more than one little; its own page says "If they
    -- have more than one big member or little member select each individually"
    -- (raw/pages/managebrother-all-panels.md). That is a many-to-many relationship, so it
    -- lives in the `lineage` table below.
    -- Soft delete: never hard-delete a member, their credits are chapter history.
    archived_at    timestamptz,
    created_at     timestamptz NOT NULL DEFAULT now(),
    updated_at     timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT member_names_present CHECK (length(first_name) > 0 AND length(last_name) > 0)
);

CREATE INDEX member_active_idx ON member (last_name, first_name) WHERE archived_at IS NULL;

-- Big/little, as a many-to-many. One row means "big is the big of little".
-- A member may have several bigs and several littles.
CREATE TABLE lineage (
    big_id    bigint NOT NULL REFERENCES member(id) ON DELETE CASCADE,
    little_id bigint NOT NULL REFERENCES member(id) ON DELETE CASCADE,
    PRIMARY KEY (big_id, little_id),
    CONSTRAINT lineage_not_self CHECK (big_id <> little_id)
);

CREATE INDEX lineage_little_idx ON lineage (little_id);

-- A "line" is what the product calls a family: a named group a member may join.
-- Membership in a line is optional; most members on the observed chapter have none.
CREATE TABLE line (
    id   bigserial PRIMARY KEY,
    name text NOT NULL UNIQUE
);

CREATE TABLE line_member (
    line_id   bigint NOT NULL REFERENCES line(id)   ON DELETE CASCADE,
    member_id bigint NOT NULL REFERENCES member(id) ON DELETE CASCADE,
    PRIMARY KEY (line_id, member_id)
);

-- Login is separate from personhood: alumni keep records without keeping accounts,
-- and a member can exist before they ever sign in.
CREATE TABLE user_account (
    id             bigserial PRIMARY KEY,
    member_id      bigint      NOT NULL UNIQUE REFERENCES member(id) ON DELETE CASCADE,
    password_hash  text,                                -- null when using OAuth only
    last_login_at  timestamptz,
    -- The real site holds new registrations until an officer approves them
    -- (raw/pages/memberhome_action-userspending.md).
    approved_at    timestamptz,
    disabled_at    timestamptz,
    created_at     timestamptz NOT NULL DEFAULT now()
);

-- ---------------------------------------------------------------------------
-- Membership.
--
-- Two levels, copied from the real product. `membership_status` is the small fixed list
-- the national organisation recognises. `account_type` is the chapter's own vocabulary,
-- and each one maps to a status. That is how "Studying Abroad" can be a local category
-- while still counting as Active nationally
-- (raw/pages/memberhome_action-editstatus_statusid-111.md).
-- ---------------------------------------------------------------------------

CREATE TABLE membership_status (
    id            bigserial PRIMARY KEY,
    code          text    NOT NULL UNIQUE,             -- 'active','alumni','inactive','pnm','prospect','deceased'
    label         text    NOT NULL,
    counts_in_roster boolean NOT NULL DEFAULT true,
    sort_order    integer NOT NULL DEFAULT 0
);

CREATE TABLE account_type (
    id            bigserial PRIMARY KEY,
    name          text    NOT NULL UNIQUE,             -- 'Active', 'Leave of Absence'
    name_plural   text    NOT NULL,                    -- 'Actives'
    status_id     bigint  NOT NULL REFERENCES membership_status(id) ON DELETE RESTRICT,
    -- Some types are built in and must not be deleted; the real site hides the delete
    -- link on those rows (raw/pages/memberhome_action-managestatuses.md).
    is_system     boolean NOT NULL DEFAULT false,
    sort_order    integer NOT NULL DEFAULT 0
);

-- One row per member per term. This is what makes "active in the fall, abroad in the
-- spring" expressible.
--
-- NOTE: the real product appears to store a member's account type once, not per term
-- (docs/GAPS.md records this as unsettled). We keep it per term on purpose. Losing the
-- history is not recoverable later, and keeping it costs one extra column.
CREATE TABLE membership (
    id              bigserial PRIMARY KEY,
    member_id       bigint      NOT NULL REFERENCES member(id) ON DELETE CASCADE,
    term_id         bigint      NOT NULL REFERENCES term(id)   ON DELETE RESTRICT,
    account_type_id bigint      NOT NULL REFERENCES account_type(id) ON DELETE RESTRICT,
    chapter_member_number text,                         -- the site's "chapternumber[<chapter>]"
    notes           text,
    created_at      timestamptz NOT NULL DEFAULT now(),
    UNIQUE (member_id, term_id)
);

CREATE INDEX membership_term_idx ON membership (term_id, account_type_id);

-- ---------------------------------------------------------------------------
-- Permissions as data, granted from two places.
--
-- Seed `privilege` from the two lists in
--   raw/pages/memberhome_action-editofficerprivileges_officerid-2892.md
--   raw/pages/memberhome_action-editprivileges_statusid-2.md
-- Every row names a feature, so the list doubles as a feature inventory.
-- ---------------------------------------------------------------------------

CREATE TABLE privilege (
    code        text PRIMARY KEY,                       -- 'events.create', 'credits.manage'
    label       text NOT NULL,
    category    text NOT NULL,                          -- grouping for the admin UI
    -- Which grid may grant it. The real product keeps two mostly separate lists. Four
    -- privileges genuinely appear in both (bulk e-mail, bulk SMS, file upload, meeting
    -- minutes). Other field names repeat across the grids but mean different things;
    -- give those two different codes.
    grantable_to text NOT NULL
        CHECK (grantable_to IN ('account_type','position','both'))
);

CREATE TABLE account_type_privilege (
    account_type_id bigint NOT NULL REFERENCES account_type(id) ON DELETE CASCADE,
    privilege_code  text   NOT NULL REFERENCES privilege(code)  ON DELETE CASCADE,
    PRIMARY KEY (account_type_id, privilege_code)
);

CREATE TABLE officer_position (
    id          bigserial PRIMARY KEY,
    name        text    NOT NULL UNIQUE,                -- 'VP Service'
    -- The real site marks each position officer, advisor, or both.
    kind        text    NOT NULL DEFAULT 'officer'
        CHECK (kind IN ('officer','advisor','both')),
    description text,
    sort_order  integer NOT NULL DEFAULT 0,
    is_system   boolean NOT NULL DEFAULT false,         -- President could not be deleted
    retired_at  timestamptz                             -- positions get abolished; keep history
);

CREATE TABLE position_privilege (
    position_id    bigint NOT NULL REFERENCES officer_position(id) ON DELETE CASCADE,
    privilege_code text   NOT NULL REFERENCES privilege(code)      ON DELETE CASCADE,
    PRIMARY KEY (position_id, privilege_code)
);

-- A position may be co-held, and one member may hold several positions. Both were
-- observed on the roster (raw/pages/memberhome_action-brothers.md).
CREATE TABLE officer_assignment (
    id           bigserial PRIMARY KEY,
    member_id    bigint      NOT NULL REFERENCES member(id)           ON DELETE CASCADE,
    position_id  bigint      NOT NULL REFERENCES officer_position(id) ON DELETE RESTRICT,
    term_id      bigint      NOT NULL REFERENCES term(id)             ON DELETE RESTRICT,
    created_at   timestamptz NOT NULL DEFAULT now(),
    UNIQUE (member_id, position_id, term_id)
);

CREATE INDEX officer_assignment_lookup_idx ON officer_assignment (member_id, term_id);

-- A member's privileges this term = what their account type grants, plus what every
-- position they hold grants.
CREATE VIEW member_privilege AS
SELECT DISTINCT m.member_id, m.term_id, atp.privilege_code
FROM   membership m
JOIN   account_type_privilege atp ON atp.account_type_id = m.account_type_id
UNION
SELECT DISTINCT oa.member_id, oa.term_id, pp.privilege_code
FROM   officer_assignment oa
JOIN   position_privilege pp ON pp.position_id = oa.position_id;

-- ---------------------------------------------------------------------------
-- Requirements.
--
-- A requirement has NO term. Bylaws outlive semesters. What a term does is bound the
-- window that credits are counted in (docs/02-data-model/02-questions-answered.md, Q7).
-- ---------------------------------------------------------------------------

CREATE TABLE requirement (
    id            bigserial PRIMARY KEY,
    name          text        NOT NULL UNIQUE,          -- 'Service Project'
    unit_label    text        NOT NULL,                 -- 'Service Hour'
    -- Counted in units, or as a share of all events of this type.
    is_percentage boolean     NOT NULL DEFAULT false,
    -- May a member earn this outside chapter events?
    allows_external boolean   NOT NULL DEFAULT false,
    -- A point tracker in the real product is a requirement with no goals.
    is_point_tracker boolean  NOT NULL DEFAULT false,
    sort_order    integer     NOT NULL DEFAULT 0,
    retired_at    timestamptz
);

-- Optional sub-parts, for example Service to the Campus / Community / Nation / Fraternity.
CREATE TABLE requirement_category (
    id             bigserial PRIMARY KEY,
    requirement_id bigint  NOT NULL REFERENCES requirement(id) ON DELETE CASCADE,
    name           text    NOT NULL,
    sort_order     integer NOT NULL DEFAULT 0,
    UNIQUE (requirement_id, name)
);

-- The target, per account type. Two numbers, exactly as the real form has them:
-- how much is required in total, and at most how much of that may be external.
-- A target of 0 means "this bar does not apply to this account type", which is what the
-- real site's help text says.
--
-- category_id null means the goal is for the requirement as a whole.
CREATE TABLE requirement_goal (
    id              bigserial PRIMARY KEY,
    requirement_id  bigint       NOT NULL REFERENCES requirement(id)          ON DELETE CASCADE,
    account_type_id bigint       NOT NULL REFERENCES account_type(id)         ON DELETE CASCADE,
    category_id     bigint       REFERENCES requirement_category(id)          ON DELETE CASCADE,
    target          numeric(8,2) NOT NULL DEFAULT 0,
    external_max    numeric(8,2),
    CONSTRAINT goal_target_not_negative CHECK (target >= 0),
    CONSTRAINT goal_external_not_negative CHECK (external_max IS NULL OR external_max >= 0),
    CONSTRAINT goal_external_within_target
        CHECK (external_max IS NULL OR target = 0 OR external_max <= target)
);

CREATE UNIQUE INDEX requirement_goal_whole_idx
    ON requirement_goal (requirement_id, account_type_id)
    WHERE category_id IS NULL;
CREATE UNIQUE INDEX requirement_goal_category_idx
    ON requirement_goal (requirement_id, account_type_id, category_id)
    WHERE category_id IS NOT NULL;

-- ---------------------------------------------------------------------------
-- Events
-- ---------------------------------------------------------------------------

CREATE TABLE event (
    id           bigserial PRIMARY KEY,
    term_id      bigint      NOT NULL REFERENCES term(id) ON DELETE RESTRICT,
    title        text        NOT NULL,
    description  text,
    location     text,
    starts_at    timestamptz NOT NULL,
    ends_at      timestamptz,
    is_all_day   boolean     NOT NULL DEFAULT false,
    capacity     integer,
    -- Sign-up window. The real form has three separate moments: when sign-ups open,
    -- when they lock, and when they close.
    signups_open_at   timestamptz,
    signups_lock_at   timestamptz,
    signups_close_at  timestamptz,
    -- Who may see it and who may sign up. The real product uses a numeric scale that
    -- reaches outside one chapter; for a single chapter these three values are enough.
    visibility   text        NOT NULL DEFAULT 'members'
        CHECK (visibility IN ('officers','members','public')),
    created_by   bigint      REFERENCES member(id) ON DELETE SET NULL,
    completed_at timestamptz,                            -- set when credit was awarded
    completed_by bigint      REFERENCES member(id) ON DELETE SET NULL,
    cancelled_at timestamptz,
    created_at   timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT event_times_ordered CHECK (ends_at IS NULL OR ends_at >= starts_at),
    CONSTRAINT event_capacity_positive CHECK (capacity IS NULL OR capacity > 0)
);

CREATE INDEX event_term_start_idx ON event (term_id, starts_at DESC);

-- One or two members run the event and are the ones who complete it.
CREATE TABLE event_coordinator (
    event_id  bigint NOT NULL REFERENCES event(id)  ON DELETE CASCADE,
    member_id bigint NOT NULL REFERENCES member(id) ON DELETE CASCADE,
    PRIMARY KEY (event_id, member_id)
);

-- What attending this event earns. One row per credit, so one event can count toward
-- several requirements. This matched the real product exactly.
CREATE TABLE event_credit_rule (
    id             bigserial PRIMARY KEY,
    event_id       bigint       NOT NULL REFERENCES event(id)                ON DELETE CASCADE,
    requirement_id bigint       NOT NULL REFERENCES requirement(id)          ON DELETE CASCADE,
    category_id    bigint       REFERENCES requirement_category(id)          ON DELETE CASCADE,
    amount         numeric(8,2) NOT NULL,
    CONSTRAINT event_credit_amount_positive CHECK (amount > 0)
);

CREATE UNIQUE INDEX event_credit_rule_whole_idx
    ON event_credit_rule (event_id, requirement_id) WHERE category_id IS NULL;
CREATE UNIQUE INDEX event_credit_rule_category_idx
    ON event_credit_rule (event_id, requirement_id, category_id) WHERE category_id IS NOT NULL;

-- Intent to attend. Kept separate from attendance ON PURPOSE. The real product appears
-- to keep one list for both; see docs/02-data-model/01-how-the-vendor-differs.md, point 5.
CREATE TABLE signup (
    id           bigserial PRIMARY KEY,
    event_id     bigint      NOT NULL REFERENCES event(id)  ON DELETE CASCADE,
    member_id    bigint      NOT NULL REFERENCES member(id) ON DELETE CASCADE,
    -- The real site records drivers and their spare seats on the sign-up.
    is_driver    boolean     NOT NULL DEFAULT false,
    open_seats   integer,
    signed_up_at timestamptz NOT NULL DEFAULT now(),
    cancelled_at timestamptz,
    UNIQUE (event_id, member_id),
    CONSTRAINT signup_seats_only_for_drivers
        CHECK (open_seats IS NULL OR is_driver)
);

-- The fact of showing up. Not the reward.
CREATE TABLE attendance (
    id          bigserial PRIMARY KEY,
    event_id    bigint      NOT NULL REFERENCES event(id)  ON DELETE CASCADE,
    member_id   bigint      NOT NULL REFERENCES member(id) ON DELETE CASCADE,
    status      text        NOT NULL,
    recorded_by bigint      REFERENCES member(id) ON DELETE SET NULL,
    recorded_at timestamptz NOT NULL DEFAULT now(),
    UNIQUE (event_id, member_id),
    CONSTRAINT attendance_status_known
        CHECK (status IN ('present','absent','excused','late'))
);

CREATE INDEX attendance_member_idx ON attendance (member_id);

-- ---------------------------------------------------------------------------
-- Credits. The most important table in the system.
-- ---------------------------------------------------------------------------

CREATE TABLE requirement_credit (
    id             bigserial PRIMARY KEY,
    member_id      bigint       NOT NULL REFERENCES member(id)      ON DELETE CASCADE,
    requirement_id bigint       NOT NULL REFERENCES requirement(id) ON DELETE CASCADE,
    category_id    bigint       REFERENCES requirement_category(id) ON DELETE SET NULL,
    amount         numeric(8,2) NOT NULL,
    -- The date the work happened, which is what a term window filters on. Not the date
    -- the row was written: an officer can enter last week's hours today.
    occurred_on    date         NOT NULL,
    -- Did this come from a chapter event, or from work done outside the chapter?
    is_external    boolean      NOT NULL DEFAULT false,
    -- A short label. The real manual-entry form calls this the project name.
    title          text,
    -- Where it came from. Event-derived credit points at the attendance row so it can be
    -- revoked when attendance is corrected; manual grants carry a reason instead.
    source         text         NOT NULL,
    attendance_id  bigint       REFERENCES attendance(id) ON DELETE CASCADE,
    reason         text,
    granted_by     bigint       REFERENCES member(id) ON DELETE SET NULL,
    granted_at     timestamptz  NOT NULL DEFAULT now(),
    -- Approval is optional per chapter; null approved_at means pending.
    approved_by    bigint       REFERENCES member(id) ON DELETE SET NULL,
    approved_at    timestamptz,
    CONSTRAINT credit_amount_positive CHECK (amount > 0),
    CONSTRAINT credit_source_known CHECK (source IN ('attendance','manual')),
    CONSTRAINT credit_source_consistent CHECK (
        (source = 'attendance' AND attendance_id IS NOT NULL AND is_external = false) OR
        (source = 'manual'     AND attendance_id IS NULL AND reason IS NOT NULL)
    )
    -- One credit per attendance per requirement; completing an event twice is harmless.
    -- That rule is enforced by the two partial unique indexes below rather than by a
    -- UNIQUE constraint here, because PostgreSQL treats two NULLs as different values by
    -- default, so a plain UNIQUE over a nullable category_id would not stop duplicates.
);

CREATE UNIQUE INDEX credit_once_per_attendance_idx
    ON requirement_credit (attendance_id, requirement_id)
    WHERE attendance_id IS NOT NULL AND category_id IS NULL;
CREATE UNIQUE INDEX credit_once_per_attendance_category_idx
    ON requirement_credit (attendance_id, requirement_id, category_id)
    WHERE attendance_id IS NOT NULL AND category_id IS NOT NULL;

CREATE INDEX credit_member_req_idx ON requirement_credit (member_id, requirement_id);
CREATE INDEX credit_occurred_idx   ON requirement_credit (occurred_on);

-- Progress, computed live inside the current term's window, split into internal and
-- external the way the real product reports it. Start here; materialise only if it
-- actually gets slow, and measure before deciding.
CREATE VIEW requirement_progress AS
SELECT m.member_id,
       m.term_id,
       r.id                       AS requirement_id,
       r.name                     AS requirement_name,
       g.target,
       g.external_max,
       COALESCE(SUM(rc.amount) FILTER (WHERE rc.is_external = false), 0) AS earned_internal,
       -- External credit is reported two ways, because the real product reports it two
       -- ways: "the first value is the total external hours up to the personal cap and the
       -- value in parenthesis is the total uncapped value recorded"
       -- (raw/pages/full-read-pass-2.md). So the uncapped total is stored and the cap is
       -- applied when reading, never when writing. Losing a member's real external hours
       -- because they exceeded a cap would be a bug.
       COALESCE(SUM(rc.amount) FILTER (WHERE rc.is_external = true),  0) AS earned_external_uncapped,
       LEAST(
         COALESCE(SUM(rc.amount) FILTER (WHERE rc.is_external = true), 0),
         COALESCE(g.external_max, COALESCE(SUM(rc.amount) FILTER (WHERE rc.is_external = true), 0))
       )                                                                 AS earned_external_capped,
       COALESCE(SUM(rc.amount) FILTER (WHERE rc.is_external = false), 0)
         + LEAST(
             COALESCE(SUM(rc.amount) FILTER (WHERE rc.is_external = true), 0),
             COALESCE(g.external_max, COALESCE(SUM(rc.amount) FILTER (WHERE rc.is_external = true), 0))
           )                                                             AS earned_total
FROM   membership m
JOIN   term t          ON t.id = m.term_id
JOIN   requirement_goal g
                       ON g.account_type_id = m.account_type_id
                      AND g.category_id IS NULL
JOIN   requirement r   ON r.id = g.requirement_id
LEFT   JOIN requirement_credit rc
                       ON rc.requirement_id = r.id
                      AND rc.member_id      = m.member_id
                      AND rc.approved_at IS NOT NULL
                      AND rc.occurred_on BETWEEN t.starts_on AND t.ends_on
WHERE  g.target > 0
GROUP  BY m.member_id, m.term_id, r.id, r.name, g.target, g.external_max;

-- ---------------------------------------------------------------------------
-- Money.
--
-- The real product runs a small ledger: every fee and every payment is a row, and a
-- member's balance is the sum. It also treats dues as a requirement with a progress bar,
-- which we are not copying. A charge-and-payment pair is clearer.
-- ---------------------------------------------------------------------------

CREATE TABLE dues_charge (
    id          bigserial PRIMARY KEY,
    member_id   bigint        NOT NULL REFERENCES member(id) ON DELETE CASCADE,
    term_id     bigint        NOT NULL REFERENCES term(id)   ON DELETE RESTRICT,
    amount_cents integer      NOT NULL,
    memo        text,
    due_on      date,
    waived_at   timestamptz,
    waived_by   bigint        REFERENCES member(id) ON DELETE SET NULL,
    created_at  timestamptz   NOT NULL DEFAULT now(),
    CONSTRAINT dues_amount_positive CHECK (amount_cents > 0)
);

CREATE INDEX dues_charge_member_idx ON dues_charge (member_id, term_id);

CREATE TABLE dues_payment (
    id            bigserial PRIMARY KEY,
    charge_id     bigint      NOT NULL REFERENCES dues_charge(id) ON DELETE CASCADE,
    amount_cents  integer     NOT NULL,                -- negative allowed: refunds
    method        text        NOT NULL
        CHECK (method IN ('cash','check','card','other')),
    reference     text,
    memo          text,
    recorded_by   bigint      REFERENCES member(id) ON DELETE SET NULL,
    paid_on       date        NOT NULL,
    created_at    timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT dues_payment_nonzero CHECK (amount_cents <> 0)
);

CREATE INDEX dues_payment_charge_idx ON dues_payment (charge_id);

-- ---------------------------------------------------------------------------
-- Audit. Add this on day one, not later. The real product has one and it is the most
-- useful officer-facing page on the site (raw/pages/memberhome_action-viewlog.md).
-- ---------------------------------------------------------------------------

CREATE TABLE audit_log (
    id          bigserial PRIMARY KEY,
    actor_id    bigint      REFERENCES member(id) ON DELETE SET NULL,
    action      text        NOT NULL,                  -- 'credit.grant', 'member.archive'
    entity_type text        NOT NULL,
    entity_id   bigint      NOT NULL,
    detail      jsonb       NOT NULL DEFAULT '{}'::jsonb,
    created_at  timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX audit_entity_idx ON audit_log (entity_type, entity_id, created_at DESC);
CREATE INDEX audit_actor_idx  ON audit_log (actor_id, created_at DESC);

COMMIT;

-- ---------------------------------------------------------------------------
-- What the walkthrough settled, and what it did not
-- ---------------------------------------------------------------------------
-- Settled (see docs/02-data-model/02-questions-answered.md):
--   1. The privilege list. Seed `privilege` from the two raw files named above.
--   2. Targets are always numbers, but a requirement may be counted as a percentage.
--   3. One event can count toward several requirements. Confirmed.
--   4. Meetings are a requirement like any other.
--   5. Ten shared account types, four local ones, six national statuses above them.
--   7. Requirements do NOT belong to a term. Fixed in this file.
--
-- Still open:
--   6. Whether the real product caches progress totals. We compute them.
--   8. What happens to credits and targets when a member's account type changes mid-term.
--   Whether the real product keeps attendance separately from sign-ups. We keep both.
--   Whether account type is stored per term or once. We store it per term.
--
-- ---------------------------------------------------------------------------
-- Intentionally left out of this version-one schema (see 05-rebuild-plan/01-scope.md)
-- ---------------------------------------------------------------------------
--   * award, member_award, and the voting ballot     -- LATER
--   * achievement and member_achievement             -- LATER
--   * line (family) as its own table                 -- LATER; member.big_member_id for now
--   * the full transaction ledger and per-position budgets -- LATER
--   * meeting minutes, announcements, forms, courses, photo albums, the public website
--   * event shifts, recurring-event rules, cross-chapter invitations, mobile check-in
