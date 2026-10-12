# The pages of the site

> Summary: What every page of APOonline is for, in one line each, with links to the longer
> write-ups for the fifteen pages that matter most.
> Status: OBSERVED
> Read this if: you want to know what a screen does before you open its capture.
> Depends on: docs/INVENTORY.md

The whole application is one PHP script, `memberhome.php`, with a verb in the query
string. The route is the verb.

## Pages with their own write-up

| Page | Verb | What it is for |
|---|---|---|
| [Officer dashboard](managemenu.md) | managemenu | the hub every officer works from |
| [Account types](managestatuses.md) | managestatuses | the chapter's membership categories |
| [Account type privileges](editprivileges.md) | editprivileges | what an ordinary member of that type may do |
| [Officer positions](editofficerpositions.md) | editofficerpositions | the offices the chapter has |
| [Position privileges](editofficerprivileges.md) | editofficerprivileges | what an officer holding that position may manage |
| [Requirements](managerequirements.md) | managerequirements | the rules members have to meet |
| [Edit a requirement](editrequirement.md) | editrequirement | labels, categories, and a target per account type |
| [Create an event](eventcreate.md) | eventcreate | the biggest form on the site |
| [An event](eventsignup.md) | eventsignup | one event, its attendees and its admin actions |
| [Events to complete](pendingevents.md) | pendingevents | where attendance turns into credit |
| [Progress for everyone](managerecords.md) | managerecords | one requirement, every member, a date window |
| [A member's own record](viewrecords.md) | viewrecords | their credits, and the manual entry form |
| [Account Manager](managebrother.md) | managebrother | one member's profile, records, awards, line and events |
| [Term dates](setterm.md) | setterm | the two dates that define what "this term" means |
| [Access log](viewlog.md) | viewlog | who did what, and when |

## Every other page, one line each

| Verb | What it is for |
|---|---|
| (no verb) | the member's home page: their status, their upcoming events, officer shortcuts |
| setup | a 16-step setup checklist; also the target of the "System Settings" menu item |
| editsitesettings | one setting, the chapter's timezone |
| editchapterinfo | the chapter's institution, address and contact details |
| viewchapter | the chapter's public-facing page inside the app, with its officers |
| defineofficers | assign members to positions, in one big form |
| viewMembershipStages | move members in bulk between Prospect, PNM, Member and Alumni |
| brothers | the roster, grouped by account type |
| inviteuser | four ways to add members, including CSV and a public registration link |
| userspending | approve people who registered themselves |
| viewevents | the list of upcoming events with their credit chips |
| vieweventcalendar | the same events as a calendar |
| manageevents | every event of one requirement type |
| eventedit | the create-event form with the record's values filled in |
| createrequirement / createPointTracker | add a new requirement, or a simple point counter |
| managedues | who owes what, and the form that logs a payment or a fee |
| viewtransactions | the money ledger, filterable by officer, with CSV and PDF export |
| managebudget | an allocated amount per officer position, and custom budgets |
| viewmychapterinvoices / viewmyuserinvoices | invoices for the chapter and for one member |
| billingoverview | what the chapter pays the vendor, and the subscription tiers |
| createreport | build a progress or membership report and download it as CSV |
| createeventreport | the same for event attendance |
| manageUserAwards / manageballot | define chapter awards, then run a vote on them |
| managechapterachievements / createchapterachievement | badges, awarded automatically or by hand |
| managefamilies / families | families/groups (this chapter calls them "lines"), the big and little structure |
| editfamilysettings | rename Family and Big/Little for the whole chapter, and toggle Top Lines |
| viewAlumni | search alumni by industry, employer or location |
| topbrothers | leaderboards per requirement, for the chapter, the region or the nation |
| profile | a member's own profile, with tabs for timeline, events, records, line, achievements, awards |
| contactPreferences | which e-mails a member wants, and how far ahead |
| viewnotifications | the in-app record of credits awarded |
| viewcomments | settings and archive for an anonymous feedback form |
| selectEmailAudience | a four-step wizard for sending bulk e-mail |
| manageAnnouncements | messages pinned to every member's home page |
| viewstorage | the file manager; three audiences per file, and a file may be an external link |
| editchapterlinks | **where the nav-menu links are edited.** The dashboard's "External Links" panel points at the wrong route |
| createuserfield | add a custom field to every member profile: 9 types, 8 visibility levels, a uniqueness rule |
| manageUserAwardRecords | give an award to a member; five built-in Distinguished Service Keys |
| verifyRoster | audit every member's account type, Approve or Change, with positions |
| createAlbum | create a photo album (note the capital A; the lowercase spelling is not a route) |
| editapoleads | a member's LEADS sessions: date attended and location |
| changepassword | password change, plus Connect/Disconnect for Google and Facebook |
| viewforms / manageforms | forms the chapter or the national office asks members to fill in |
| manageminutes | meeting minutes |
| viewCourses / manageCourses | a small learning system with quizzes |
| managewebsite / manageblog / managealbums | the chapter's public website, blog and photo albums |
| managePaymentProcessors | connect Stripe to take dues online |
| manageFunds | fundraising funds and campaigns, with donor reports |
