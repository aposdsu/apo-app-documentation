# Capture: resolving the open gaps

- Captured: 2026-08-29. Each section is an open question from `docs/GAPS.md` and what
  looking at the site actually showed. Nothing was submitted.

## 1. Does `?action=editstatus` with no statusid create, or is there a separate verb?

**Resolved: one endpoint does both.**

Opening `?action=editstatus` with no `statusid`:
- heading reads "Create Account Type" (the edit version reads differently and shows values)
- there is **no `statusid` hidden field** in the form
- the submit button reads "Create Account Type" (the edit version reads "Update Account Type")
- the form still posts to **`?action=updatestatus`**, the same target as the edit form

So the presence or absence of `statusid` in the POST is what decides create versus update.

## 2. Does the product keep attendance separately from sign-ups?

**Resolved: no. Confidence high, upgraded from medium.**

Previously this rested on absence of evidence, because only a future event had been opened.
A past, already-completed event was opened for comparison
(`?action=eventsignup&eventid=1126357`, a meeting from April 2026).

What changes on a completed event:
- the Admin Actions list becomes "Update attendees | E-mail attendees | Text attendees |
  Delete event". **"Complete event" is replaced by "Update attendees"**, and "Edit event"
  and "Manage attachments" are gone.
- the page reads "Sign-ups are currently locked" and "Sign-ups are currently closed".

What does **not** change:
- the attendee table headers are still exactly "Member | Phone | Comment"
- there is no present/absent column, no attendance status, and no second list

So the sign-up sheet and the attendance list are one list, before and after completion.
Correcting who attended means editing that same list, through
`?action=editcompletedevent&eventid=<id>`.

**`?action=editcompletedevent` was NOT opened.** It is the screen for changing attendance on
an event whose credit has already been awarded, so opening it risks touching a record that
has downstream credit rows. Recorded as a URL only.

This confirms the recommendation in
`docs/02-data-model/01-how-the-vendor-differs.md` to keep `signup` and `attendance` as two
tables: the vendor's single list genuinely cannot express "signed up and did not come".

## 3. Which account type does a member end up with after "Graduate Members"?

**Sharpened, not fully resolved.**

The form posts only `stageId=20` and `targetStageId=10` with a list of user ids. There is
**no account-type select anywhere on the page**, and no hidden account-type field. So the
server maps a target stage to an account type by its own rule; the officer does not choose.

Since the Alumni stage "Includes the Advisor, Alum, Honorary account types", the server must
pick one of those three, and "Alum" is the only plausible default for a graduating student.
That last step is `[inferred]`, confidence low-medium. What is now certain is that the
choice is not exposed in the interface.

## 4. Why does the officer assignment page render 26 rows for 19 positions?

**Resolved: one row per assignment, not per position.**

`?action=defineofficers` renders 28 table rows in total. Counting duplicated position names:
Interchapter Chair appears twice, Pledge Trainer twice, Public Relations Chair twice, and
**Chapter Advisor five times**.

Three positions are co-held by two members each, which the roster already showed
(`raw/pages/memberhome_action-brothers.md`), and the advisor position has five slots. 19
positions + 3 extra co-held rows + 4 extra advisor rows = 26 assignment rows, plus 2 header
rows = 28.

So the page lists **assignments**, and a position with several holders gets several rows.
That matches the `officers[N][positionId]` field naming, where N is a row index rather than
a position id.

## Gaps that remain genuinely unresolvable from a read-only admin session

- **What happens to credits and targets when a member's account type changes mid-term.**
  Would require changing a real person's account type.
- **Whether progress totals are cached or recomputed.** Not visible in HTML.
- **Whether the server enforces the privilege model.** An admin is never refused; testing
  it needs a second, weaker account and an action it should be denied.
