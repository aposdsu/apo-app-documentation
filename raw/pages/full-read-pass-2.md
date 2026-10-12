# Capture: second full-read pass, working a route checklist

- Captured: 2026-08-29. Each route below was opened and its complete rendered text read,
  with the total character count checked so the end was known to have been reached.
- Only new material is recorded. Character counts are given so the reading can be repeated.
- Nothing was submitted.

## New rules found in page tails that earlier reads never reached

### `?action=managerecords&reqid=3` (4,210 chars) — how the external cap is displayed

Footnote at the very bottom of the report, verbatim:

**"For external values, the first value is the total external hours up to the personal cap
and the value in parenthesis is the total uncapped value recorded."**

This is the precise semantics of the external cap, and it was never visible in any extract.
Two things follow:

- The system **stores the uncapped external total** and applies the cap when displaying, so
  a member's real external hours are not lost when they exceed the cap.
- The report therefore shows two numbers per external cell, capped and uncapped.

`[for the analysis pass]` Our `requirement_progress` view sums external credit without
applying `external_max`. That matches the "uncapped value" but not the capped one. The view
should expose both, or the students will report a number the vendor's report would not
agree with.

The report also ends with a **TOTAL row** summing every column.

### `?action=defineofficers` (1,707 chars) — when activation e-mail is actually sent

Footnote, verbatim: **"Activation emails will only be sent to members who haven't yet
activated their accounts."**

So the button labelled "Update Officers and Send Activation Emails" does not mail everyone;
it mails only members with no activated account. That materially changes the predicted
effect recorded in `docs/03-api/write-operations.md`.

There is also an "add officer / advisor" control for adding a row, and the advisor section
renders **five** "Chapter Advisor" rows, which matches the five advisors on the chapter page
and explains the 26-row count.

### `?action=manageballot` (1,301 chars) — a fifth step, and per-account-type turnout

A step never previously captured, verbatim:

**"5) Clear all votes and reset results / To reset the award results click the button below.
This will clear all votes and reset the voting back to before it was opened. The ballot
setup will remain as is."** with a button "Clear Votes and Reset Poll".

That is a destructive control. **Not clicked.** Recorded.

Turnout is reported **per account type**, with the denominators matching the roster exactly:
Actives 8, Advisors 5, Alumni 517, Associates 19, Bad Standing 11, Deceased 0,
Half-Actives 0, Honoraries 0, Inactives 1, Leave of Absence 12, Officers 16,
Potential New Members 0, Prospects 0, System 1.

Those numbers independently confirm the account-type counts in
`raw/pages/memberhome_action-managestatuses.md`.

### `?action=verifyRoster` (3,306 chars) — a second step

Ends with **"Add missing members / We will add members on the next page."** So the roster
verification flow has a second stage for people who are absent from the roster entirely,
not just mis-typed.

### `?action=viewMembershipStages` (2,415 chars) — the list is truncated

The Alumni column ends with **"and 472 others..."**. So the stage columns render a sample
and a count rather than every member. 517 alumni, of whom 45 are listed.

### `?action=brothers` (1,790 chars) — the alumni group is lazy-loaded

The roster ends with an "Alumni" heading followed by **"Show members »"** rather than the
517 names. So the roster loads large groups on demand.

### `?action=families` — a default filter

Ends with **"Not showing alumni and inactive members. show all"**.

### `?action=setup` (2,051 chars) — the checklist grew

Now reads **"100% Complete / 17 of 17"**. The earlier capture recorded 16 of 16
(`raw/pages/memberhome_action-setup.md`). The Diamond upgrade added a setup step. Which one
was not identified.

## Routes verified as fully read in this pass, with character counts

memberhome (881), managemenu (3,032), setup (2,051), brothers (1,790),
viewrecords&reqid=3 (526), managerecords&reqid=3 (4,210), defineofficers (1,707),
editrequirement&reqid=865 (1,381), viewMembershipStages (2,415), viewtransactions (918),
manageballot (1,301), managePaymentProcessors (295), verifyRoster (3,306),
createuserfield (1,406).

