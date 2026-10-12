# What each form would do

> Summary: Every form and every action link found on the site, and what it would do if
> someone used it. Worked out by reading the pages. Most effects are predictions; a small
> number of write operations were run once, with the operator's explicit permission, on
> throwaway data (the operator's own record, or a test event/blog post that was deleted
> afterward), and those are marked [verified].
> Status: OBSERVED (form structure observed; most effects predicted; a few verified)
> Read this if: you want to know how the existing site changes its data.
> Depends on: docs/INVENTORY.md

Every "predicted effect" below is a **prediction** unless it is marked **[verified]**. For
almost every form, the structure (its target, its method, its field names, its option
values) was read from the page and nothing was submitted.

The exceptions: the operator explicitly authorized running a few writes to see their real
effect, always reversibly and on data that was then cleaned up. Those runs are recorded in
`raw/pages/event-lifecycle-observed.md`, `raw/pages/blog-lifecycle-observed.md`, and
`raw/pages/self-flows-observed.md`. Where a section below is marked **[verified]**, that
run is the evidence. No other member's data was touched.

Two notes before the list.

**The site posts to itself.** Every write is a POST back to `memberhome.php` with an
`action` verb in the query string, for example `?action=updaterequirement`. The `action`
verb is the name of the operation.

**Every POST form carries a hidden field named `__csrf_magic`.** It holds a session token.
It is recorded as `<redacted>` everywhere. A CSRF token is a value the server puts in the
form and checks when the form comes back, so that another website cannot make your
browser submit the form on your behalf.

---

## Permissions

### Create an officer position

- Where: `?action=editofficerpositions`
- Sends: POST to `?action=addofficerposition`
- Fields sent: `__csrf_magic`, `title` (text, required, max 75),
  `officerOrAdvisor` (radio: `officer`, `advisor`, `both`)
- Predicted effect: creates one officer-position record for this chapter, with a name and
  a flag saying whether it is an officer role, an advisor role, or counts as both.
- Confidence: high. The form has three fields and the button says "Add Position".
- Not verified: we did not submit this form.

### Change which privileges a position has

- Where: `?action=editofficerprivileges&officerid=<id>`
- Sends: POST to `?action=updateofficerprivileges`
- Fields sent: `__csrf_magic`, `priv[officerid]` (hidden, the position id), and one radio
  pair per privilege named `priv[<key>]` with values `true` and `false`. The full key list
  is in `raw/pages/memberhome_action-editofficerprivileges_officerid-2892.md`.
- Predicted effect: replaces the whole privilege set for that one position. Because every
  privilege is submitted on every save, this is a full overwrite rather than a change of
  one row.
- Confidence: high for the overwrite reading. Every privilege is present in the form with
  an explicit true or false, so the server receives the complete state.
- Not verified: we did not submit this form.

### Change which privileges an account type has

- Where: `?action=editprivileges&statusid=<id>`
- Sends: POST to `?action=updateprivileges`
- Fields sent: `__csrf_magic`, `statusid` (hidden), one radio pair per privilege named
  `priv[<key>]`.
- Predicted effect: same shape as the position version, but for an account type. Full
  overwrite of that account type's privileges.
- Confidence: high.
- Not verified: we did not submit this form.

### Create or edit an account type

- Where: `?action=editstatus` (create) and `?action=editstatus&statusid=<id>` (edit)
- Sends: POST to `memberhome.php?action=updatestatus`
- Fields sent: `__csrf_magic`, `statusid` (hidden, present when editing), `name`,
  `plural`, `memberStatusId` (select: 2 Active, 3 Alumni, 51 Deceased, 4 Inactive, 1 PNM,
  0 Prospect), `userids[]` (a checkbox per member in the chapter)
- Predicted effect: writes one account-type record, and in the same submission reassigns
  every checked member to that account type. The page warns, verbatim, "If you uncheck a
  member they will be reset to 'Inactive' account type", so unchecking also writes to
  member records.
- **This is a case where one form writes to two different things.** It edits a definition
  and it edits the people classified by it.
- Confidence: high for the account-type write; high for the membership write, because the
  page states the unchecking rule itself.
- Unclear: whether the same URL creates when `statusid` is absent, or whether there is a
  separate create verb. The "Create Account Type" link points at `?action=editstatus` with
  no `statusid`, which suggests one form handles both. Recorded in GAPS.
- Not verified: we did not submit this form.

### Delete an account type or an officer position

- Where: row links on `?action=managestatuses` and `?action=editofficerpositions`
- Sends: GET to `memberhome.php?action=deletestatus&statusid=<id>` and
  `?action=deleteofficerposition&officerid=<id>`
- Predicted effect: deletes that definition. These are GET links that perform an action,
  so simply following the link is the deletion.
