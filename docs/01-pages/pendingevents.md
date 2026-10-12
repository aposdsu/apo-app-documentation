# Events ready to be completed

> Summary: The queue of events that have happened but not yet been turned into credit.
> This is where attendance becomes progress.
> Status: OBSERVED
> Read this if: you want to understand how credit is created.
> Depends on: raw/pages/memberhome_action-pendingevents.md

**Route:** `memberhome.php?action=pendingevents`

## What it does

It lists events whose date has passed and which nobody has completed yet. The page
explains itself, verbatim:

"Completing events awards each attendee credit for attending the event which is reflected
in their requirement progress bars on their homepage."

Table columns: Event, Date, Attendees, Actions.

## Why this page is the centre of the system

Signing up does nothing to anyone's progress. Attending does nothing by itself. Credit
exists because an officer pressed a button on this page. Everything else, the progress
bars, the reports, the leaderboards, the achievements, reads rows that this action wrote.

The member is told: the notifications page shows "For attending GBM #5: Business Casual
you've been credited with: 1 Meeting, 1 Required Event."

## What to copy

The queue itself, and the fact that completion is deliberate rather than automatic. It
gives officers a moment to fix the attendee list before anything is written.

Make the write idempotent: completing an event twice must not double anyone's credit. The
proposed schema does this with a unique index on the attendance row and the requirement.
