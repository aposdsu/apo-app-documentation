# Capture: memberhome.php?action=eventedit&eventid=1152799  (edit an existing event)

- URL: https://www.apoonline.org/alphadelta/memberhome.php?action=eventedit&eventid=1152799
- Captured: 2026-08-28 via DOM form read. THE FORM WAS NOT SUBMITTED.

The form is the same shape as `?action=eventcreate`
(raw/pages/memberhome_action-eventcreate.md), method post, 61 elements, with these
differences:

- an extra hidden field `eventid`, holding the id of the event being edited
- an extra field `eventinfo[recurringScope]`, which the create form does not have
- `eventinfo[numreqs]` is 1 and one credit row is filled in:
  `eventinfo[req_1_units]`, `eventinfo[req_1_id]`, `eventinfo[req_1_isPerShift]`
- `eventinfo[numshifts]` is 1 with the shift_1 fields present

The submit button's value could not be read from the DOM (the button is not a plain
`input[type=submit]` on this page).
