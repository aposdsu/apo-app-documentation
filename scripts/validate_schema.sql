-- Validation for docs/02-data-model/proposed-schema.sql
--
-- Applies a small amount of fake data, then checks that the two views return the right
-- numbers and that each constraint actually rejects what it claims to reject.
--
-- Run with:
--   createdb apo && psql -d apo -v ON_ERROR_STOP=1 -f docs/02-data-model/proposed-schema.sql
--   psql -d apo -v ON_ERROR_STOP=1 -f scripts/validate_schema.sql
--
-- Every check raises an exception if it fails, so a clean run means every check passed.

\set ON_ERROR_STOP on

-- ---------------------------------------------------------------- seed
INSERT INTO membership_status (id, code, label) VALUES
  (1,'active','Active'), (2,'alumni','Alumni');
SELECT setval('membership_status_id_seq', 2);

INSERT INTO account_type (id, name, name_plural, status_id, is_system) VALUES
  (1,'Active','Actives',1,true),
  (2,'Half-Active','Half-Actives',1,false),
  (3,'Alum','Alumni',2,true);
SELECT setval('account_type_id_seq', 3);

INSERT INTO term (id, name, starts_on, ends_on) VALUES
  (1,'Fall 2026','2026-06-20','2026-12-19'),
  (2,'Spring 2027','2026-12-20','2027-06-19');
SELECT setval('term_id_seq', 2);
INSERT INTO current_term (term_id) VALUES (1);

INSERT INTO member (id, first_name, last_name, email) VALUES
  (1,'Ada','Lovelace','ada@example.edu'),
  (2,'Grace','Hopper','grace@example.edu');
SELECT setval('member_id_seq', 2);

INSERT INTO membership (member_id, term_id, account_type_id) VALUES
  (1,1,1),   -- Ada is Active this term
  (2,1,2);   -- Grace is Half-Active this term

INSERT INTO privilege (code, label, category, grantable_to) VALUES
  ('events.signup','Sign up for an event','event','account_type'),
  ('service.log_own','Log their own internal service hours','record','account_type'),
  ('service.manage','Manage the service hour requirement','requirement','position'),
  ('files.upload','Upload files','access','both');

INSERT INTO account_type_privilege VALUES
  (1,'events.signup'), (1,'service.log_own'),
  (2,'events.signup'), (2,'service.log_own');

INSERT INTO officer_position (id, name, kind, is_system) VALUES
  (1,'President','officer',true), (2,'Service VP','officer',false);
SELECT setval('officer_position_id_seq', 2);
INSERT INTO position_privilege VALUES (2,'service.manage'), (2,'files.upload');

INSERT INTO officer_assignment (member_id, position_id, term_id) VALUES (1,2,1);

-- Service Project, split into two categories, 15 hours for Active with at most 5
-- external, 7.5 for Half-Active, nothing for Alum.
INSERT INTO requirement (id, name, unit_label, allows_external) VALUES
  (1,'Service Project','Service Hour', true);
SELECT setval('requirement_id_seq', 1);
INSERT INTO requirement_category (id, requirement_id, name) VALUES
  (1,1,'Service to the Campus'), (2,1,'Service to the Community');
SELECT setval('requirement_category_id_seq', 2);
INSERT INTO requirement_goal (requirement_id, account_type_id, category_id, target, external_max) VALUES
  (1,1,NULL,15,5),
  (1,2,NULL,7.5,5),
  (1,3,NULL,0,NULL),
  (1,1,1,5,NULL);

-- ---------------------------------------------------------------- events and credit
INSERT INTO event (id, term_id, title, starts_at) VALUES
  (1,1,'Beach Cleanup','2026-09-05 09:00-07');
SELECT setval('event_id_seq', 1);
INSERT INTO event_coordinator VALUES (1,1);
INSERT INTO event_credit_rule (event_id, requirement_id, category_id, amount) VALUES
  (1,1,1,3);

INSERT INTO signup (event_id, member_id, is_driver, open_seats) VALUES
  (1,1,true,4), (1,2,false,NULL);
