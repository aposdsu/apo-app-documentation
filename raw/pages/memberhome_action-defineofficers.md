# Capture: memberhome.php?action=defineofficers  (Assign Members to Positions)

- URL: https://www.apoonline.org/alphadelta/memberhome.php?action=defineofficers
- Captured: 2026-08-28 via DOM read. NOTHING WAS SUBMITTED. Member names not recorded.

## Page text, verbatim

Sub-tabs: "Define Officer Positions", "Assign Members to Positions"

"Define your chapter officers & advisors"
"After you've set up your chapter officer & advisor positions we'll use this page to
define who holds each position. If they already have accounts, we'll assign them their
new position. If they don't have an account, we'll send them an activation email. Any
member removed from their officer position will be returned to the 'Active' account type,
removed advisors will be returned to the 'Alumni' account type."

Table headers, verbatim: "Officer Positions | Member's First & Last Name | Email for Invitation"

Rows are the officer positions from `?action=editofficerpositions`, one per row, each with
a name box and, where the box is filled, the words "Account found" beneath it. The
position "Interchapter Chair" appeared on two consecutive rows.

## The form (post, never submitted)

submit button label: "Update Officers and Send Activation Emails"

| name pattern | type | count | notes |
|---|---|---|---|
| __csrf_magic | hidden | 1 | <redacted> |
| officers[N][positionId] | hidden | 26 | the officerid from ?action=editofficerpositions |
| officers[N][user] | text | 26 | the typed member name |
| officers[N][userId] | hidden | 26 | resolved member id, empty when no member is chosen |
| officers[N][email] | email | 4 | only rendered on rows with no member chosen |
| users[<userId>][newStatus] | select-one | 22 | account type to give that member |
| users[][newStatus] | select-one | 4 | the same select on unfilled rows |
| sendInvitations | (checkbox or hidden) | 1 | |
| (unnamed) | submit | 1 | "Update Officers and Send Activation Emails" |

26 position rows were rendered, against 18 officer positions and 1 advisor position on
`?action=editofficerpositions`.

### `newStatus` options, verbatim (value=label)

0=Prospect, 3=Potential New Member, 2=Active, 4=Associate, 111=Bad Standing,
127=Half-Active, 8=Inactive, 112=Leave of Absence, 339=System, 6=Alum, 7=Honorary,
321=Deceased

These are the account-type ids from `?action=managestatuses`, with two omissions:
statusid 1 ("Officer") and statusid 5 ("Advisor") are not offered. Taken with the page's
own sentence about members being "returned to the 'Active' account type" when removed,
this shows the site sets the Officer and Advisor account types itself as a consequence of
holding a position.
