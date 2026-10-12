# Capture: memberhome.php?action=createchapterachievement  (Create Achievement)

- URL: https://www.apoonline.org/alphadelta/memberhome.php?action=createchapterachievement
- Reached from ?action=managechapterachievements, which reads
  "Your chapter has no achievements. Create Achievement"
- Captured: 2026-08-28. THE FORM WAS NOT SUBMITTED.

## On-screen text, verbatim

"Title (ex. 25 Service Hours)"
"Description (ex. For completing 25 hours of community service in one semester.)"
"Condition"
"This achievement is awarded automatically when..."
"...a member reaches ___ units of internal <requirement> in [a single term | their lifetime]."
"This achievement is manually awarded by an officer."
"This achievement may be awarded [each term | once in a lifetime (recommended)]."
"You may award this achievement to members on the next page or at any time by returning
 to the Manage Achievements page."
"or cancel"

## Form (post)

| name | type | max | options |
|---|---|---|---|
| __csrf_magic | hidden | | |
| title | text | 100 | |
| description | text | 255 | |
| condition | radio | | two radios: automatic and manual |
| units | text | 10 | |
| reqid | select-one | | see below |
| isLifetime | select-one | | 0=a single term, 1=their lifetime |
| isLifetime_manual | select-one | | 0=each term, 1=once in a lifetime (recommended) |
| (unnamed) | submit | | |

`reqid` options, verbatim (value=label):
2=Meetings, 3=Service Hours, 865=Fellowship Events, 866=Leadership Credits,
867=Fundraising Credits, 912=Interchapter Credits, 925=Chair Credits,
937=Special Fellowships, 944=Committee Credits, 1507=Academic Credits,
1511=External Relations Credit, 1605=Open Forum Credits, 2130=Required Events,
2164=Philanthropy Hourses, 2234=Dues, 2236=Philanthropy Credits, 2377=Training Credits

reqid 1 ("Dues & Fees") is absent from this list, the same omission seen in the
account-type self-logging privileges.
