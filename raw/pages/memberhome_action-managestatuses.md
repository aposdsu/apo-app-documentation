# Capture: memberhome.php?action=managestatuses  (Account Types & Privileges)

- URL: https://www.apoonline.org/alphadelta/memberhome.php?action=managestatuses
- Captured: 2026-08-28 via get_page_text + read_page (no submission)

## Table columns (verbatim)

"Account Type | Membership Status | Local Members | At Cost? | Actions"

## Rows, verbatim

| Account Type | Membership Status | Local Members | At Cost? |
|---|---|---|---|
| Prospect | Prospect | 0 | Free |
| Officer | Active | 16 | Yes |
| Active | Active | 8 | Yes |
| Potential New Member | PNM | 0 | Yes |
| Associate | Active | 19 | Free |
| Advisor | Alumni | 5 | Free |
| Alum | Alumni | 517 | Free |
| Honorary | Alumni | 0 | Free |
| Inactive | Inactive | 1 | Free |
| Deceased | Deceased | 0 | Pending Review |

Then a section heading, verbatim: "Custom Local Account Types (Alpha Delta Only)"

| Account Type | Membership Status | Local Members | At Cost? |
|---|---|---|---|
| Bad Standing | Active | 11 | Free |
| Leave of Absence | Active | 12 | Free |
| Half-Active | Active | 0 | Yes |
| System | Inactive | 1 | Free |

## Per-row action links (verbatim hrefs), in row order

| Row | edit link | privileges link | delete link |
|---|---|---|---|
| Prospect | memberhome.php?action=editstatus&statusid=0 | ?action=editprivileges&statusid=0 | none |
| Officer | none | ?action=editprivileges&statusid=1 | none |
| Active | memberhome.php?action=editstatus&statusid=2 | ?action=editprivileges&statusid=2 | none |
| Potential New Member | ...&statusid=3 | ?action=editprivileges&statusid=3 | none |
| Associate | ...&statusid=4 | ?action=editprivileges&statusid=4 | none |
| Advisor | ...&statusid=5 | ?action=editprivileges&statusid=5 | none |
| Alum | ...&statusid=6 | ?action=editprivileges&statusid=6 | none |
| Honorary | ...&statusid=7 | ?action=editprivileges&statusid=7 | none |
| Inactive | ...&statusid=8 | ?action=editprivileges&statusid=8 | none |
| Deceased | ...&statusid=321 | ?action=editprivileges&statusid=321 | none |
| Bad Standing | ...&statusid=111 | ?action=editprivileges&statusid=111 | memberhome.php?action=deletestatus&statusid=111 |
| Leave of Absence | ...&statusid=112 | ?action=editprivileges&statusid=112 | ...deletestatus&statusid=112 |
| Half-Active | ...&statusid=127 | ?action=editprivileges&statusid=127 | ...deletestatus&statusid=127 |
| System | ...&statusid=339 | ?action=editprivileges&statusid=339 | ...deletestatus&statusid=339 |

All `deletestatus` links were recorded and NOT opened (destructive).

Bottom of page: link "Create Account Type" -> memberhome.php?action=editstatus
(the same action with no statusid).

Only the header search form is present on this page; the rows are links, not a form.
