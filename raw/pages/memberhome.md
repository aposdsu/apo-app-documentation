# Capture: memberhome.php (member/officer home dashboard)

- URL: https://www.apoonline.org/alphadelta/memberhome.php
- Captured: 2026-08-28
- Method: Claude in Chrome, read_page (accessibility tree, filter=all) + get_page_text
- Chapter context: Alpha Delta (chapter id 311, from link `memberhome.php?action=viewchapter&id=311`)
- Note: personal data of the logged-in account replaced with placeholders. Nothing was clicked or submitted.

## Redirect observed

Navigating to `https://www.apoonline.org/login.php` while an authenticated session existed
redirected to `https://www.apoonline.org/alphadelta/memberhome.php?login=successful&`.

## Page structure (verbatim link hrefs and labels)

Header:
- link "APOonline" -> https://www.apoonline.org
- link (avatar) -> ?action=editprofile  (label: <member name redacted>)
- link "Alpha Delta" -> memberhome.php?action=viewchapter&id=311  (sublabel "Chapter")
- link "Alpha Phi Omega National Service Fraternity" -> index.php
- textbox placeholder "Search members or groups..." inside a form with two hidden inputs
  (one value redacted)
- link "view all" -> memberhome.php?action=viewnotifications  (under heading "Notifications")

Navigation menu:

- Home -> memberhome.php?action=refreshUserInfo
- Records -> memberhome.php?action=profile&panel=records
  - Dues & Fees -> ?action=viewrecords&reqid=1
  - Meetings -> ?action=viewrecords&reqid=2
  - Service Hours -> ?action=viewrecords&reqid=3
  - Fellowship Events -> ?action=viewrecords&reqid=865
  - Leadership Credits -> ?action=viewrecords&reqid=866
  - Fundraising Credits -> ?action=viewrecords&reqid=867
  - Interchapter Credits -> ?action=viewrecords&reqid=912
  - Chair Credits -> ?action=viewrecords&reqid=925
  - Special Fellowships -> ?action=viewrecords&reqid=937
  - Committee Credits -> ?action=viewrecords&reqid=944
  - Academic Credits -> ?action=viewrecords&reqid=1507
  - External Relations Credits -> ?action=viewrecords&reqid=1511
  - Open Forum Credits -> ?action=viewrecords&reqid=1605
  - Required Events -> ?action=viewrecords&reqid=2130
  - Philanthropy Hourses -> ?action=viewrecords&reqid=2164
  - Dues -> ?action=viewrecords&reqid=2234
  - Philanthropy Credits -> ?action=viewrecords&reqid=2236
  - Training Credits -> ?action=viewrecords&reqid=2377
  - My Invoices -> memberhome.php?action=viewmyuserinvoices
  - Alpha Delta Invoices -> memberhome.php?action=viewmychapterinvoices
- Events -> memberhome.php?action=vieweventcalendar
  - View Upcoming Events -> memberhome.php?action=viewevents
  - View Event Calendar -> memberhome.php?action=vieweventcalendar
  - View Region B Calendar -> memberhome.php?action=vieweventcalendar_region
  - View National Calendar -> memberhome.php?action=vieweventcalendar_nation
  - Add Calendar Event -> memberhome.php?action=eventcreate
- Events -> memberhome.php?action=viewevents
- Members -> memberhome.php?action=brothers
  - View Members -> memberhome.php?action=brothers
  - View Lines -> memberhome.php?action=families
  - View All Chapters/Groups -> memberhome.php?action=viewchapter
  - View Top Members -> memberhome.php?action=topbrothers
  - View Achievements -> memberhome.php?action=viewchapterachievements
  - View Family Tree -> familytree.php
  - View Alumni Directory -> memberhome.php?action=viewAlumni
  - Add New Members -> memberhome.php?action=inviteuser
  - View Pending Registrations -> memberhome.php?action=userspending
  - Send Activation Emails -> memberhome.php?action=goLiveInvitations
  - Transition Members -> memberhome.php?action=viewMembershipStages
  - Transition Officers & Advisors -> memberhome.php?action=defineofficers
  - Membership Report -> memberhome.php?action=createreport&subAction=membershipReport
- Manage -> memberhome.php?action=managemenu
  - Officer/Advisor Dashboard -> memberhome.php?action=managemenu
  - Account Types & Privileges -> memberhome.php?action=managestatuses
  - Officer Positions & Privileges -> memberhome.php?action=editofficerpositions
  - Member Requirements -> memberhome.php?action=managerequirements
  - Achievements -> memberhome.php?action=managechapterachievements
  - Awards -> memberhome.php?action=manageUserAwards
  - System Settings -> memberhome.php?action=setup#gears
- More...
  - Forms -> memberhome.php?action=viewforms
  - Courses -> memberhome.php?action=viewCourses
  - Job Board -> ?action=viewJobs
  - Meeting Minutes -> ?action=manageminutes
  - Chapter Budget -> ?action=managebudget
  - Comment Form -> memberhome.php?action=comment
  - Facebook / Instagram / Twitter / Youtube / Smugmug / chapter website -> external URLs

Account menu (bottom of tree):
- View Profile -> ?action=profile
- View Messages -> ?action=viewmessage
- Edit Profile -> ?action=editprofile
- Contact Preferences -> ?action=contactPreferences
- System Settings -> ?action=setup#gears
- Get Help -> ?action=getHelp
- Submit Feedback -> #feedback
- What's New -> ?action=whatsNew
- APOonline Billing -> ?action=billingoverview
- Logout -> ?action=logout

## Dashboard body

- "Welcome <member name redacted>!"
- Quick action buttons: "Manage Membership" -> memberhome.php?action=viewMembershipStages,
  "Send Email" -> memberhome.php?action=selectEmailAudience,
  "Post Event" -> memberhome.php?action=eventcreate
- Panel "Weekly event email digest": "Would you like to receive an email every Sunday
  letting you know what events are coming up each week"
  - link "Sign me up!" -> ?action=setnotifyupcomingeventsflag&notify=1   [NOT OPENED: writes on GET]
  - link "No thanks"   -> ?action=setnotifyupcomingeventsflag&notify=0   [NOT OPENED: writes on GET]
- Panel "Does this look right?" showing, for the logged-in account:
  - "Email address": <email redacted>
  - "Mailing Address": "Missing information"
  - "Phone number": <phone redacted>
  - button "update profile" -> memberhome.php?action=editprofile
- Panel "Membership Status": value shown = "Alumni"
- Panel "Give Back - Thank you!": "$0.00", label "Total Donations",
  button "donate" -> campaign.php, link "view history" -> ?action=myDonations
- Panel "Work Experience": link "add work experience" -> ?action=editprofile&subAction=addUserJob
- Panel "Looking for a job?": button "search job postings" -> ?action=viewJobs
- Heading "Chapter Advisor Dashboard"
- Panel "APOONLINE OFFICIAL TRAINING WEBINARS" (vendor content, list of dated webinar
  recordings on Google Drive; not chapter data)
- Panel "Budget: $0 remaining" -> memberhome.php?action=viewtransactions&filter=officer%7C6144
  (the filter value decodes to `officer|6144`)
- Panel "1 event ready to be completed!" -> memberhome.php?action=pendingevents
- Panel "My Upcoming Events": "You're not signed up for any events",
  button "find an event" -> ?action=vieweventcalendar, link "find an event »" -> ?action=viewevents
- A dialog element titled "Announcement" with a Close button was present.
