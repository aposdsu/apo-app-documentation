# Capture: memberhome.php?action=createreport  (Report builder)

- URL: https://www.apoonline.org/alphadelta/memberhome.php?action=createreport
- Also reachable as &subAction=membershipReport and &subAction=progressReport
- Captured: 2026-08-28. NOTHING WAS SUBMITTED.

Tabs, verbatim: "Progress Report | Membership Report | Complete Report"

## "Select which fields you would like to show in your report" (checkbox group `user_fields[]`)

APOonline User ID, Full Name, First Name, Preferred First Name, Middle Name, Last Name,
Suffix, Maiden Name, National ID Number, Chapter ID Number, Login Email, Contact Email,
Phone Number, Birthday, Potential New Member Class, Graduation Class, Home Address,
Campus Address, Date Registered, Date Last Logged In, Account Type, Nickname

A separate checkbox group `user_custom_fields[]` follows, for chapter-defined fields.

## "Select which requirements or event types you would like to show" (checkbox group `fields[]`)

Meeting Attendance, Chapter Balance (Dues), Service Hours, Academic Credits,
Chair Credits, Committee Credits, Dues, External Relations Credits, Fellowship Events,
Fundraising Credits, Interchapter Credits, Leadership Credits, Open Forum Credits,
Philanthropy Credits, Philanthropy Hourses, Required Events, Special Fellowships,
Training Credits

Then four options, verbatim:
- "Show service hours split by field in separate columns"
- "Show lacking requirements in separate columns"
- "Only show members lacking in the selected requirements"
- "Show lacking requirements in single summary column"

## "Select which account types you would like to show"

Prospects, Officers, Actives, Potential New Members, Associates, Advisors, Alumni,
Honoraries, Inactives, Deceased, Bad Standing, Leave of Absence, Half-Actives, System,
Awaiting Approval

These are the PLURAL account type labels, plus one extra value "Awaiting Approval" that
is not an account type on ?action=managestatuses.

## "Select a range of dates to filter records"

"Begin Date:", "End Date:", "Reset Calendar Dates", and this note, verbatim:
"The default dates shown are the defining dates of the current term as set in the Chapter
Configuration Settings page. It is strongly recommended to leave these dates alone unless
you need a report for a specific time period."

## "How would you like to view the report?"

- "Open report in a new window"
- "Save report as a Comma-Separated Value file (open with Excel)"

## Form

post, with hidden __csrf_magic and chapterId, then the checkbox groups above.
