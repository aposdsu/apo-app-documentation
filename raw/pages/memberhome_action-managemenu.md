# Capture: memberhome.php?action=managemenu  (Officer/Advisor Dashboard)

- URL: https://www.apoonline.org/alphadelta/memberhome.php?action=managemenu
- Captured: 2026-08-28 via get_page_text + read_page + find (no submission)

## Quick-create row at the top

| Label | href |
|---|---|
| Event | ?action=eventcreate |
| Email | ?action=manageEmailSubscriptions |
| SMS | ?action=manageSms |
| Announcement | ?action=manageAnnouncements |
| Files | ?action=viewstorage |
| Forms | ?action=manageforms |
| Courses | ?action=manageCourses |
| Minutes | ?action=manageminutes |
| System Settings | ?action=setup#gears |

## Panel "Events & Requirement Progress"

- heading link "Events & Requirement Progress" -> ?action=vieweventcalendar
- link "Add new event types or change your membership's attendance requirements" -> ?action=managerequirements
- link "Attendance Report" -> ?action=createeventreport
- link "Progress Report" -> ?action=createreport&subAction=progressReport
- footer link, verbatim: "create event type and corresponding requirement progress bar"

One block per event type. Each block has three links with the same shape:

| Block heading | manage events link | progress link | inline event or empty-state |
|---|---|---|---|
| Meetings | ?action=manageevents&reqid=2 | ?action=managerecords&reqid=2 | "Upcoming: 8/31 <event title>" -> ?action=eventsignup&eventid=1152799 |
| Service Projects | ?action=manageevents&reqid=3 | ?action=managerecords&reqid=3 | "Upcoming: 9/3 <event title>" -> ?action=eventsignup&eventid=1159629 |
| Fellowship Events | ?action=manageevents&reqid=865 | ?action=managerecords&reqid=865 | "8/28 <event title> needs to be completed!" -> ?action=eventcomplete&eventid=1160879 |
| Leadership Credits | ?action=manageevents&reqid=866 | ?action=managerecords&reqid=866 | "Upcoming: 8/31 <event title>" -> ?action=eventsignup&eventid=1154666 |
| Fundraising Credits | ?action=manageevents&reqid=867 | ?action=managerecords&reqid=867 | "There are no upcoming fundraising credits. create fundraising credit" -> ?action=eventcreate&reqid=867 |
| Interchapter Credits | ?action=manageevents&reqid=912 | ?action=managerecords&reqid=912 | "Upcoming: 9/20 <event title>" -> ?action=eventsignup&eventid=1160592 |
| Chair Credits | ?action=manageevents&reqid=925 | ?action=managerecords&reqid=925 | "create chair credit" -> ?action=eventcreate&reqid=925 |
| Special Fellowships | ?action=manageevents&reqid=937 | ?action=managerecords&reqid=937 | "create special fellowship" -> ?action=eventcreate&reqid=937 |
| Committee Credits | ?action=manageevents&reqid=944 | ?action=managerecords&reqid=944 | "create committee credit" -> ?action=eventcreate&reqid=944 |
| Academics | ?action=manageevents&reqid=1507 | ?action=managerecords&reqid=1507 | "create academic" -> ?action=eventcreate&reqid=1507 |
| External Relations | ?action=manageevents&reqid=1511 | ?action=managerecords&reqid=1511 | "8/27 <event title> needs to be completed!" -> ?action=eventcomplete&eventid=1159564 |
| Open Forums | ?action=manageevents&reqid=1605 | ?action=managerecords&reqid=1605 | "Upcoming: 8/31 <event title>" -> ?action=eventsignup&eventid=1154666 |
| Required Events | ?action=manageevents&reqid=2130 | ?action=managerecords&reqid=2130 | "Upcoming: 9/11 <event title>" -> ?action=eventsignup&eventid=1160160 |
| Philanthropy Hours | ?action=manageevents&reqid=2164 | ?action=managerecords&reqid=2164 | "Upcoming: 9/3 <event title>" -> ?action=eventsignup&eventid=1159629 |
| Dues Credits | ?action=manageevents&reqid=2234 (by pattern) | ?action=managerecords&reqid=2234 (by pattern) | "create dues credit" |
| Philanthropies | (same pattern, reqid=2236) | | "create philanthropy" |
| Training Credits | (same pattern, reqid=2377) | | "create training credit" |

The repeated link tooltip text, verbatim: "View your member's progress on their attendance
requirement for this event type."

Two observations worth keeping:
- eventid 1154666 appears under BOTH "Leadership Credits" (reqid 866) and "Open Forums"
  (reqid 1605), as the same 8/31 event title.
- eventid 1159629 appears under BOTH "Service Projects" (reqid 3) and "Philanthropy Hours"
  (reqid 2164), as the same 9/3 event title.

## Panel "Members"

Links: "Members", "Lines", "Invite Member", "Transition Members", "Member Report",
and "Account Manager" -> ?action=managebrother

Counts displayed, verbatim:
- 0 Prospects
- 0 Potential New Members
- 66 Members
- 523 Alumni

Sub-panels:
- "Pending Users": "There are 7 users pending approval before they can log in!"
- "Award Voting": "Ballot Closed. To open ballots, first define your awards then setup
  your ballot."
  - "define your awards" -> ?action=manageUserAwards
  - "setup your ballot" -> ?action=manageballot
- "Officers": "You may assign members to these vacant positions: Academic Chair,
  Equity & Inclusion Chair, Special Events Coordinator, Conference Chair."
- "Advisors": "1 advisor positions, all filled."

## Panel "Finances"

| Label | href |
|---|---|
| Finances (heading) | ?action=viewtransactions |
| Budget | ?action=managebudget |
| Invoices | ?action=viewmychapterinvoices |
| Log Payment | ?action=managedues&prefillType=payment |
| Charge Fee | ?action=managedues&prefillType=fee |
| Transaction Ledger | ?action=viewtransactions |
| Dues & Fees | ?action=managedues |
| My Members' Invoices | ?action=myMembersExternalInvoices |
| Accept Online Payments | ?action=managePaymentProcessors |
| Fundraising Campaigns | ?action=manageFunds |

Text, verbatim:
- Dues & Fees: "You haven't configured how much each member owes in dues or by when."
- My Members' Invoices: "View a list of invoices sent to your members from outside your Chapter."
- Accept Online Payments: "Manage your online payment processor settings."
- Fundraising Campaigns: "Create a fundraising campaign to raise money for a cause or your chapter."

## Panel "Website"

| Label | href |
|---|---|
| Blog | ?action=manageblog |
| Photo Albums | ?action=managealbums |
| External Website | ?action=managewebsite |
| External Links | ?action=managemenu |

## Panel "The GreekTracker TM"

Text, verbatim: "Upcoming tasks and deadlines for your chapter."
"December 19th marks the end of current term and the beginning of next."
- link "View Progress Report" -> ?action=createreport
- link "Change Date" -> ?action=setterm

## Footer links

- "Comment Feedback" -> ?action=viewcomments
- "Access Log" -> ?action=viewlog
- "APOonline Learning Center", "Support" (vendor links)