INSERT INTO attendance (id, event_id, member_id, status) VALUES
  (1,1,1,'present'), (2,1,2,'absent');
SELECT setval('attendance_id_seq', 2);

-- Ada: 3 hours from the event, plus 2 external hours logged by hand, plus one credit
-- that falls in the NEXT term and one that is not approved. Only the first two should
-- count toward this term's progress.
INSERT INTO requirement_credit
  (member_id, requirement_id, category_id, amount, occurred_on, is_external, title, source, attendance_id, reason, approved_at)
VALUES
  (1,1,1,3,'2026-09-05',false,'Beach Cleanup','attendance',1,NULL,now()),
  (1,1,NULL,2,'2026-09-10',true,'Food bank','manual',NULL,'volunteered off-calendar',now()),
  (1,1,NULL,9,'2027-02-01',false,'Next term work','manual',NULL,'out of window',now()),
  (1,1,NULL,4,'2026-09-20',false,'Awaiting approval','manual',NULL,'pending',NULL);

-- ---------------------------------------------------------------- view checks
DO $$
DECLARE r record; n int;
BEGIN
  -- member_privilege: Ada should have her account type's two privileges plus the two
  -- from the Service VP position she holds. Grace should have only the two.
  SELECT count(*) INTO n FROM member_privilege WHERE member_id = 1 AND term_id = 1;
  IF n <> 4 THEN RAISE EXCEPTION 'member_privilege: expected 4 for Ada, got %', n; END IF;

  SELECT count(*) INTO n FROM member_privilege WHERE member_id = 2 AND term_id = 1;
  IF n <> 2 THEN RAISE EXCEPTION 'member_privilege: expected 2 for Grace, got %', n; END IF;

  -- requirement_progress: Ada earned 3 internal + 2 external inside the window.
  SELECT * INTO r FROM requirement_progress WHERE member_id = 1 AND requirement_id = 1;
  IF r.target <> 15 THEN RAISE EXCEPTION 'progress: target expected 15, got %', r.target; END IF;
  IF r.external_max <> 5 THEN RAISE EXCEPTION 'progress: external_max expected 5, got %', r.external_max; END IF;
  IF r.earned_internal <> 3 THEN RAISE EXCEPTION 'progress: internal expected 3, got %', r.earned_internal; END IF;
  IF r.earned_external_uncapped <> 2 THEN RAISE EXCEPTION 'progress: external expected 2, got %', r.earned_external_uncapped; END IF;
  IF r.earned_external_capped <> 2 THEN RAISE EXCEPTION 'progress: capped external expected 2, got %', r.earned_external_capped; END IF;
  IF r.earned_total <> 5 THEN RAISE EXCEPTION 'progress: total expected 5, got %', r.earned_total; END IF;

  -- Grace attended nothing, so she should still appear with a 7.5 target and 0 earned.
  SELECT * INTO r FROM requirement_progress WHERE member_id = 2 AND requirement_id = 1;
  IF r IS NULL THEN RAISE EXCEPTION 'progress: Grace is missing from the view'; END IF;
  IF r.target <> 7.5 THEN RAISE EXCEPTION 'progress: Grace target expected 7.5, got %', r.target; END IF;
  IF r.earned_total <> 0 THEN RAISE EXCEPTION 'progress: Grace total expected 0, got %', r.earned_total; END IF;

  RAISE NOTICE 'view checks passed';
END $$;

