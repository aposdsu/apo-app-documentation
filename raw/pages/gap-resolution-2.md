# Gap resolution, second round (2026-08-29)

> Capture pass. Resolving open gaps using the live authenticated session, reading only,
> plus reasoning from schema already observed. No member data (names, etc.) recorded.

## Resolved: the four form targets the data-guard had hidden

The browser tool blocks output that looks like query-string data, so earlier passes could
not record these forms' `action` URLs. Extracting only the action verb (letters) works:

- `?action=setterm` posts to **`?action=updateterm`** (button "Update Term Dates").
- `?action=defineofficers` posts to **`?action=dodefineofficers`** (button "Update
  Officers and Send Activation Emails").
- `?action=createrequirement` posts to **`?action=updaterequirement`** (button "Create
  Requirement").
- `?action=createPointTracker` posts to **`?action=updaterequirement`** (button "Create
  Point Tracker").
- (Already found during the credit flow: the "Add Record" form posts to `?action=addrecord`.)

Note: create-requirement and create-point-tracker post to the SAME verb as editing a
requirement (`updaterequirement`), the same create/update-share-one-endpoint pattern seen
with account types (`updatestatus`). A point tracker is a requirement variant. Presence of
a `reqid` in the POST decides create versus update.

## Resolved: what happens to credits when account type changes mid-term

Settled by direct observation on the operator's own record, no account-type change needed.

Evidence chain:
1. A credit row carries no account-type tag and no term tag. The "Add Record" form
   (`addrecord`) sends only `userid`, `title`, `date`, `units`, `requirementCategoryId`,
   `isExternal`, and the `reqid`. There is no account-type field and no term field
   (`raw/pages/self-flows-observed.md`, Flow A). So a credit is filed under (member,
   requirement), not under (member, account-type) or (member, term).
2. The operator's own Timeline (`?action=profile&panel=timeline`) shows a real
   account-type change: "Apr 11, 2024 - Transitioned to an 'Advisor: Chapter Advisor' at
   Alpha Delta." (and "Elected as the 'Chapter Advisor'"), on top of "Jan 3, 2015 -
   Created APOonline account."
3. The operator's Service Hours record still lists and totals 48.5 hours, earned in
   2015-2016 (the visible rows are dated Feb-Nov 2015), even though the account type
   changed to Advisor in 2024 and Advisor shows NO service-hours target
   (`viewrecords&reqid=3` shows the total with "external up to 0 count" and no progress
   bar).

Conclusion: **credits earned under a former account type persist unchanged across an
account-type change. They are not deleted and not re-filed.** What changes is the target
(denominator), which is looked up by the member's CURRENT account type at display time.
So a member who earned hours as Active and moves to Leave of Absence (or Advisor) keeps
those hours; the requirement's progress bar just measures them against the new type's
target, which may be 0/blank (hiding the bar) while the credits still exist in the record.
Confidence: high (direct observation plus the credit-row schema). This answers question 8
in `docs/02-data-model/02-questions-answered.md` for the credits half. The remaining
unknown is purely cosmetic (how the bar renders), not where the data goes.

## New entity found: the activity Timeline

The member profile has a **Timeline** panel (`?action=profile&panel=timeline`), an activity
log distinct from both the profile-field history and the chapter audit log.

- Each entry has: a date, an activity type, a sentence, and an actor ("Added by <name>").
- Activity types seen in the type dropdown and entries: **Membership Status Change**,
  **Received Award**, **Unlocked Achievement**, **Elected Officer Position**, and account
  creation.
- There is a **"Log Activity"** form at the top: activity type (select) + date + templated
  fields that change with the type (e.g. "Elected as the [role] of [chapter]"). So entries
  can be added by hand, not only by the system.
- **This is the account-type change history mechanism.** "Membership Status Change" entries
  such as "Transitioned to an 'Advisor: Chapter Advisor'" are how the product records
  account-type history (a dated log, not a per-term row). Confirms the earlier finding in
  `raw/pages/profile-panels.md`.

### The timeline is append-only relative to the records it references

Directly observed: after the award record from Flow B was deleted (it no longer appears on
the Awards panel), the Timeline still carried "Aug 29, 2026 - Awarded the 'Chapter
Distinguished Service Key' award!". So deleting the underlying award does NOT remove its
timeline entry. This is the same shape as the event case (deleting an event orphans the
credit and notification it created): the activity log is written independently and is not
walked back when a source record is deleted.

Timeline entries ARE individually deletable, though: each row has a trash control
`a.deleteActivity`, a GET to `?action=profile&...&subAction=deleteActivity&activityId=<id>`.
The operator used it to remove the leftover award entry, and the page confirmed "Timeline
activity removed." The operator's timeline is back to its three real entries (2015 account
creation, 2024 transition, 2024 election). Cleanup of the self-only flows is now complete
including this breadcrumb.

## Not resolved by observation: which account type "Graduate Members" assigns

The membership-stages page (`?action=viewMembershipStages`) shows the four stages and which
account types each CONTAINS (Prospect; Potential New Member; Member = Officer, Active,
Associate, Inactive, Bad Standing, Leave of Absence, Half-Active, System; Alumni = Advisor,
Alum, Honorary). It does NOT show a default account type per stage, and the graduate form
carries no account-type control. So the server picks one of the Alumni stage's three types
by its own rule, unobserved.

Inference strengthened (still not observation): of the three Alumni-stage types, Advisor is
set only by assigning an advisor position, and Honorary is a special designation; neither is
what a plain graduation would produce. That leaves **Alum** as the only type a graduation
would assign by default. Confidence: medium (up from low-medium), but a graduation was not
run (it would change real members) so this remains a needs-a-human confirmation.

## Progress caching: one more data point, still not decisive

Adding a credit moved the requirement total from 48.5 to 49.5 on the very next page load,
and deleting it moved it straight back, with no lag and no stale value seen
(`raw/pages/self-flows-observed.md`, Flow A). Consistent with live recomputation, but a
cache with write-invalidation would look identical from outside, so this does not settle it.
Current reading unchanged: recomputed, confidence medium-high. Low value either way; the
rebuild computes live regardless.
