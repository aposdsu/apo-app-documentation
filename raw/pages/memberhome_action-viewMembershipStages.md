# Capture: memberhome.php?action=viewMembershipStages  (Transition Members)

- URL: https://www.apoonline.org/alphadelta/memberhome.php?action=viewMembershipStages
- Captured: 2026-08-28 via DOM read. NOTHING WAS SUBMITTED. Member names not recorded.

## Page text, verbatim

"Transition Members"
"Below you will see all of your member's official national membership statuses. Use the
 tools below to transition their membership status between membership stages."

Four stage columns, with the account types each stage contains:

| Stage | Account types it includes (verbatim) |
|---|---|
| Prospect | "Includes the Prospect account type." |
| Potential New Member | "Includes the Potential New Member account type." |
| Member | "Includes the Officer, Active, Associate, Inactive, Bad Standing, Leave of Absence, Half-Active, System account types." |
| Alumni | "Includes the Advisor, Alum, Honorary account types." |

Also on the page: "Add prospect", "With selected members...", "Select All".

## The one transition form present (post, never submitted)

| name | type | value |
|---|---|---|
| __csrf_magic | hidden | <redacted> |
| stageId | hidden | 20 |
| targetStageId | hidden | 10 |
| userIds[] | checkbox | 66 checkboxes, one per member currently in the Member stage |
| (unnamed) | submit | "Graduate Members »" |

So stage id 20 is "Member" and stage id 10 is "Alumni". The 66 checkboxes match the
"66 Members" count on the officer dashboard
(raw/pages/memberhome_action-managemenu.md).

## Note on two different groupings

`?action=editstatus` maps each account type to one of six national membership statuses
(Active, Alumni, Deceased, Inactive, PNM, Prospect). This page groups the same account
types into four stages, and puts the account types whose national status is "Inactive"
(namely Inactive and System) inside the "Member" stage. The two groupings are therefore
not the same list.