-- ---------------------------------------------------------------- constraint checks
-- Each block must fail. If one succeeds, the constraint is not doing its job.
DO $$
DECLARE
  checks text[] := ARRAY[
    -- a credit amount must be positive
    $q$INSERT INTO requirement_credit (member_id,requirement_id,amount,occurred_on,source,reason)
       VALUES (1,1,0,'2026-09-05','manual','zero')$q$,
    -- a manual credit must carry a reason
    $q$INSERT INTO requirement_credit (member_id,requirement_id,amount,occurred_on,source)
       VALUES (1,1,1,'2026-09-05','manual')$q$,
    -- an attendance credit must point at an attendance row
    $q$INSERT INTO requirement_credit (member_id,requirement_id,amount,occurred_on,source)
       VALUES (1,1,1,'2026-09-05','attendance')$q$,
    -- an attendance credit cannot be external
    $q$INSERT INTO requirement_credit (member_id,requirement_id,amount,occurred_on,source,attendance_id,is_external)
       VALUES (1,1,1,'2026-09-05','attendance',2,true)$q$,
    -- the same attendance cannot be credited twice for the same requirement and category
    $q$INSERT INTO requirement_credit (member_id,requirement_id,category_id,amount,occurred_on,source,attendance_id)
       VALUES (1,1,1,3,'2026-09-05','attendance',1)$q$,
    -- an external cap cannot exceed the target
    $q$INSERT INTO requirement_goal (requirement_id,account_type_id,target,external_max)
       VALUES (1,3,4,9)$q$,
    -- one goal per requirement per account type
    $q$INSERT INTO requirement_goal (requirement_id,account_type_id,target) VALUES (1,1,20)$q$,
    -- one credit rule per event per requirement per category
    $q$INSERT INTO event_credit_rule (event_id,requirement_id,category_id,amount) VALUES (1,1,1,5)$q$,
    -- a credit rule amount must be positive
    $q$INSERT INTO event_credit_rule (event_id,requirement_id,amount) VALUES (1,1,0)$q$,
    -- open seats only make sense for a driver
    $q$INSERT INTO signup (event_id,member_id,is_driver,open_seats) VALUES (1,1,false,3)$q$,
    -- one signup per member per event
    $q$INSERT INTO signup (event_id,member_id) VALUES (1,1)$q$,
    -- attendance status must be one of the four known values
    $q$INSERT INTO attendance (event_id,member_id,status) VALUES (1,1,'maybe')$q$,
    -- a member cannot be their own big
    $q$INSERT INTO lineage (big_id, little_id) VALUES (1,1)$q$,
    -- the same big/little pair cannot be recorded twice
    $q$INSERT INTO lineage (big_id, little_id) VALUES (1,2)$q$ ||
      $q$; INSERT INTO lineage (big_id, little_id) VALUES (1,2)$q$,
    -- a term must end after it starts
    $q$INSERT INTO term (name,starts_on,ends_on) VALUES ('Broken','2026-05-01','2026-04-01')$q$,
    -- only one current term
    $q$INSERT INTO current_term (term_id) VALUES (2)$q$,
    -- one membership per member per term
    $q$INSERT INTO membership (member_id,term_id,account_type_id) VALUES (1,1,3)$q$,
    -- a member cannot hold the same position twice in one term
    $q$INSERT INTO officer_assignment (member_id,position_id,term_id) VALUES (1,2,1)$q$,
    -- a payment of zero is meaningless
    $q$INSERT INTO dues_charge (id,member_id,term_id,amount_cents) VALUES (99,1,1,5000)$q$ ||
      $q$; INSERT INTO dues_payment (charge_id,amount_cents,method,paid_on) VALUES (99,0,'cash','2026-09-01')$q$,
    -- an unknown payment method
    $q$INSERT INTO dues_charge (id,member_id,term_id,amount_cents) VALUES (98,2,1,5000)$q$ ||
      $q$; INSERT INTO dues_payment (charge_id,amount_cents,method,paid_on) VALUES (98,100,'bitcoin','2026-09-01')$q$,
    -- a privilege must say where it can be granted from
    $q$INSERT INTO privilege (code,label,category,grantable_to) VALUES ('x','X','y','nowhere')$q$
  ];
  stmt text;
  i int := 0;
BEGIN
  FOREACH stmt IN ARRAY checks LOOP
    i := i + 1;
    BEGIN
      EXECUTE stmt;
      RAISE EXCEPTION 'constraint check % did NOT fail as expected: %', i, stmt;
    EXCEPTION
      WHEN check_violation OR unique_violation OR not_null_violation
        OR foreign_key_violation OR invalid_text_representation THEN
        NULL;  -- rejected, which is what we want
    END;
  END LOOP;
  RAISE NOTICE 'all % constraint checks rejected bad data as expected', i;
END $$;

