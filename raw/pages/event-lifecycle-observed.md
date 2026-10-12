# Capture: the full event lifecycle, OBSERVED by performing it once

- Captured: 2026-08-29.
- IMPORTANT — this is the ONE capture in this repository that records WRITES that were
  actually performed, not predicted. The chapter owner (a Chapter Advisor, and the author
  of CLAUDE.md) gave an explicit, scoped, one-time exception to Rule 1 to observe the
  create -> complete -> delete flow, with themselves as the sole attendee. Every write was
  confirmed with them first; the "no undo" consequence was stated before they approved.
  Rule 1 remains in force for everything else.
- The test artifact was an officers-only, no-invitations Fellowship event titled
  "TEST EVENT - Claude, safe to delete", eventid 1161693, sole attendee = the operator
  (the logged-in advisor). No other member was affected at any point.
- Member data: the only member touched was the operator themselves. Their name/id are
  redacted below as <operator [id]>.

## The endpoints in the flow (each observed)

| Step | URL | Method observed | What it did |
|---|---|---|---|
| 1. Create | `?action=eventcreate` submit | POST -> redirect to `?action=eventadd` | created the event; result page "Your event has been posted to the calendar!" |
| 2. Add attendee | (side effect of create) | - | the "Add event coordinator(s) as attendee(s)" checkbox put the operator on the sign-up sheet automatically; the event row then showed "1" attendee |
| 3. Open completion | `?action=eventcomplete&eventid=` | GET | rendered a CONFIRMATION SCREEN, not an instant action (see below) |
| 4. Confirm completion | submit of that screen | POST -> `?action=eventcompletedo` | awarded the credit; result "Successfully Recorded Fellowship Events / ... credited with 1 fellowship event: <operator>" |
| 5. Delete event | `?action=eventdelete&eventid=` | GET, NO confirmation dialog | "Event Successfully Deleted ... removed from your event calendar" |
| 6. Delete the orphaned credit | `?action=deleterecord&recordid=` | GET | "The logged Fellowship Event record was successfully deleted" |

## Step 3 detail: the "Complete Event" confirmation screen (previously unseen)

`?action=eventcomplete&eventid=` is NOT the write. It renders a screen headed
"Complete Event" with:
- the event title, date, and the credit it carries ("1 Fellowship Event")
- two tabs: "Custom Values" and "Check List" (Check List active by default)
- a table "Attendees | Fellowship Event to Award", one row per attendee, each with an
  editable award-amount box pre-filled with the event's credit (here "1")
- a "+ add another member" button
- a "Complete Event" submit button and "or cancel"

So an officer can adjust the per-attendee award, or add a member who was not on the
sign-up sheet, before confirming. The actual award happens only when this screen is
submitted, to `?action=eventcompletedo`.

## The key finding: deleting an event does NOT cascade to the credit or the notification

This was tested directly by measuring the operator's Fellowship record and notifications
before and after each step.

| After step | Operator's all-time Fellowship total | Notification present? |
|---|---|---|
| baseline (before) | 10 | no |
| after completion (step 4) | **11** (new row "TEST EVENT... Aug 29, 2026, 1") | **yes** — "For attending TEST EVENT... you've been credited with: 1 Fellowship Event. 2026-08-29 09:08:01" |
| after deleting the EVENT (step 5) | **still 11** (credit row unchanged) | **still yes** |
| after deleting the CREDIT record (step 6) | back to 10 | **still yes** |

So on this product:
- **Completing an event writes a credit row plus a notification.** The notification bell
  counter went 0 -> 1 at completion.
- **Deleting the event leaves the credit orphaned.** The awarded credit is a standalone
  record; removing the event does not remove it. This is direct evidence for the
  attendance/credit separation, and also that the vendor does NOT cascade-delete credits
  when their originating event is deleted.
- **The notification is fully independent and appears permanent.** It survived deleting the
  event AND deleting the credit, and no delete control for a notification was found on the
  notifications page. It carries the original wording and timestamp even though both the
  event and the credit it references no longer exist.

## The audit log recorded all six writes, permanently

`?action=viewlog`, newest first, operator redacted, verbatim templates:

- `<operator [id]> Deleted Fellowship Event entry from <operator [id]>, TEST EVENT - Claude, safe to delete [8863865] dated August 29, 2026 for 1.00 Fellowship Event(s). 08-29-2026 9:12am`
- `<operator [id]> Deleted Event: 'TEST EVENT - Claude, safe to delete' [1161693] 08-29-2026 9:09am`
- `<operator [id]> Added Fellowship Event entry [8863865] for <operator [id]>, 'TEST EVENT - Claude, safe to delete' [1161693] dated August 28, 2026 for 1 Fellowship Events. 08-29-2026 9:08am`
- `<operator [id]> Completed Event: 'TEST EVENT - Claude, safe to delete' [1161693] 08-29-2026 9:08am`
- `<operator [id]> Added '<operator>' [id] to the 'TEST EVENT - Claude, safe to delete' [1161693] event sign-up sheet. 08-29-2026 9:06am`
- `<operator [id]> Added Event: 'TEST EVENT - Claude, safe to delete' [1161693] for August 29, 2026 at 1:00 am. 08-29-2026 9:06am`

Two details from the log:
- The credit-award entry (`recordid 8863865`) reads **"dated August 28, 2026"**, while the
  member's record page displayed the same credit as **"Aug 29, 2026"**. The event itself
  was Aug 29 at 1:00am. This is a one-day discrepancy between the log's stored date and the
  displayed date, most likely a timezone/off-by-one in how the credit date is derived from
  the event time. Recorded as observed; not resolved.
- Every action is attributed to the acting user with their id, including the deletions.

## Final state of the chapter after cleanup

- The event: deleted, gone from the calendar and the Fellowship-events management list.
- The credit: deleted, operator's Fellowship total back to 10 (its pre-test value).
- **Permanent residue that could NOT be removed:** one notification to the operator, and
  six access-log entries (create, add-attendee, complete, credit-award, event-delete,
  credit-delete). This is the concrete confirmation of Rule 1's "there is no undo": the
  visible artifacts were removed, but the notification and the audit trail persist.