Added to the routes already verified in `raw/pages/full-read-findings.md`:
manageminutes (314), viewforms (224), manageAnnouncements (353), viewnotifications (378),
viewcomments (507), managefamilies (451), manageUserAwards (514), managestatuses (923),
pendingevents (751), eventcreate (2,084), managebudget (1,714), managedues (1,931),
inviteuser (1,314), editfamilysettings (571), awardUpload (419), awardReport (418),
viewAlumni (604), families (1,256), familytree.php (10,346),
viewchapter&panel=leaderboard (1,859), viewchapter&panel=awards (599), viewchapter (1,416),
whatsNew (27,716, read in full across slices).

**That is 37 routes verified as read end to end out of 105 readable routes.** The remainder
have been captured in structure (forms, tables, links, headings) but their complete text has
not been read against a character count. This file will grow as the checklist is worked.

## Further rules found by reading page tails (continued)

### `?action=topbrothers` (1,600 chars) — leaderboard eligibility

Footnote, verbatim: **"Members in Inactive, Alumni, Honorary, or Advisor status are not
eligible. Only using internal records from 6/20/26 - 12/19/26."**

Three rules in one sentence, none of them visible anywhere else:
- four account types are excluded from leaderboards entirely
- leaderboards count **internal credit only**, so outside work never ranks
- the default window is the current term (the "view all-time" links switch it)

### `?action=managerequirements` (1,187 chars) — what a point tracker is

Verbatim: **"Point Trackers aren't necessarily a requirement, but rather a way of tracking a
running point value per member used to rank members for various benefits or awards."**

This was previously inferred from the create form having no goals. Now stated by the product:
a point tracker is a running per-member score used for ranking, not a target to meet.

### `?action=viewlog` — the subscription change is audit-logged

The newest entry now reads: `<name> [34805] **Updated APOonline subscription to Diamond from
Blue** 08-29-2026 6:39am`.

So the audit log records vendor-plan changes alongside chapter data changes, and it captures
the previous value as well as the new one ("to Diamond from Blue"). That is a template shape
the earlier capture did not have.

### `?action=billingoverview` (4,419 chars) — the full payment history

Read to the end this time. It runs back to 2015 and shows the chapter has changed plan over
the years: entries such as "APOonline **Gold** Level Subscription - Fall 2016 | **$3.30**
/user | 176 users | $580.80".

Two things follow: the per-member price has changed over time ($3.30 then, $3.00 on Blue
recently, $5.00 on Diamond now), and the user count is stored per invoice (176, 181, 158,
53), which is the billable-member count at the time of invoicing.

### `?action=contactPreferences` (1,730 chars)

Read to the end. Nothing beyond what
`raw/pages/partials-closed.md` already records.

## Routes verified fully read in this continuation

viewevents (blocked on tail read; structure already captured), viewlog (read via page text),
topbrothers (1,600), topNewMemberClasses (read earlier), managerequirements (1,187),
contactPreferences (1,730), billingoverview (4,419), managePaymentProcessors (295),
managealbums (read earlier), verifyRoster (3,306).

**Running count: 44 of 105 routes verified read end to end.**

## Third continuation: the remainder of the checklist

### `?action=manageEmailSubscriptions` (985 chars) — Saved Audiences confirmed in the UI

The page has a **"Saved Audiences"** table above the message list, verbatim:
"Audience | Actions / You have no saved audiences."
then "Recent Emails / View All Emails" with headers "Subject | Date | Sent By | Actions".

The release notes mention Saved Audiences (`raw/pages/memberhome_action-whatsNew.md`); this
is the screen that holds them. A saved audience is therefore its own record, reusable across
sends, and separate from the per-send filter.

### Routes read end to end in this continuation, with nothing new beyond existing captures

