# Capture: memberhome.php?action=createrequirement  (Create a requirement / event type)

- URL: https://www.apoonline.org/alphadelta/memberhome.php?action=createrequirement
- Captured: 2026-08-28. THE FORM WAS NOT SUBMITTED. It was opened because it carries no
  record id and no value-bearing parameter, so a plain GET renders an empty form.

The on-screen text is identical to `?action=editrequirement&reqid=865`
(raw/pages/memberhome_action-editrequirement_reqid-865.md).

## Form (post)

| name | type | max |
|---|---|---|
| __csrf_magic | hidden | |
| text_what | text | 50 |
| text_unit | text | 25 |
| isSplit | radio (2) | |
| newCategories[1] | text | |
| isPercentage | radio (2) | |
| isExternal | radio (2) | |
| goal[<statusid>][internal] | text | one per account type |
| goal[<statusid>][external] | text | one per account type |
| (unnamed) | submit | |

The `goal[...]` inputs appear in this exact statusid order:
0, 3, 2, 4, 111, 127, 8, 112, 1, 339, 5, 6, 7, 321

and the on-screen labels appear in this exact order:
Prospect, Potential New Member, Active, Associate, Bad Standing, Half-Active, Inactive,
Leave of Absence, Officer, System, Advisor, Alum, Honorary, Deceased

which gives a complete statusid to account type mapping that agrees with
raw/pages/memberhome_action-managestatuses.md:

| statusid | account type |
|---|---|
| 0 | Prospect |
| 3 | Potential New Member |
| 2 | Active |
| 4 | Associate |
| 111 | Bad Standing |
| 127 | Half-Active |
| 8 | Inactive |
| 112 | Leave of Absence |
| 1 | Officer |
| 339 | System |
| 5 | Advisor |
| 6 | Alum |
| 7 | Honorary |
| 321 | Deceased |

Note the maxlength values: the requirement's own label is at most 50 characters and its
unit label at most 25.
