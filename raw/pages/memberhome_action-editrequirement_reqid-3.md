# Capture: memberhome.php?action=editrequirement&reqid=3  (edit requirement "Service Project")

- URL: https://www.apoonline.org/alphadelta/memberhome.php?action=editrequirement&reqid=3
- Captured: 2026-08-28 via get_page_text + DOM form read (no submission)

## On-screen labels and help text, verbatim

- "Event Type Label:"  shown as static text "Service Project"
- "Event Type + Units Label:"  shown as static text "Service Hour"
- "Hours or Percentage of Events?"
  - "Hours — Each member must attend X number of hours of this type of event."
- "Do you allow members to earn credit for attending these types of events outside of the
   chapter? (e.g., doing service through other organizations)"
  - "No, only count hours from events on our calendar"
  - "Yes, count logged hours from external events"
- "Key /  = Total Requirement  /  = Maximum allowed from external events of total"
- "Individual Requirements"
  - "Record any membership requirements defined by your by-law for this event type. This
     will determine the goal value for each progress bar that appears on your members'
     Home page."
  - "To hide a progress bar from members of a given account type, simply set their
     membership requirement to \"0\"."
- One labelled row per account type, in this order:
  Prospect, Potential New Member, Active, Associate, Bad Standing, Half-Active, Inactive,
  Leave of Absence, Officer, System, Advisor, Alum, Honorary, Deceased
- Column heading over the number inputs: "Total Required"
- Four category columns, verbatim: "Service to the Campus", "Service to the Community",
  "Service to the Nation", "Service to the Fraternity"
- "or cancel"

## Form (read only, never submitted)

- action: ?action=updaterequirement
- method: post

| name pattern | type | count | values seen on load |
|---|---|---|---|
| __csrf_magic | hidden | 1 | <redacted> |
| id | hidden | 1 | 3 |
| isExternal | radio | 2 | values "0" and "1"; "1" was selected |
| goal[<statusid>][internal] | text | 14 | one per account type |
| goal[<statusid>][external] | text | 14 | one per account type |
| existingSubGoal[<categoryid>][<statusid>][internal] | text | 56 | all empty on load |
| existingSubGoal[<categoryid>][<statusid>][external] | text | 56 | all empty on load |
| (unnamed) | submit | 1 | "Update Requirement" |

categoryid values present: 1, 2, 3, 4 (4 categories x 14 account types = 56 inputs).

### goal values read from the DOM, by account-type statusid

| statusid | account type (from managestatuses capture) | goal internal | goal external |
|---|---|---|---|
| 0 | Prospect | (empty) | (empty) |
| 3 | Potential New Member | 15 | 5 |
| 2 | Active | 15 | 5 |
| 4 | Associate | (empty) | 5 |
| 111 | Bad Standing | 15 | (empty) |
| 127 | Half-Active | 7.5 | 5 |
| 8 | Inactive | (empty) | (empty) |
| 112 | Leave of Absence | (empty) | (empty) |
| 1 | Officer | 15 | 5 |
| 339 | System | (not read) | (not read) |
| 5 | Advisor | (not read) | (not read) |
| 6 | Alum | (not read) | (not read) |
| 7 | Honorary | (not read) | (not read) |
| 321 | Deceased | (empty) | (empty) |

The DOM order of the goal inputs was 0, 3, 2, 4, 111, 127, 8, 112, 1, 339, 5, 6, 7, 321,
which matches the on-screen label order listed above. The reading was truncated by output
limits for statusid 339, 5, 6 and 7.

Note the value "7.5", which shows the goal accepts a fractional number, not just an
integer.

This requirement has no editable label fields. Compare
raw/pages/memberhome_action-editrequirement_reqid-865.md, a chapter-created requirement,
where the labels are editable text inputs.