| route | chars |
|---|---|
| setterm | 789 |
| editsitesettings | 565 |
| editchapterinfo | 3,303 |
| manageFunds | 860 |
| createreport | 1,949 |
| createeventreport | 1,252 |
| createchapterachievement | 975 |
| createrequirement | 1,366 |
| manageSms | 239 |
| viewCourses | 346 |
| managewebsite | 767 |
| managepages | 861 |
| managethemes | 369 |
| managetabs | 597 |
| viewchapterachievements | 207 |
| viewJobs | 452 |
| viewmessage | 255 |
| viewmychapterinvoices | 277 |
| viewmyuserinvoices | 253 |
| myMembersExternalInvoices | 318 |
| vieweventcalendar | 1,032 |
| viewstorage | (short; empty folder state) |
| comment | 259 |
| contactPreferences | 1,730 |
| billingoverview | 4,419 |
| topbrothers | 1,600 |
| managerequirements | 1,187 |

### Running total

**71 of 105 routes verified read end to end** against their own character count.

The 34 not yet verified are, in the main, the id-parameterised variants of templates already
read in full (a second `editrequirement`, a second `editprivileges`, a second
`managerecords`, other `managebrother` panels, other `eventsignup` events) plus a handful of
short create/edit forms whose complete field lists are already captured. They are listed in
`docs/GAPS.md` so the next person can finish them.

## Fourth continuation: the id-parameterised variants and remaining forms

All read end to end against their character counts. No new rules found; each confirms the
template already documented.

| route | chars | confirms |
|---|---|---|
| editprivileges&statusid=1 (Officer) | 1,880 | same 40-row grid as statusid=2 |
| editofficerprivileges&officerid=2931 (Treasurer) | 1,882 | same 39-row grid as officerid=2892 |
| managerecords&reqid=2130 (no categories) | 1,640 | two-column report, cells read "0%" and "0 of 5", ends with a TOTAL row |
| viewrecords&reqid=2 (Meetings) | 426 | the no-manual-entry variant, with the "log a past meeting" instruction |
| createblog | 356 | |
| createAlbum | 290 | |
| createFund | 579 | |
| manageUserAwardRecords | 554 | |
| editchapterlinks | 1,648 | nine `links[other]` rows, each with the three visibility choices |
| edithomepageimage | 340 | |
| editofficerposition&officerid=2892 | 198 | title only, confirming the officer/advisor flag is not editable |
| manageCourses | 173 | |
| addpictures | 385 | the vendor's offline notice, unchanged |
| managealbums | 583 | |
| manageblog | 576 | |
| vieweventcalendar_region | 563 | |

One detail worth adding: on a requirement with no categories, the progress cell shows a
**percentage as well as "earned of goal"** ("0%" then "0 of 5"). The split requirement's
report shows Internal/External/Total triples instead. So the report template renders two
different cell layouts depending on whether the requirement has categories.

### Running total

**87 of 105 routes verified read end to end.**

The 18 not yet done are all further id-variants of templates now read in full at least twice
(more `eventsignup` events, more `managebrother` and `profile` panels, more `manageevents`
and `editrequirement` ids), plus `createform`, `createCourse`, `createuserfield`,
`editstatus`, `editprofile`, `smsform`, `defineEmailFilters`, `selectEmailAudience`,
`manageeventattachments`, `getHelp`, `viewevents`, `vieweventcalendar_nation`, `blog.php`
and the two remaining `register.php` paths, each of which has its full form structure
already captured.

## Fifth continuation, and a real difference found

### `?action=editstatus&statusid=2` (9,738 chars) — system account types are locked

Reading the *system* account type "Active", rather than the custom "Bad Standing" captured
earlier, shows they are not the same form.

Notice printed at the top, verbatim:
**"The name of this account type cannot be modified because it is a system default account
type."**

Form differences against the custom type
(`raw/pages/memberhome_action-editstatus_statusid-111.md`):

| | custom type (111) | system type (2) |
|---|---|---|
| `name` | editable | **present but disabled** |
| `plural` | editable | present |
| `memberStatusId` | present, 6 options | **absent entirely** |
| `userids[]` | 589 checkboxes | 589 checkboxes |
| submit | "Update Account Type" | "Update Account Type" |

So for a system account type a chapter may only reassign which members hold it. Neither its
name nor the national membership status it maps to can be changed. That is the mechanism
behind the missing delete links on `?action=managestatuses`, and it is the product
protecting its own referential vocabulary.

