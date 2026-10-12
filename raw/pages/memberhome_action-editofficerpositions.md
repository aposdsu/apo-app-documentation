# Capture: memberhome.php?action=editofficerpositions  (Define Officer Positions)

- URL: https://www.apoonline.org/alphadelta/memberhome.php?action=editofficerpositions
- Captured: 2026-08-28 via read_page + get_page_text + DOM form read (no submission)

## Sub-tabs on this screen
- link "Define Officer Positions" -> ?action=editofficerpositions
- link "Assign Members to Positions" -> ?action=defineofficers

## Table 1 header: "Officer Positions | Actions"

Rows, verbatim labels:
President(Primary), Academic Chair, Conference Chair, Equity & Inclusion Chair,
Fellowship Vice President, Fundraising Chair, Historian, Interchapter Chair,
Leadership Vice President, Membership Vice President, Philanthropy Chair, Pledge Trainer,
Public Relations Chair, Recording Secretary, Sergeant-At-Arms, Service Vice President,
Special Events Coordinator, Treasurer

Inline warning shown on the "Conference Chair" row:
  "Missing Privileges / This position doesn't have any privileges assigned! / Assign Privileges"

## Table 2 header: "Advisor Positions | Actions"
Rows: Chapter Advisor(Primary)

## Per-row action links (verbatim hrefs)

Each row exposes up to three links:
- memberhome.php?action=editofficerposition&officerid=<id>
- ?action=editofficerprivileges&officerid=<id>
- ?action=deleteofficerposition&officerid=<id>        [NOT OPENED: destructive]

officerid values observed in the accessibility tree, in row order:
2892 (President, has no delete link), 2997, 7239 (Conference Chair, the row with the
"Assign Privileges" call to action), 5928, 2993, 2999, 5927, 3050, 3874, 2930, 4338,
2906, 3949, 2996.
(The accessibility-tree read was truncated by output limits before the last rows, so
this id list is partial.)

Note: the President row has an edit link and a privileges link but NO delete link. The
row is labelled "(Primary)".

## Form on this page (read only, never submitted)

Form 2:
- action: ?action=addofficerposition
- method: post
- fields:
  | name | type | required | maxlength | value |
  |---|---|---|---|---|
  | __csrf_magic | hidden | no | - | <redacted> |
  | title | text | yes | 75 | (empty) |
  | officerOrAdvisor | radio | no | - | officer |
  | officerOrAdvisor | radio | no | - | advisor |
  | officerOrAdvisor | radio | no | - | both |
  | (unnamed) | submit | - | - | "Add Position" |

Form 1 (the site-wide header search box, present on every page):
- action: (none, submits to current page) method: get
- fields: userid (hidden, empty), action (hidden, value "profile"), searchTerms (text)
