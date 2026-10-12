# Capture: the member profile panels

- Captured: 2026-08-29. `?action=profile&panel=<name>`.
- Panel names read from the page's own anchors:
  `achievements, awards, events, family, info, profile, records, status, timeline`.
- Nothing was submitted. Personal values not recorded.

## panel=timeline — a typed member history

This panel had never been opened, and it changes an open question.

The page lists dated activity entries with a filter select named `activityType`, whose
options are, verbatim (value=label):

| value | label |
|---|---|
| officer | Elected Officer Position |
| affiliation | Joined Chapter/Group |
| membership | Membership Status Change |
| award | Received Award |
| achievement | Unlocked Achievement |

Observed entry shapes, with names kept because they are the logged-in operator's own:

- "Elected as the 'Chapter Advisor' of Alpha Delta." — Apr 11, 2024
- "Transitioned to an 'Advisor: Chapter Advisor' at Alpha Delta." — Apr 11, 2024
- "Created APOonline account." — Jan 3, 2015

**Why this matters.** `docs/GAPS.md` records an open question about whether the product
keeps any history of a member's account type, because the roster shows only the current
one. It does: a **Membership Status Change** is a dated timeline entry. So the current
account type is a single field, and the changes to it are recorded separately as history.
That is a different design from storing membership per term, and it is worth stating
precisely rather than leaving as "no history".

The timeline is member-facing and typed, which makes it a different thing from the access
log (`?action=viewlog`), which is officer-facing and free-text.

## panel=records — the member's own progress

Contains:
- an "Internal Service Hour Leaderboard" with the three scopes "Alpha Delta | Region B |
  Nation", and the empty state "No service hours recorded during this time frame."
- "Individual Requirements": one progress card per requirement, each with a "view/update"
  link, a percentage, and a "&lt;earned&gt; of &lt;goal&gt;" line.

**An important detail about zero.** On this account (account type Advisor, whose goals are
all blank rather than 0) every card reads "100% Complete / 0 of 0". The requirement edit
form's help text says a goal of **"0"** hides the bar
(`raw/pages/memberhome_action-editrequirement_reqid-3.md`). So a **blank** goal and a goal
of **0** behave differently: blank renders a 0-of-0 card at 100%, while 0 hides it.

`[for the analysis pass]` That is the difference between NULL and 0 in the goal column, and
it is a real modelling decision. Our schema declares `target numeric NOT NULL DEFAULT 0`,
which collapses the two states into one. Either add a nullable target or decide
deliberately that blank and zero mean the same thing.

## panel=achievements
"&lt;name&gt; has not yet received any achievements." with a link "View all available
achievements".

## Remaining panels
`info`, `profile`, `status`, `awards`, `events` and `family` mirror the Account Manager
panels of the same names, shown to the member themselves rather than to an officer
(`raw/pages/managebrother-all-panels.md`).
