# Capture: buttons and dropdown values not previously enumerated

- Captured: 2026-08-29. Earlier captures recorded form *fields* and often only the count of
  a `<select>`'s options. This pass records the option **values**, and the JavaScript
  buttons that carry no href and so never appeared in any link harvest.
- Nothing was submitted or clicked.

## `?action=createreport` — the report builder's real field names

The checkbox **values** are the server's own names for member fields, which is stronger
evidence than the profile form's input names.

`user_fields[]` values, in page order:

`id, fullname, firstname, nickname, middlename, lastname, suffix, maidenName, memberNumber,
chapternumber, email, email_public, phone, birthday, pledgeclass, graduationclass,
homeaddress, campusaddress, dateRegistered, dateLastLogin, status`

Two of these appear nowhere on the profile form and are therefore fields the system keeps
but does not let anyone edit: **`dateRegistered`** and **`dateLastLogin`**. The profile page
displays the latter as "Recently logged in on <date>".

Note also that `pledgeclass` and `graduationclass` are single values here, while the profile
form splits each into a term select plus a year text field. So the stored shape and the
edited shape differ.

`fields[]` values (the requirement columns): `2, dues, 3, 1507, 925, 944, 2234, 1511, 865,
867, 912, 866, 1605, 2236, 2164, 2130, 937, 2377`

Eighteen values, seventeen of which are requirement ids. The odd one out is the literal
string **`dues`**, which is the "Chapter Balance (Dues)" column. So the money balance is a
report column that is **not** a requirement id, even though requirement id 1 is called
"Dues & Fees". That is more evidence that dues are modelled twice.

`statusids[]` values: `0, 1, 2, 3, 4, 5, 6, 7, 8, 321, 111, 112, 127, 339, new`

Fourteen account type ids plus the literal **`new`**, which is the "Awaiting Approval"
filter. So pending registrations are selectable in reports without being an account type.

`user_custom_fields[]` values: `473` — the chapter's one custom field, confirming that
`profile[473]` on the profile form is a chapter-defined field.

Other checkbox groups: `showServiceSplit`, `showLacking`, `showOnlyLacking`,
`showLackingSummary`.
Buttons: "Progress Report | Membership Report | Complete Report" (the three tabs),
"Reset Calendar Dates", "Generate Report".

## `?action=createeventreport` — the attendance report

Checkbox groups: `show_empty` ("Show events with no attendees") and `show_positive`
("Only show attendees with positive hours of attendance").
Buttons: "Reset Calendar Dates", "Generate Report".

## `?action=eventcreate` — the JavaScript buttons

These carry no href and appear in no link harvest. They are what make the event form's
repeating sections work:

- "break event into shifts", "+ add another shift", "- remove last shift"
- "+ add another credit", "- remove last credit"
- "add bonus" (twice: ride bonus and coordinator bonus)
- "Add Calendar Event" (the submit)
- "Close", "Done", "Reset", "Cancel" (dialog controls, from the date picker)

So shifts and credits are both client-side repeaters that grow the `numshifts` and `numreqs`
hidden counters. That is how `eventinfo[req_2_units]`, `req_3_units` and so on would come
into existence.

### Recurrence dropdown values, previously recorded only as counts

- `eventinfo[recur_repeat]`: `daily=Daily`, `weekly=Weekly`, `monthly=Monthly`,
  `yearly=Yearly`
- `eventinfo[recur_repeatevery]`: 1 through 30

Combined with `recur_until`, the recurrence rule is "every N days/weeks/months/years until a
date". The access log shows this is expanded into separate event records at creation
(`raw/pages/memberhome_action-viewlog.md`), so the rule itself does not appear to be stored.
