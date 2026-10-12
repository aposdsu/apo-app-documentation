# Capture: memberhome.php?action=managedues  (Dues & Fees)

- URL: https://www.apoonline.org/alphadelta/memberhome.php?action=managedues
- Also reachable as ?action=managedues&prefillType=payment and &prefillType=fee
- Captured: 2026-08-28 via DOM read. NOTHING WAS SUBMITTED. Member names not recorded.

## Page text, verbatim

"Log Payment or Charge Fee"
radio choices: "Log Payment", "Charge Fee"
"Payments will be deducted from a member's balance."
field labels: "Name", "Method", "Amount", "$", "Memo"
method choices: "Cash", "Credit Card", "Check", "Other..."
"All Payment Progress   view all"
"Showing transactions from ___ to ___."

## Table headers, verbatim

"Member | Total Paid | Due Date | Account Type | Balance | (actions)"

Each row shows a "$0.00 of $0.00" style Total Paid cell, a "Set Due Date" link in the Due
Date cell, the member's account type in upper case (for example OFFICER, ACTIVE), an
empty Balance cell, and a "view details" link.

## FORM1, log payment or charge fee (post, never submitted)

| name | type | notes |
|---|---|---|
| __csrf_magic | hidden | <redacted> |
| type | radio | two radios, one per mode (Log Payment / Charge Fee) |
| brother | text | typed member name |
| userid | hidden | resolved member id |
| method | select-one | Cash=Cash, Credit=Credit Card, Check=Check, Other=Other... |
| methodOther | text | free text when method is Other |
| methodOtherTransactionId | text | |
| amount | text | |
| memo | text | |
| (unnamed) | submit | |

## FORM2, date filter (get): action (hidden), startdate (text), enddate (text), submit
