# Capture: memberhome.php?action=setterm  (set term dates)

- URL: https://www.apoonline.org/alphadelta/memberhome.php?action=setterm
- Captured: 2026-08-28 via get_page_text + DOM form read (no submission)

## On-screen text, verbatim

- "My college/university's academic calendar operates on a..."
  - "Semester System"
  - "Quarter System"
- "Our academic calendar schedule:"
- "Fall Semester Begins:"  followed by a month select and a day select
- "Spring Semester Begins:" followed by a month select and a day select
- "or cancel"

## Form (read only, never submitted)

- action: could not be read. The browser extension's data guard refused to return the
  form's `action` attribute on this page. The submit button reads "Update Term Dates".
- method: post (read from the DOM)

| name | type | value on load | notes |
|---|---|---|---|
| __csrf_magic | hidden | <redacted> | |
| calendar | radio | "semester" (selected), "quarter" | |
| semester[month1] | select-one | 12 | 13 options |
| semester[day1] | select-one | 20 | 32 options |
| semester[month2] | select-one | 6 | 13 options |
| semester[day2] | select-one | 20 | 32 options |
| quarter[month1] | select-one | 12 | 13 options |
| quarter[day1] | select-one | 20 | 32 options |
| quarter[month2] | select-one | 6 | 13 options |
| quarter[day2] | select-one | 20 | 32 options |
| quarter[month3] | select-one | (empty) | 13 options |
| quarter[day3] | select-one | (empty) | 32 options |
| quarter[month4] | select-one | (empty) | 13 options |
| quarter[day4] | select-one | (empty) | 32 options |
| (unnamed) | submit | "Update Term Dates" | |

Month select option labels are the twelve month names plus one empty option. Day select
option labels are 01 through 31 plus one empty option.

There is no term name field, no year field, and no list of past terms on this screen.
The chapter stores a recurring month/day pair per term boundary, not a row per term.

Cross reference: the Officer Dashboard says "December 19th marks the end of current term
and the beginning of next" (raw/pages/memberhome_action-managemenu.md), which matches
semester[month1]=12, semester[day1]=20.