- Confidence: high that they delete. What happens to the members or assignments that
  point at the deleted row is unknown.
- Not opened. Recorded as a URL only.

### Assign members to officer positions

- Where: `?action=defineofficers`
- Sends: POST to `?action=dodefineofficers`
- Fields sent: `__csrf_magic`, and for each of 26 rows `officers[N][positionId]`,
  `officers[N][user]`, `officers[N][userId]`, sometimes `officers[N][email]`, plus
  `users[<userId>][newStatus]` and a `sendInvitations` flag. Button: "Update Officers and
  Send Activation Emails".
- Predicted effect: replaces the whole set of officer assignments for the chapter, sets
  each named member's account type, and sends activation e-mail. The page states the mailing
  rule at the bottom, verbatim: **"Activation emails will only be sent to members who
  haven't yet activated their accounts."** So the submit does not mail everyone listed
  (`raw/pages/full-read-pass-2.md`).
- Probably writes to: officer assignments, member account types, and an outgoing mail
  queue.
- Confidence: high for assignments and account types (the page says removed officers are
  "returned to the 'Active' account type"); high for e-mail, because the button says so.
- Not verified: we did not submit this form. **This form sends e-mail, so it is doubly
  off limits.**

---

## Requirements

### Create a requirement (event type)

- Where: `?action=createrequirement`
- Sends: POST to `?action=updaterequirement`. Create and edit share one endpoint (the same
  pattern as account types posting to `updatestatus`); a `reqid` in the POST decides create
  versus update.
- Fields sent: `__csrf_magic`, `text_what` (max 50), `text_unit` (max 25), `isSplit`,
  `newCategories[1]`, `isPercentage`, `isExternal`, and
  `goal[<accountTypeId>][internal]` and `goal[<accountTypeId>][external]` for all 14
  account types.
- Predicted effect: creates one requirement, its categories if split, and one goal row per
  account type holding an internal target and an external cap.
- Confidence: high for the fields; medium for the target URL, which we could not read.
- Not verified: we did not submit this form.

### Edit a requirement

- Where: `?action=editrequirement&reqid=<id>`
- Sends: POST to `?action=updaterequirement`
- Fields sent: as above, plus hidden `id`, and when the requirement is split,
  `existingSubGoal[<categoryId>][<accountTypeId>][internal|external]`.
- Predicted effect: overwrites the requirement's labels, flags and every goal.
- Confidence: high.
- Not verified: we did not submit this form.

### Create a point tracker

- Where: `?action=createPointTracker`
- Sends: POST to `?action=updaterequirement` (button "Create Point Tracker"). A point
  tracker is a requirement variant, so it shares the requirement create/edit endpoint.
- Fields sent: `__csrf_magic`, `isPointTracker` (hidden flag), `external` (hidden),
  `text_what`, `text_unit`
- Predicted effect: creates a requirement record with the point-tracker flag set and no
  goals.
- Confidence: medium-high. The two label fields have the same names and lengths as the
  requirement form, so it is the same record type with a flag.
- Not verified: we did not submit this form.

### Delete a requirement

- Where: `?action=managerequirements` row links
- Sends: GET to `?action=removerequirement&reqid=<id>`
- Predicted effect: deletes the requirement. What happens to credits already recorded
  against it is unknown, and matters: the credits are chapter history.
- Not opened.

---

## Credits and records

### Add a credit by hand [verified]

- Where: `?action=viewrecords&reqid=<id>` (and the same panel inside Account Manager)
- Sends: POST to `?action=addrecord`
- Fields sent: `__csrf_magic`, `userid` (hidden), `title` (max 100), `date`, `units`
  (max 5), `requirementCategoryId` (select, only when the requirement has categories),
  `isExternal` (radio 0 or 1). Button: "Add Record".
- Effect: creates one credit row for that member against that requirement, with a
  free-text title, a date, an amount, an optional category, and a flag saying whether it
  came from a chapter event or from outside.
- Writes to: the credit table only. No event id is sent, which is direct evidence that a
  credit does not need an event.
- Confidence: high.
- **[verified]** The operator added a 1-hour credit to their own Service Hours record: the
  requirement total moved from 48.5 to 49.5 and a new row appeared. Deleting that row
  (GET `?action=deleterecord&recordid=<id>`) moved the total back to 48.5 and removed the
  row. So a single credit row is independently addressable by `recordid` and its deletion
  cleanly reverses the total. This is unlike deleting an *event*, which does not remove the
  credit it awarded (`raw/pages/event-lifecycle-observed.md`). Evidence:
  `raw/pages/self-flows-observed.md`, Flow A.

### Complete an event and award credit to everyone who attended