-- A co-held position and a member holding two positions must both be allowed.
INSERT INTO officer_assignment (member_id, position_id, term_id) VALUES (2,2,1);  -- co-held
INSERT INTO officer_assignment (member_id, position_id, term_id) VALUES (1,1,1);  -- two positions
DO $$
DECLARE n int;
BEGIN
  SELECT count(*) INTO n FROM officer_assignment WHERE position_id = 2 AND term_id = 1;
  IF n <> 2 THEN RAISE EXCEPTION 'a position should be co-holdable, got % holders', n; END IF;
  SELECT count(*) INTO n FROM officer_assignment WHERE member_id = 1 AND term_id = 1;
  IF n <> 2 THEN RAISE EXCEPTION 'a member should hold two positions, got %', n; END IF;
  RAISE NOTICE 'co-held position and multi-position member both allowed';
END $$;

-- A member may have more than one big and more than one little, which is what the real
-- product allows and what the old single-column design could not express.
INSERT INTO member (id, first_name, last_name, email) VALUES
  (3,'Alan','Turing','alan@example.edu'), (4,'Katherine','Johnson','kj@example.edu');
SELECT setval('member_id_seq', 4);
INSERT INTO lineage (big_id, little_id) VALUES (1,3), (2,3), (3,4);
DO $$
DECLARE n int;
BEGIN
  SELECT count(*) INTO n FROM lineage WHERE little_id = 3;
  IF n <> 2 THEN RAISE EXCEPTION 'a member should be able to have two bigs, got %', n; END IF;
  SELECT count(*) INTO n FROM lineage WHERE big_id = 3;
  IF n <> 1 THEN RAISE EXCEPTION 'a member should be able to be a big too, got %', n; END IF;
  RAISE NOTICE 'a member can have several bigs and be a big themselves';
END $$;

-- The external cap must limit what counts toward the total, WITHOUT losing the real value.
-- Ada's external cap is 5. Give her 9 more external hours (11 total, over the cap).
INSERT INTO requirement_credit
  (member_id, requirement_id, amount, occurred_on, is_external, title, source, reason, approved_at)
VALUES (1,1,9,'2026-09-15',true,'Extra outside work','manual','volunteered a lot',now());
DO $$
DECLARE r record;
BEGIN
  SELECT * INTO r FROM requirement_progress WHERE member_id = 1 AND requirement_id = 1;
  IF r.earned_external_uncapped <> 11 THEN
    RAISE EXCEPTION 'uncapped external should keep all 11, got %', r.earned_external_uncapped; END IF;
  IF r.earned_external_capped <> 5 THEN
    RAISE EXCEPTION 'capped external should be limited to 5, got %', r.earned_external_capped; END IF;
  IF r.earned_total <> 8 THEN
    RAISE EXCEPTION 'total should be 3 internal + 5 capped external = 8, got %', r.earned_total; END IF;
  RAISE NOTICE 'the external cap limits the total without losing the recorded value';
END $$;

-- A target of 0 must hide the requirement from that account type, which is the rule the
-- real site states on its requirement form.
INSERT INTO membership (member_id, term_id, account_type_id) VALUES (2,2,3);  -- Grace is an Alum next term
DO $$
DECLARE n int;
BEGIN
  SELECT count(*) INTO n FROM requirement_progress WHERE member_id = 2 AND term_id = 2;
  IF n <> 0 THEN RAISE EXCEPTION 'a target of 0 should hide the requirement, got % rows', n; END IF;
  RAISE NOTICE 'a goal of 0 hides the requirement from that account type';
END $$;

-- A member can be Active one term and Alum the next. This is the whole point of
-- storing membership per term.
INSERT INTO membership (member_id, term_id, account_type_id) VALUES (1,2,3);
DO $$
DECLARE n int;
BEGIN
  SELECT count(*) INTO n FROM membership WHERE member_id = 1;
  IF n <> 2 THEN RAISE EXCEPTION 'expected two memberships for Ada, got %', n; END IF;
  RAISE NOTICE 'a member can hold a different account type in a later term';
END $$;

SELECT 'VALIDATION PASSED' AS result;
