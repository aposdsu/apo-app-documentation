# Capture: memberhome.php?action=editrequirement&reqid=865  (edit requirement "Fellowship Event")

- URL: https://www.apoonline.org/alphadelta/memberhome.php?action=editrequirement&reqid=865
- Captured: 2026-08-28 via get_page_text + DOM form read (no submission)

## On-screen labels and help text, verbatim

- "Event Type Label:" "(singular form)"
- "Event Type + Units Label:" "(singular form)"
- "Does your by-law specify categories for this requirement? (e.g., \"Service\" could be
   split into \"Service to the Nation\", \"Service to the Community\", etc.)"  with
   choices "No" and "Yes"
- "Hours or Percentage of Events?"
  - "Hours/Points — Each member must attend X number of hours/points of this type of event."
  - "Percentage — Each member must attend X% of the total number of events of this type of event."
- "Do you allow members to earn credit for attending these types of events outside of the
   chapter? (e.g., doing service through other organizations)"
  - "No, only count hours from events on our calendar"
  - "Yes, count logged hours from external events"
- "Individual Requirements" with the same help text as reqid 3, and the same 14 account
  type rows in the same order.
- Column heading: "Total Required"
- "or cancel"

## Form (read only, never submitted)

- action: ?action=updaterequirement
- method: post

| name pattern | type | count | value on load |
|---|---|---|---|
| __csrf_magic | hidden | 1 | <redacted> |
| id | hidden | 1 | 865 |
| text_what | text | 1 | "Fellowship Event" |
| text_unit | text | 1 | "Fellowship Event" |
| isSplit | radio | 2 | "0" (selected) and "1" |
| newCategories[<n>] | text | 1 | empty |
| isPercentage | radio | 2 | "0" (selected) and "1" |
| isExternal | radio | 2 | "0" (selected) and "1" |
| goal[<statusid>][internal] | text | 14 | e.g. 2 and 4 for two of the account types |
| goal[<statusid>][external] | text | 14 | all empty |
| (unnamed) | submit | 1 | "Update Requirement" |

Because isSplit is "0" for this requirement, no `existingSubGoal[...]` inputs are
rendered. On reqid 3, which is split into four categories, 56 of them are rendered.