- Where: `?action=pendingevents` and the event page's Admin Actions
- Sends: GET to `?action=eventcomplete&eventid=<id>`
- Predicted effect: for every attendee on the event's list, creates the credits described
  by the event's credit rows, and marks the event complete. The page says so in plain
  words: "Completing events awards each attendee credit for attending the event which is
  reflected in their requirement progress bars on their homepage."
- Probably also writes: a notification per member. The notifications page shows messages
  of the form "For attending <event> you've been credited with: 1 Meeting, 1 Required
  Event."
- Confidence: high, because the site states the effect on the page.
- Not opened. **This is the single most consequential action link on the site.**

---

## Events

### Create an event

- Where: `?action=eventcreate`, optionally `&reqid=<id>` to prefill one credit row
- Sends: POST, button "Add Calendar Event"
- Fields sent: about 60 fields all namespaced `eventinfo[...]`. The full list is in
  `raw/pages/memberhome_action-eventcreate.md`.
- Predicted effect: creates one event, its shift rows, its credit rows
  (`req_N_units`, `req_N_id`, `req_N_isPerShift`), its coordinator links, and, when
  `recur_isRepeat` is set, one event record per occurrence.
- Evidence for the last part: the access log shows five events created one second apart
  with the same title and five different event ids
  (`raw/pages/memberhome_action-viewlog.md`).
- May also write: invitations to other chapters when `invitewhom` is `custom`, and an
  event group when `isGroupedEvent` is `new`.
- Confidence: high for the event and credit rows; high for recurrence, from the log.
- Not verified: we did not submit this form.

### Edit an event

- Where: `?action=eventedit&eventid=<id>`
- Sends: POST
- Fields sent: the create fields, plus hidden `eventid` and `eventinfo[recurringScope]`.
- Predicted effect: updates the one event. `recurringScope` most likely decides whether
  the edit applies to this occurrence only or to the whole repeating series.
- Confidence: high for the update; medium for the meaning of `recurringScope`, which is
  inferred from its name and from the fact that recurrence creates several records.
- Not verified: we did not submit this form.

### Delete an event

- Where: event page Admin Actions
- Sends: GET to `?action=eventdelete&eventid=<id>`
- Predicted effect: deletes the event. Whether credits already awarded from it survive is
  unknown.
- Not opened.

---

## Members

### Edit a member's profile [verified]

- Where: `?action=managebrother&userid=<id>&chapterid=311&panel=account`, and the member's
  own `?action=editprofile`
- Sends: POST to `?action=updateprofile`, submit button named `edit`
- Fields sent: `__csrf_magic`, `userid`, then about 45 fields named `profile[...]`,
  including `profile[visibility][<n>]` for each field that has a visibility setting, one
  numbered custom field `profile[473]`, and `chapternumber[311]`.
- Effect: updates the person's profile, their per-field visibility settings, and their
  member number within chapter 311.
- Writes to: a person record and a per-chapter membership record, because
  `chapternumber[311]` is keyed by chapter.
- Confidence: high for the profile; medium-high for the split between person and
  membership, which is inferred from the field naming.
