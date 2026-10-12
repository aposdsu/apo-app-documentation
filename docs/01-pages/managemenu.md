# Officer dashboard

> Summary: The page officers work from. It is a status board: one panel per requirement
> showing what needs doing, plus panels for members, money and the website.
> Status: OBSERVED
> Read this if: you want to know what an officer needs to see when they log in.
> Depends on: raw/pages/memberhome_action-managemenu.md

**Route:** `memberhome.php?action=managemenu`

## What it does

It answers "what needs my attention". Every panel is a count or a piece of unfinished
work, and every count is a link to the screen that resolves it.

The most useful part is the middle: one block per requirement, each showing either the
next upcoming event of that type, or an event that "needs to be completed!", or an empty
state with a link to create one. That single layout tells an officer at a glance which
parts of the chapter are running and which are not.

## What it shows

- Quick-create row: Event, Email, SMS, Announcement, Files, Forms, Courses, Minutes,
  System Settings.
- One block per requirement, with links to that requirement's events
  (`manageevents&reqid=`) and everyone's progress on it (`managerecords&reqid=`).
- Member counts by national status: 0 prospects, 0 potential new members, 66 members,
  523 alumni.
- "There are 7 users pending approval before they can log in!"
- "You may assign members to these vacant positions: ..." naming four empty offices.
- Finance links: budget, invoices, log payment, charge fee, ledger, dues, online payments,
  fundraising.
- "December 19th marks the end of current term and the beginning of next."

## What to take from it for your own build

Build this page early, not last. A dashboard that lists unfinished work is what makes
officers open the system at all. The three things worth copying exactly are the
"needs to be completed" prompt, the vacant-positions prompt, and the pending-approvals
count.
