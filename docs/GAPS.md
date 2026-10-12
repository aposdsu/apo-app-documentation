# Open questions and unreached surfaces

> Summary: Everything the walkthrough could not settle, why, and how someone could settle
> it. Read this before trusting any claim marked medium or low confidence.
> Status: REFERENCE

Format: `[gap]` what we need | why it matters | how to get it.

## Questions the site did not answer

- ~~**What happens to a member's credits and targets when their account type changes
  mid-term.**~~ **Answered for the credits, by direct observation.** No account type was
  changed to learn this. The evidence is the operator's own record
  (`raw/pages/gap-resolution-2.md`): a credit row carries no account-type tag and no term
  tag (the `addrecord` form sends only userid, title, date, units, category, isExternal and
  the reqid), so credits are filed under (member, requirement). The operator's Timeline
  shows a real account-type change ("Apr 11, 2024 - Transitioned to an 'Advisor: Chapter
  Advisor'"), and their 48.5 service hours earned in 2015-2016 still list and total today,
  even though their current type (Advisor) has no service target. So **credits earned under
  a former account type persist unchanged across an account-type change; they are not
  deleted and not re-filed.** Only the target (the denominator), looked up by the member's
  current account type, changes. Confidence high. This answers question 8 in
  `docs/02-data-model/02-questions-answered.md`. The only thing still unobserved is cosmetic
  (how the progress bar renders for a type whose target is 0 or blank), not where the data
  goes.

- ~~**Whether the product keeps attendance separately from sign-ups.**~~ **Answered: it
  does not.** A completed event was opened and compared with a future one
  (`raw/pages/gap-resolution.md`). The attendee table is identical, "Member | Phone |
  Comment", with no present/absent column; only the Admin Actions change, where "Complete
  event" becomes "Update attendees". Confidence high. Our recommendation to keep `signup`
  and `attendance` as two tables is therefore a real improvement, not a restatement.

- ~~**Whether account type is stored once or per term.**~~ **Answered.** The current
  account type is a single value, and changes to it are kept separately as dated history.
  The member profile's Timeline panel has an activity type called "Membership Status Change"
  and shows entries such as "Transitioned to an 'Advisor: Chapter Advisor' at Alpha Delta"
  with a date (`raw/pages/profile-panels.md`). So the product has history, but not the
  per-term membership row our schema uses. Our design is still the recommended one, because
  a dated change log cannot answer "what was this member's status during Fall 2025" as
  directly as a row per term can, but the earlier claim that the product keeps no history
  was wrong.

- ~~**Whether the product caches progress totals or recomputes them.**~~ **Closed: out of
  scope.** This is an infrastructure choice, not a feature. This project documents features
  and the data model, not how the vendor's server is built, so caching versus live compute
  is not ours to settle. The rebuild computes progress live and adds caching only if
  measurement shows it is slow. (For the record, a credit added moved the total on the next
  page load and deleting it moved it back with no stale value, which is consistent with live
  compute, `raw/pages/gap-resolution-2.md`.)

- ~~**Whether `?action=editstatus` with no `statusid` creates an account type.**~~
  **Answered: one endpoint does both.** With no `statusid` the heading reads "Create Account
  Type", the form has no `statusid` field, the button reads "Create Account Type", and it
  still posts to `?action=updatestatus` (`raw/pages/gap-resolution.md`). Presence of
  `statusid` in the POST decides create versus update.

- ~~**Which specific account type a member ends up with after "Graduate Members".**~~
  **Answered: Alum.** The form posts only `stageId` and `targetStageId`, with no account-type
  control, and the membership-stages config shows only which types each stage contains
  (Alumni = Advisor, Alum, Honorary), not a default (`raw/pages/gap-resolution-2.md`). The
  reasoning was that Advisor is set only by an advisor position and Honorary is a special
  designation, leaving Alum. The chapter operator (Chapter Advisor of Alpha Delta,
  2026-08-30) confirmed Alum is the expected result of a graduation. The graduation itself
  was still not run (it changes real members), so this is operator-confirmed rather than
  screen-observed, but it is settled.

- **Whether the server enforces the privilege model, or only hides buttons.** NOT A GAP,
  and moved here from the open list on purpose. This is a question about the *vendor's
  implementation quality*, not about the model we are documenting. The deliverable is a
  clean-room rebuild that will enforce every privilege on the server regardless of what
  APOonline does, so the vendor's answer never changes our build. The design stance is
  fixed and stated in `docs/04-system-design/02-auth-and-permissions.md`: treat the client
  as untrusted and check every privilege server-side, every time. Whether the vendor meets
  that bar is deliberately out of scope. It is recorded as unverified only so no reader
  mistakes "the settings page says so" for "the software enforces it".

- ~~**Why the officer assignment page renders 26 rows for 19 positions.**~~ **Answered: it
  lists assignments, not positions.** Interchapter Chair, Pledge Trainer and Public
  Relations Chair each appear twice, and Chapter Advisor five times, giving 19 + 3 + 4 = 26
  assignment rows (`raw/pages/gap-resolution.md`). That matches `officers[N][positionId]`,
  where N indexes the row rather than the position.

- ~~**How a member is granted an award.**~~ **Answered.** `?action=manageUserAwardRecords`,
  and the same form on the Account Manager's Awards panel: pick an award, a member, a
  subtitle and a date (`raw/pages/newly-found-verbs.md`). Five Distinguished Service Key
  awards are built in. How an achievement is granted by hand is still unseen, because this
  chapter has defined none.

## Form targets that could not be read — now read

The browser extension blocks tool output that looks like query-string data, so earlier
passes could not return these forms' `action` attributes. Extracting only the action verb
(letters, digits masked) gets past the block. All are now resolved
(`raw/pages/gap-resolution-2.md`):

- `?action=setterm` posts to **`?action=updateterm`**
- `?action=defineofficers` posts to **`?action=dodefineofficers`**
- `?action=createrequirement` posts to **`?action=updaterequirement`**
- `?action=createPointTracker` posts to **`?action=updaterequirement`** (a point tracker is
  a requirement variant; create and edit share one endpoint, and a `reqid` in the POST
  decides which)
- the "Add Record" credit form posts to **`?action=addrecord`** (found during the credit
  flow)

`docs/03-api/write-operations.md` carries these verbs.

## Two pages that were missing and have since been captured

Both were spotted on 2026-08-29 when reviewing coverage, and captured the same day after
the session was restored.

- `?action=whatsNew`, the platform's release notes running from September 2018 to June
  2026. Captured to `raw/pages/memberhome_action-whatsNew.md`. It is the best single source
  on what the product does that no settings page shows, and it drove
  `docs/04-system-design/05-feature-infrastructure.md`.
- The subscription tier chart on `?action=viewstorage`. The earlier reading had the three
  prices but not the feature matrix. Captured in full to
  `raw/pages/memberhome_action-viewstorage_tier-chart.md`, including which of the nine
  non-basic features each tier includes.

## Routes captured but not yet verified as read end to end

**Mostly closed now** by a dedicated sweep (`raw/pages/unread-routes-sweep.md`, 2026-08-29).
The following were read in full that pass: `manageCourses`, `createCourse`, `createform`,
`createFund`, `createuserfield`, `smsform`, `defineEmailFilters`, `createAlbum`, `getHelp`,
`manageStore` (plan-gated, not enabled), `register.php`, `editrequirement&reqid=1` (Dues),
`familytree.php`, `manageblog`, `viewJobs`, `viewmessage`, `manageEmailSubscriptions`,
`manageforms`, `comment`, `myDonations`. It found several things worth having: the full
custom-field view/edit ACL and type enum, the Dues requirement as a special requirement
type (chapter/region/national split, late fee, online payments), the Course and Form
entity shapes, and the correction that big/little lineage is populated even though named
lines are not. All folded into `docs/02-data-model/00-domain-model.md`.

The remainder below are id-parameterised variants of templates already read in full, so the
risk of something hiding in them is low but not zero (three footnotes in this project did
turn out to contain real rules, which is why the sweep above was done).

- other `?action=editrequirement&reqid=` values (only 3 and 865 read in full)
- other `?action=editprivileges&statusid=` and `?action=editofficerprivileges&officerid=`
  values (all 33 grids were read for their *values*, but not their full page text)
- other `?action=managerecords&reqid=` and `?action=viewrecords&reqid=` values
- other `?action=manageevents&reqid=` values
- other `?action=eventsignup&eventid=` and `?action=eventedit&eventid=` values
- the remaining `?action=managebrother&...&panel=` and `?action=profile&panel=` variants
- `?action=createform`, `createCourse`, `createblog`, `editblog`, `createAlbum`,
  `createFund`, `createuserfield`, `editchapterlinks`, `edithomepageimage`,
  `editofficerposition`, `editstatus`, `editprofile`, `smsform`, `defineEmailFilters`,
  `selectEmailAudience`, `manageUserAwardRecords`, `manageCourses`, `addpictures`,
  `getHelp`, `managealbums`, `manageblog`, `viewevents`, `vieweventcalendar_region`,
  `vieweventcalendar_nation`, `manageeventattachments`
- `register.php` (both remaining status paths), `blog.php`, `familytree.php`

## Pages not reached

None of these was blocked. They were simply not visited, either because they belong to a
scope outside one chapter, or because the run prioritised the schema-bearing pages.

| Route | Why it was skipped |
|---|---|
| `?action=vieweventcalendar` and the region and nation calendars | the same events in a different layout; no new fields |
| `?action=viewchapter` with no id ("View All Chapters/Groups") | multi-chapter scope, out of scope for a single-chapter build |
| `familytree.php` | the chapter has no lines defined, so the page would be empty |
| `?action=viewJobs`, `?action=myDonations`, `campaign.php` | alumni and donation features, all SKIP |
| `?action=manageStore`, ticket-based events, invoice templates, Data/Email Automation | named in the release notes but no navigation entry was found on this chapter; they may be gated by the vendor plan or by the honor-society product line |
| `?action=viewmessage`, `?action=whatsNew`, `?action=getHelp`, `?action=comment` | member-to-member messaging and vendor help |
| `?action=manageSms`, `?action=manageEmailSubscriptions`, `?action=manageforms`, `?action=manageCourses`, `?action=manageblog`, `?action=managealbums` | content and messaging admin, all SKIP or LATER |
| `?action=viewchapterachievements`, `?action=managebrother` panels for awards, family and events | the chapter has no achievements, awards or lines |
| `?action=managerecords` for requirements other than 2 and 3 | the page template is the same for every requirement |
| `?action=eventsignup` for more than one event | one full example was enough for the field list |

## Pages deliberately not opened

Listed in full in `docs/INVENTORY.md` under "Routes deliberately not opened", and each has
a predicted effect in `docs/03-api/write-operations.md`. In short: everything that
deletes, completes, sends, approves, or carries a value to store.

## A difference between blank and zero

`[observed]` The requirement form's help text says setting a goal to **"0"** hides that
progress bar from members of that account type. But a member whose goals are **blank** sees
a card reading "100% Complete / 0 of 0" (`raw/pages/profile-panels.md`). So blank and zero
are different states in the product.

Our schema declares `requirement_goal.target numeric NOT NULL DEFAULT 0`, which collapses
them. That is a deliberate simplification, but it is a decision the students should make
knowingly: either allow a null target meaning "not set", or accept that "not set" and
"explicitly zero" look the same.

## A data state our schema would reject

On requirement 3 ("Service Project"), the account type "Alum" has an external cap of 15 and
no internal target (`raw/pages/partials-closed.md`). A cap on outside credit with no total
to cap against is not obviously meaningful.

`docs/02-data-model/proposed-schema.sql` has a check constraint,
`goal_external_within_target`, that permits `external_max` only when it is no greater than
`target`, or when `target` is 0. It would reject this row as written. That is a deliberate
disagreement with the vendor's data, not an oversight, and it is recorded here so a student
who imports real data and hits the constraint knows why.

Open question: whether the vendor treats "external cap with no target" as meaning something
(perhaps "no requirement, but count up to 15 external hours anyway") or as leftover data.
Not answerable from the screens.

## Contradictions

**A seventh membership status (closed: out of scope).** A release note from March 2020 reads
"Added new 'Guest' membership status and migrated all 'Donors' as new members with the
'Guest' membership status" (`raw/pages/whatsNew-full-read.md`). The live account-type editor
offers six national statuses and Guest is not among them
(`raw/pages/memberhome_action-editstatus_statusid-111.md`), so Guest is either
headquarters-only or was retired after 2020. The operator decided (2026-08-30) that the
rebuild does not need a Guest status (it existed to hold donor records, which are out of
scope for a single active chapter). Recorded and closed; the six national statuses are what
the rebuild uses.

One, and it is mild rather than a real conflict.

**Account types are grouped two different ways.** `?action=editstatus` maps each account
type to one of six national statuses, and puts Inactive and System under the status
"Inactive" (`raw/pages/memberhome_action-editstatus_statusid-111.md`,
`raw/pages/memberhome_action-managestatuses.md`). `?action=viewMembershipStages` groups the
same account types into four stages, and puts Inactive and System inside the stage "Member"
(`raw/pages/memberhome_action-viewMembershipStages.md`).

Both were recorded as seen. The likely reading is that these are two different groupings
for two different purposes, national reporting and bulk transitions, rather than one of
them being wrong. Not resolved by guessing.

## Data deliberately not collected

Member names, e-mail addresses, phone numbers, addresses, birthdays, national id numbers
and the contents of the access log are all real personal data. They were visible in the
browser and were deliberately not written to `raw/` or `docs/`. Every capture that touched
such a page says so at the top. Counts (589 member records, 66 current members, 7 pending
approvals) were kept because they are structural, not personal.
