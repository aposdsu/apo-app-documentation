# Capture: memberhome.php?action=editsitesettings  (site settings)

- URL: https://www.apoonline.org/alphadelta/memberhome.php?action=editsitesettings
- Captured: 2026-08-28 via get_page_text + DOM form read (no submission)

The whole page is one setting: the chapter's timezone.

## Form (read only, never submitted)

- action: memberhome.php?action=updatesitesettings
- method: post

| name | type | value on load | options |
|---|---|---|---|
| __csrf_magic | hidden | <redacted> | |
| timezone | select-one | America/Los_Angeles | Atlantic/Bermuda=Atlantic Time, America/New_York=Eastern Time, America/Chicago=Central Time, America/Denver=Mountain Time, America/Phoenix=Mountain-Phoenix Time (no DST), America/Los_Angeles=Pacific Time, America/Anchorage=Alaska Time, America/Adak=Hawaii Time, Pacific/Honolulu=Hawaii-Honolulu Time (no DST) |
| adjustTimes | radio | "true" selected, "false" | |
| (unnamed) | submit | "Set Timezone" | |

On-screen text for adjustTimes, verbatim:
"Adjust Events To Keep Same Displayed Times?"
- "Yes, if my events currently display that they start at 6:00 PM, they should still show
   6:00 PM after the change. (recommended)"
- "No, my event's currently displayed start times should change to reflect the new timezone."