- **[verified]** The operator changed one field on their own profile (the free-text "About
  Me", which was empty) to a test value and submitted: the page returned "Profile Updated"
  and the value displayed. Setting it back to empty and submitting restored it. Confirms
  `updateprofile` writes the whole profile row and a single field round-trips. Two data
  facts also came from this form (see `raw/pages/self-flows-observed.md`, Flow C): each
  profile field carries its own **visibility scope** (Anyone / Anyone + Staff / Alpha Delta
  Only + Staff / Hidden (Staff Only) / Officers), stored as `profile[visibility][<id>]`;
  and edits are **versioned** ("any updated values are saved... clear your profile
  history"), with per-field revert arrows.

### Add education or work history to a profile [work history verified]

- Where: the profile editor `?action=editprofile`, "Education History" and "Work
  Experience" sections, each opening a small dialog.
- Sends: POST. Action verbs read from the dialogs:
  - education: `?action=addEducationHistory`, fields `institution`, `degreeLevel` (radio),
    `degree`, `monthJoined`/`yearJoined`, `monthEnded`/`yearEnded`, `city`, `state`,
    `country`
  - work: `?action=addUserJob`, fields `company` (autocomplete, with hidden `companyId`),
    `title`, `industryId` (select), `monthJoined`/`yearJoined`, `monthEnded`/`yearEnded`,
    `city`, `state`, `country`
- Effect: adds one child row to the member (a one-to-many list, not a profile field).
  Removal is a per-row trash control (`a.removeHistory` carrying `data-userjobid`, an AJAX
  delete).
- **[verified]** for work experience: the operator added a job with only a title (employer
  left blank, so **employer is optional**), saw it listed, then deleted it and the list
  returned to empty. Education was read but not executed, to avoid touching the operator's
  real education entry. Evidence: `raw/pages/self-flows-observed.md`, Flow F. These confirm
  that a member profile has separate child tables for education and work history (each
  linking to a normalized institution / company + industry lookup), alongside the EAV
  `profile[...]` scalar fields.

### Log or delete a Timeline activity [delete verified]

- Where: the member Timeline, `?action=profile&panel=timeline`.
- Log: a "Log Activity" form, POST, fields `activityType` (select: Membership Status
  Change, Received Award, Unlocked Achievement, Elected Officer Position, and so on), a
  date, and templated fields that depend on the type (for "Elected Officer Position", a
  role and a chapter). Predicted effect: adds one activity row to the member's timeline.
  Not run.
- Delete: each row has a trash control, GET
  `?action=profile&...&subAction=deleteActivity&activityId=<id>`.
- **[verified]** the delete: removing a leftover "Received Award" entry returned "Timeline
  activity removed". Note the key behavior: **deleting the underlying record does not remove
  its timeline entry** (the award was already deleted, yet its "Awarded the..." entry
  remained until deleted separately). The timeline is an independent, append-style log. See
  `raw/pages/gap-resolution-2.md` and the Activity entity in
  `docs/02-data-model/00-domain-model.md`.

### Add a member to the chapter

- Where: `?action=inviteuser`
- Sends: POST, three different forms
  - existing member: `chapterid`, `inviteUser`, `userId`, `status`, `positions[]`,
    submit `inviteExistingUser`
  - manual entry: `chapterid`, `firstname`, `middlename`, `lastname`, `suffix`,
    `nickname`, `email`, `status`, and by the same pattern `positions[]`
  - CSV upload: a file input
- Predicted effect: for an existing member, creates a membership linking that person to
  this chapter with an account type and optional positions. For manual entry, creates the
  person and the membership together. For CSV, creates many of both.
- Confidence: high. The page's own words are "Transfer students, or students graduating
  from another school to yours, may already be in the system", which only makes sense if
  people and chapter memberships are separate records.
- Not verified: we did not submit any of these forms.

### Approve pending registrations

- Where: `?action=userspending` ("Pending Users")
- Sends: POST to `?action=approveusers`, submit named `Approve`
- Fields sent: `__csrf_magic`, and per pending person `userid[N]`, `status[N]`,
  `positions[N][]`.
- `status[N]` is a single dropdown, options verbatim: **Skip, Reject, Prospect, Potential
  New Member, Active, Associate, Bad Standing, Half-Active, Inactive, Leave of Absence,
  Officer, System, Advisor, Alum, Honorary, Deceased**. The first two decline; any account
  type approves the applicant as that type.
- Predicted effect: turns each pending registration into a real membership with the chosen
  account type and positions, and lets that person log in; Skip leaves them queued and
  Reject declines them.
- Confidence: high (the form and its option list were read directly,
  `raw/pages/signup-flow-observed.md`).
- Not verified: we did not submit this form.

### Move members between membership stages

- Where: `?action=viewMembershipStages`
- Sends: POST
- Fields sent: `stageId` (20), `targetStageId` (10), `userIds[]` (66 checkboxes).
  Button: "Graduate Members »".
- Predicted effect: changes the account type of every checked member from a
  Member-stage type to an Alumni-stage type.
- Unclear: which specific account type each member ends up with, since the stage is a
  group of several account types. Recorded in GAPS.
- Not verified: we did not submit this form.

---

## Money

### Log a payment or charge a fee

- Where: `?action=managedues`, `&prefillType=payment`, `&prefillType=fee`
- Sends: POST
- Fields sent: `__csrf_magic`, `type` (radio, payment or fee), `brother` (typed name),
  `userid` (hidden), `method` (Cash, Credit, Check, Other), `methodOther`,
  `methodOtherTransactionId`, `amount`, `memo`
- Predicted effect: creates one transaction row against one member, either increasing what
  they owe (fee) or decreasing it (payment). The page says "Payments will be deducted from
  a member's balance", so a balance is derived from these rows rather than stored as a
  flag.
- Confidence: high.
- Not verified: we did not submit this form.

### Allocate a budget, or create a custom budget

- Where: `?action=managebudget`
- Sends: POST, two forms
  - allocate: `budgetIdentifier` (select), `amount`
  - create: `title`, `budget`
- Predicted effect: sets an allocated amount against an officer position or a named
  budget. Expenses and income are then summed from the transaction ledger.
- Confidence: medium-high. The allocation write is clear; that the other three columns are
  derived from transactions is inferred from the ledger's officer filter.
- Not verified: we did not submit these forms.

---

## Chapter settings

### Set the term dates

- Where: `?action=setterm`
- Sends: POST to `?action=updateterm`, button "Update Term Dates"
- Fields sent: `calendar` (semester or quarter), then `semester[month1]`,
  `semester[day1]`, `semester[month2]`, `semester[day2]` and the four quarter pairs.
- Predicted effect: stores the recurring month and day on which each term begins.
- Why this matters: it changes what "this term" means everywhere, including every progress
  bar and every default report window. It is a small form with a very large blast radius.
- Confidence: high.
- Not verified: we did not submit this form.

### Set the timezone

- Where: `?action=editsitesettings`
- Sends: POST to `memberhome.php?action=updatesitesettings`
- Fields sent: `timezone`, `adjustTimes` (true or false)
- Predicted effect: stores the chapter timezone, and when `adjustTimes` is true, shifts
  every stored event time so displayed times stay the same.
- Confidence: high; the page explains the second effect in words.
- Not verified: we did not submit this form.

### Edit the chapter profile

- Where: `?action=editchapterinfo`
- Sends: POST
- Fields sent: `chapterid`, `dateEstablished`, `dateReestablished`, and
  `chapterinfo[1]` through `chapterinfo[9]`, `chapterinfo[20]`, `chapterinfo[21]`
- Predicted effect: writes one row per numbered field for this chapter.
- Confidence: medium-high. The numbered field names strongly suggest a table of
  (chapter, field id, value) rather than one column per attribute.
- Not verified: we did not submit this form.

---

## Content, achievements and awards

### Create an achievement

- Where: `?action=createchapterachievement`
- Sends: POST
- Fields sent: `title` (max 100), `description` (max 255), `condition` (automatic or
  manual), `units` (max 10), `reqid`, `isLifetime`, `isLifetime_manual`
- Predicted effect: creates one achievement definition. When the condition is automatic,
  the system awards it when a member's total for that requirement reaches `units`, either
  within one term or across their lifetime.
- Confidence: high; the sentence on the page states the rule.
- Not verified: we did not submit this form.

### Create or edit a chapter award

- Where: `?action=manageUserAwards`
- Sends: POST, two forms
- Fields sent: `award[name]` (max 255), `award[description]`, and `award[awardid]` when
  editing
- Predicted effect: writes one award definition. Which member holds an award is written
  elsewhere, from the ballot or from the member's Awards tab.
- Confidence: high for the definition; the granting operation was not captured. In GAPS.
- Not verified: we did not submit these forms.

---

## Action links that change data on a plain GET

These deserve their own list, because a reader who assumes GET is safe will get this
wrong. Following any of these links performs the action. None was opened.

| Link | Predicted effect |
|---|---|
| `?action=setnotifyupcomingeventsflag&notify=1` / `&notify=0` | turns the weekly event digest e-mail on or off for the logged-in member |
| `?action=eventcomplete&eventid=<id>` | awards credit to every attendee of that event |
| `?action=eventdelete&eventid=<id>` | deletes the event |
| `?action=deletestatus&statusid=<id>` | deletes an account type |
| `?action=deleteofficerposition&officerid=<id>` | deletes an officer position |
| `?action=removerequirement&reqid=<id>` | deletes a requirement |
| `?action=goLiveInvitations` | sends activation e-mails to members |
| `?action=logout` | ends the session |
| `?action=refreshUserInfo` | name suggests it rewrites the cached account record; effect unknown |
| `?action=editcompletedevent&eventid=` | "Update attendees" on an event whose credit has already been awarded; changing the list would change who holds credit |
| "Clear Votes and Reset Poll" (a button on `?action=manageballot`) | clears every vote and resets the award poll to its pre-open state, keeping the ballot setup |
| `?action=eventattendeeremove` | removes one member from an event's attendee list; the counterpart of the access log's "Removed ... from the ... event sign-up sheet" |
| `?action=resetPassword` | resets or re-sends a password for a member, from the Account Manager |
| `?action=deleteblog&blogid=` | deletes a blog post |

**A lesson for the students' own build.** A link that changes data should never be a plain
`GET`. Browsers, link previewers, and prefetchers follow links on their own. Use a form
that POSTs, and confirm destructive actions on a separate page.

---

---

## Forms found in the later passes

These were found after the first pass, in the Diamond sweep and the completeness pass. Same
rules: read from the page, never submitted, every effect a prediction.

### Post a blog entry

- Where: `?action=createblog`
- Sends: POST, button "Post Entry"
- Fields sent: `__csrf_magic`, `newId` (hidden, issued before saving), `ptitle` (max 255),
  `pcontent` (textarea, rich text), `pvisibility` (radio: `public`, `private`),
  `publishDate` (max 10)
- Predicted effect: creates one blog post with an audience and a publish date. The `newId`
  is almost certainly the id that images uploaded into the editor are attached to before
  the post exists.
- Confidence: high for the record; medium for the `newId` reading, which is inferred from
  the field being pre-populated on an unsaved form.
- Not verified: we did not submit this form.

### Edit a blog entry

- Where: `?action=editblog&blogid=<id>`
- Sends: POST
- Fields sent: `__csrf_magic`, `blogid` (hidden), `ptitle`, `pcontent`
- Predicted effect: updates the title and body only. `pvisibility` and `publishDate` are
  **not on this form**, so editing cannot change a post's audience or publish date.
- Confidence: high that they cannot be changed here. Whether another screen can change them
  is unknown, and is in GAPS.
- Not verified: we did not submit this form.

### Delete a blog entry

- Where: row link on `?action=manageblog`
- Sends: GET to `?action=deleteblog&blogid=<id>`
- Predicted effect: deletes the post. Another action link that writes on a GET.
- Not opened.

### Create a form

- Where: `?action=createform`
- Sends: POST
- Fields sent: `__csrf_magic`, `title`, `image` (header image), `description`, `audience`,
  `scope`, `sendTo`, `memberStatusId[]` x6, `officerFilter` x3, `accountTypeIds[]` x14,
  `type`, `duedate`, `dateToOpenOption`, `dateToOpen`, `dateToCloseOption`, `dateToClose`,
  `isAnonymous`, and per question `newQuestions[N][sortOrder]`,
  `newQuestions[N][question]`, `newQuestions[N][subtext]`, `newQuestions[N][type]`,
  `newQuestions[N][isRequired]`, `newQuestions[N][isConfirmation]`
- Predicted effect: creates one form, its audience rule, its open and close window, and one
  row per question.
- **Watch this one:** a question of type `userField` is labelled "Member Field to Update",
  so submitting an answer to such a question would write into the answering member's
  profile. A form is therefore not only a collector; it can be a writer.
- Confidence: high for the structure; high for the write-back, from the option's own label.
- Not verified: we did not submit this form, and we did not fill in a form either.

### Create a course

- Where: `?action=createCourse`
- Sends: POST
- Fields sent: `__csrf_magic`, `courseTitle` (max 100), `courseDescription` (max 255),
  `showSetting`, `dateToShow`, `forceOrder`, `limitSessions`, `scope`, `sendTo`,
  `memberStatusId[]`, `officerFilter`, `accountTypeIds[]`
- Predicted effect: creates a course with a publish setting, a module ordering rule, a
  repeat policy and an audience. Modules and a certificate are added afterwards.
- Confidence: high.
- Not verified: we did not submit this form.

### Create a fundraising fund

- Where: `?action=createFund`
- Sends: POST
- Fields sent: `__csrf_magic`, `title` (max 255), `description`, `paymentOptionGroupId`,
  `trackAsIncome` (radio)
- Predicted effect: creates a fund. `trackAsIncome` decides whether a donation to this fund
  writes only a donation record, or a donation record **and** a transaction ledger entry.
- Confidence: high; the radio's own label says "Track as both a donation and a transaction."
- Not verified: we did not submit this form.

### Log a transaction

- Where: `?action=viewtransactions`
- Sends: POST
- Fields sent: `__csrf_magic`, `txnname_other` (free-text payer), `txnname_user` (a member),
  `budgetIdentifier` (20 options: None plus the 19 positions), `type`, `amount`, `memo`,
  `file[]`, `transactionDate`
- `type` options, verbatim: Withdraw, Deposit, Dues Payment, Fee Assessment
- Predicted effect: creates one ledger row, optionally attributed to a budget and to a
  member, optionally with an attached receipt.
- Confidence: high.
- Not verified: we did not submit this form.

### Send an SMS

- Where: `?action=smsform`
- Sends: POST
- Fields sent: `__csrf_magic`, `type` (hidden), `filter` (radio), `filter_eventid`,
  `accountTypeId[]` x14, `message` (max 128)
- Predicted effect: sends one SMS to every member matching the audience.
- **This form sends messages to real people's phones. It is doubly off limits.**
- Not verified.

### Send bulk e-mail

- Where: `?action=selectEmailAudience` or `?action=defineEmailFilters&eventid=<id>`
- Sends: POST, step 1 of 4
- Fields sent: `__csrf_magic`, `id`, `type`, `scope`, `filter`, `filter_eventId`,
  `accountTypeId[]` x14, plus member-field filters added dynamically
- Predicted effect: step 1 records the audience and moves to the subject step. Only the
  final step sends.
- **Not submitted, so steps 2 to 4 were never seen.** Recorded in GAPS.

### Send a comment to the officers

- Where: `?action=comment`
- Sends: POST
- Fields sent: `__csrf_magic`, `comment[comment]` (textarea), `comment[anon]` (checkbox),
  `commentsubmit`
- Predicted effect: creates one comment addressed to the officers. When `anon` is set the
  name is withheld but the account type is still shown, which the page states.
- Confidence: high.
- Not verified.

### Edit an officer position's title

- Where: `?action=editofficerposition&officerid=<id>`
- Sends: POST, button "Update Office Position"
- Fields sent: `__csrf_magic`, `officerid` (hidden), `title`
- Predicted effect: renames the position. The officer/advisor flag is not on this form, so
  it appears to be fixed at creation.
- Confidence: high for the rename; medium for the flag being unchangeable, which is
  inferred from the field's absence.
- Not verified.

### Upload a file to the file manager, or link an external one [verified for member attachments]

- Where: `?action=viewstorage` (chapter file manager), and per-member attachments at
  `?action=managebrother&userid=<id>&panel=files`
- Sends: POST with `file[]` (an AJAX auto-uploader; the file uploads the moment it is
  chosen, no submit button), and a second form with `cloudFileTitle`, `cloudFileUrl`,
  `visibility` for linking an externally hosted file. A "Create Folder" control groups
  files.
- Effect: stores an uploaded file, or a reference to a file hosted elsewhere, with a
  sharing scope.
- **[verified]** on the member attachments store: the operator uploaded a small text file
  to their own record. It appeared instantly with filename, uploader ("Added by you"),
  timestamp, size, download count, and a sharing-scope header ("Shared with your Officers,
  Advisors & APO Staff"); deleting it (the row's trash control) emptied the folder.
  Evidence: `raw/pages/self-flows-observed.md`, Flow D. So a file record stores at least
  name, size, uploader, timestamp, download count, folder, and scope, and an attachment is
  either an uploaded blob or an external-link row.

### Upload an attachment to an event

- Where: `?action=manageeventattachments&eventid=<id>`
- Sends: POST with `file[]`
- Predicted effect: attaches a file to that event, visible to "Private - Any Initiated
  Member". The page states these are kept for six months, so something deletes them later.
- Not verified.

### Replace the public homepage image

- Where: `?action=edithomepageimage`
- Sends: POST with `__csrf_magic` and `userfile[]`
- Predicted effect: replaces the image on the chapter's public homepage. Limits stated on
  the page: 2MB, recommended width 700 pixels.
- Not verified.

### Update the public header tabs

- Where: `?action=managetabs`
- Sends: POST (target not read)
- Predicted effect: sets which four tabs appear on the public site, each chosen from BLOG,
  CALENDAR, PHOTOS, HISTORY, MEMBERS, ABOUT.
- Not verified.

---

### Edit the chapter's links, including the navigation menu

- Where: `?action=editchapterlinks`
- Sends: POST, button "Update Links"
- Fields sent: `__csrf_magic`, `chapterid`, `links[facebook][title|url|visibility]`,
  `links[instagram][title|url|visibility]`, `links[homepage][url]`, and nine
  `links[other][N][title|url|visibility]` slots
- `visibility` options: 50 = show only on chapter profile, 60 = show on chapter profile and
  in nav menu, 20 = show only in nav menu
- Predicted effect: replaces the chapter's whole link set in one submission. Because all
  slots are posted together, a blank slot is a deletion.
- Confidence: high.
- Not verified: we did not submit this form.

### Give an award to a member [verified]

- Where: `?action=manageUserAwardRecords`, and the Awards panel of the Account Manager
  (`?action=managebrother&userid=<id>&panel=awards`)
- Sends: POST to `?action=addUserAwardRecord`
- Fields sent: `__csrf_magic`, `chapterid`, `awardid`, `subtitle`, `brother`, `userid`,
  `dateawarded`
- Effect: creates one award record linking a member to an award, with a date and an
  optional subtitle. Five Distinguished Service Key awards are built in (ids 1 to 5);
  chapter-defined awards are additional.
- Confidence: high.
- **[verified]** The operator gave themselves the Chapter Distinguished Service Key
  (awardid 5): the page returned "You were awarded the Chapter Distinguished Service Key".
  The record shows on the member Awards panel (not on the standalone award-recipients list,
  which is for chapter-created awards, and not on `viewmember`). Removing it uses the row's
  trash control, GET `?action=deleteUserAwardRecord&...` (guarded by a browser confirm
  dialog); after it, the panel showed "No awards have been given to this member". Evidence:
  `raw/pages/self-flows-observed.md`, Flow B.
- **Server-side authorization note:** the linked "All Member Awards Report"
  (`?action=awardReport`) returned "Unauthorized — Only staff sites can manage awards" to
  this chapter-admin session. That is a real server refusal (a national-staff level sits
  above chapter admin), and it is a concrete counterexample to "an admin is never blocked".
  See `docs/04-system-design/02-auth-and-permissions.md`.

### Verify or correct the roster

- Where: `?action=verifyRoster`
- Sends: POST
- Fields sent: `__csrf_magic`, `chapterId`, `redirect`, and per member
  `previousMemberStatusIds[N]`, `change[N]` (Approve or Change), `userid[N]`, `status[N]`,
  `positions[N][]`
- Predicted effect: for every member either confirms the current account type or writes a
  new one, together with their officer positions. `previousMemberStatusIds` is sent so the
  server can tell what changed, which is the usual guard against two officers overwriting
  each other.
- The page warns in capitals that this is **not** for transitions, only for corrections.
- Confidence: high.
- Not verified.

### Change one member's account type by hand

- Where: `?action=managebrother&...&panel=status`
- Sends: POST
- Fields sent: `__csrf_magic`, `chapterid`, `userid[N]`, `status[N]`, `positions[N][]` x19,
  `chairTitle[N]`, `notify[N]`, `reasons[N]`
- Predicted effect: sets the member's account type and positions, records a reason, and
  optionally notifies them. A "Revoke Access" option on the same form removes the member
  from this chapter, which the page says leaves their account alive on other chapters'
  sites.
- Confidence: high.
- Not verified.

### Add a big, a little, a line, or a personal family member

- Where: the member's own "Line & Family" tab, `?action=editfamilytree` (and the
  equivalent `?action=managebrother&...&panel=family` for an admin editing someone else),
  four separate forms.
- Sends: POST. The action verbs were read directly from the four forms on
  `editfamilytree`:
  - join or create a line: `?action=updatemyfamily`, fields `familyid` (select existing) or
    `name` (create new)
  - add a big: `?action=addbig`, field `bigname` (name typeahead)
  - add a little: `?action=addlittle`, field `littlename` (name typeahead)
  - add a personal (non-member) family member: `?action=addUserRelationship`, fields
    `relationship` (select, 9 options: a "Select a relationship" placeholder, seven named
    relationships from Mother / Father / Guardian to Niece / Nephew, and Other),
    `otherRelationship`, `firstname`, `lastname`,
    `email`, `phone`
- Predicted effect: each adds one row. Bigs and littles are added one at a time and the
  page states a member may have several of each ("If you have more than one big member or
  little member select each individually"). Removal is "click the red x after their name".
- Confidence: high (all four action verbs and their fields were read from the page).
- Not executed: adding a big/little links another member's record, and joining/creating a
  line touches a shared entity, so these were read but not submitted. This confirms the
  data model directly: big/little is many-to-many (`lineage` join table), a line is its own
  named entity members join (`line` / `line_member`), and personal family is a separate
  table of non-members. Evidence: `raw/pages/self-flows-observed.md`, Flow G.

### Create a custom profile field

- Where: `?action=createuserfield`
- Sends: POST
- Fields sent: `__csrf_magic`, `title`, `subtitle`, `mergeCode`, `isUnique`, `type`,
  `options[]`, `filterByStatus`, `filterByStatusIds[]`, `isStaffOnly`, `importance`,
  `visibility`, `priv`
- Predicted effect: creates a field definition that then appears on every member profile,
  and optionally on the public registration form when `importance` is recommended or
  required.
- Confidence: high.
- Not verified.

### Create a photo album

- Where: `?action=createAlbum` (capital A)
- Sends: POST
- Fields sent: `__csrf_magic`, `album[name]`, `album[desc]`
- Predicted effect: creates an album, then sends the user to `?action=addpictures` to add
  photos, which the vendor has switched off.
- Confidence: high.
- Not verified.

### Register a new account

- Where: `/alphadelta/register.php?&statusOption=student` (also advisor, alum)
- Sends: POST
- Fields sent: the full list in `raw/pages/register-and-remaining.md`, including
  `password1` and `password2` (both capped at 15 characters), name fields, two addresses,
  gender, pledge and graduation class, birthday, and a `profile[visibility][N]` per field
- Predicted effect: creates a person record and a pending membership for this chapter, which
  an officer must then approve at `?action=userspending` before the person can log in.
- Confidence: high; the invite page states the approval requirement in words.
- Not verified. **This is a public form and creating an account would be a real change.**

## Forms that only read

For completeness, these submit but change nothing:

- the header search box (GET, fields `userid`, `action=profile`, `searchTerms`), on every page
- the requirement and date-range filters on `?action=managerecords` (GET)
- the report builders `?action=createreport` and `?action=createeventreport` (POST, but
  their output is a report page or a CSV download)
- the ledger date filter on `?action=viewtransactions` (GET)