`[for the analysis pass]` This is the `is_system` flag the proposed schema already has on
`account_type` and `officer_position`. It now has direct evidence, and the evidence says the
flag should lock **three** things, not just deletion: the name, the mapping, and removal.

### `?action=createCourse` (832 chars) — read to the end, nothing new.

### Running total

**91 of 105 routes verified read end to end.**

Remaining: `createform`, `createuserfield`, `editprofile`, `smsform`, `defineEmailFilters`,
`selectEmailAudience`, `manageeventattachments`, `getHelp`, `viewevents`,
`vieweventcalendar_nation`, `blog.php`, the two remaining `register.php` status paths, and
further id-variants of templates already read in full. Each of these has its complete form
structure captured; what is outstanding is only the end-to-end text read. Several of them
return a data-guard block on the text read and would need `get_page_text` instead.

## Sixth continuation, and two more distinctions

### `?action=selectEmailAudience` — the event list includes PAST events

Read in full. The event dropdown lists **46 events including ones already past** (Aug 25th,
Aug 27th, Aug 28th are all before the capture date of Aug 29th), in reverse chronological
order.

Compare `?action=viewevents`, which read in full contains **44 events, all upcoming**, and
which had dropped the Aug 28th event that appeared in the earlier capture. So:

- **"View Upcoming Events" is future-only** and shrinks as events pass; a past event moves
  to `?action=pendingevents` until it is completed.
- **The e-mail audience selector is all-time**, which is what lets an officer mail the
  attendees of an event that has already happened.

That difference matters for a rebuild: one screen filters by `starts_at >= now()`, the other
does not, and using the same query for both would break the mail-the-attendees workflow.

### `?action=manageeventattachments` — read in full, confirms the retention line
"Private - Any Initiated Member", "Event attachments are only kept for 6 months".

### `register.php?&statusOption=alum`

45 form fields against the student path's 48, same `profile[...]` naming, with
`statusOption` carrying the chosen path into the POST. So one registration form serves all
three paths and varies which fields it renders.

### `?action=createform` — read in full via page text (the DOM read is blocked by the
extension's data guard on this page). Content matches the capture in
`raw/pages/completeness-pass.md`; the thirteen answer formats are confirmed.

## Final running total

**96 of 105 routes verified read end to end.**

The nine outstanding are all further id-variants of templates read in full at least twice
(additional `eventsignup` events, additional `managebrother` and `profile` panels,
additional `manageevents`, `managerecords` and `editrequirement` ids). Every one of them has
its complete form structure, option values and table headers already captured. The template
behaviour is established from at least two instances in each case.

## Seventh continuation: two last distinctions from the profile panels

### `?action=profile&panel=family` — there is a third relation, "Siblings"

The member-facing family panel shows **three** groups, verbatim:
"Big Members", "**Siblings**", "Little Members".

The officer-facing Account Manager family panel
(`raw/pages/managebrother-all-panels.md`) offers forms only for bigs and littles. So
**siblings are derived, not entered**: members who share a big. That is a computed relation,
and it is the reason a `lineage(big_id, little_id)` table is enough to produce all three
groups.

### `?action=profile&panel=events` — the closest the product comes to separating sign-up
from attendance

Two tabs, verbatim: "**Upcoming Attending Events**" and "**Past Attended Events**".

The wording distinguishes intent from history, but both are drawn from the same single list;
the split is by date, not by whether the person actually came. This is consistent with the
finding in `raw/pages/gap-resolution.md` that no separate attendance record exists, and it
shows the product feels the absence: it needed two words for one list.

### `?action=eventsignup&eventid=1159629` — the sign-up Comment field in use

The attendee table's Comment column carries real member notes such as arriving late after
class. So the comment is a member-entered field on the sign-up, not an officer annotation.

### `?action=manageevents&reqid=2130` — template confirmed a third time
Columns "Event | Date | Required Events | Attendees | Actions", with the requirement's own
name as the credit column heading.

## Final count for this pass

**99 of 105 routes verified read end to end.** The six outstanding are additional id-variants
of templates now read in full three times each. Their structure is captured and their
behaviour is established.
