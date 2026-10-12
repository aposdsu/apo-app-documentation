# URL inventory

> Summary: Every route found on the site, how it was reached, and whether it was captured.
> Status: OBSERVED
> Read this if: you want to know what the site is made of, or which pages the walkthrough
> did not open and why.

The site is one PHP script with a verb in the query string. Almost every page is
`memberhome.php?action=<verb>`, under a per-chapter path prefix
(`https://www.apoonline.org/alphadelta/`). A few routes are their own files
(`login.php`, `register.php`, `familytree.php`, `campaign.php`, `index.php`).

The session is an admin account, so "role access" records only what this account saw.
`admin-ok` means an admin could open it. It says nothing about anyone else.

## Legend for the "captured" column

- `yes` : opened and written to `raw/pages/`
- `read-only skip` : deliberately not opened, because opening it could change data.
  The reason is in the notes column. These are recorded in
  `docs/03-api/write-operations.md` instead.
- `not reached` : no capture, no blocker, just not visited. Listed in `docs/GAPS.md`.

## Public routes

| slug | URL | role access | captured | notes |
|---|---|---|---|---|
| home | / and /home.php | public | yes | vendor marketing page |
| login | /login.php | public | yes | redirected straight to the chapter home, so the session was already signed in |
| sitemap | /sitemap.xml | public | yes | lists ~300 chapter, section and region paths |
| robots | /robots.txt | public | yes | not served; the request returned the marketing home page |
| register | /alphadelta/register.php | public | yes | asks the visitor to pick student, advisor or alum before showing a form |

## Chapter application routes

All rows below are under `/alphadelta/memberhome.php?action=`, role access `admin-ok`,
and no XHR traffic was involved (the whole site is server-rendered HTML).

| action | what it is | captured | raw file |
|---|---|---|---|
| (none) | member home / dashboard | yes | raw/pages/memberhome.md |
| managemenu | Officer/Advisor dashboard, the admin hub | yes | raw/pages/memberhome_action-managemenu.md |
| setup | setup checklist, target of "System Settings" | yes | raw/pages/memberhome_action-setup.md |
| editsitesettings | chapter timezone | yes | raw/pages/memberhome_action-editsitesettings.md |
| setterm | term start dates | yes | raw/pages/memberhome_action-setterm.md |
| editchapterinfo | chapter profile | yes | raw/pages/memberhome_action-editchapterinfo.md |
| viewchapter&id=311 | the chapter's own page | yes | raw/pages/memberhome_action-viewchapter_id-311.md |
| managestatuses | account types and their privileges | yes | raw/pages/memberhome_action-managestatuses.md |
| editstatus&statusid= | edit one account type | yes | raw/pages/memberhome_action-editstatus_statusid-111.md |
| editprivileges&statusid= | privilege grid for one account type | yes | raw/pages/memberhome_action-editprivileges_statusid-2.md |
| editofficerpositions | define officer and advisor positions | yes | raw/pages/memberhome_action-editofficerpositions.md |
| editofficerprivileges&officerid= | privilege grid for one position | yes | raw/pages/memberhome_action-editofficerprivileges_officerid-2892.md |
| defineofficers | assign members to positions | yes | raw/pages/memberhome_action-defineofficers.md |
| managerequirements | list of requirements and point trackers | yes | raw/pages/memberhome_action-managerequirements.md |
| editrequirement&reqid=3 | edit a built-in requirement with categories | yes | raw/pages/memberhome_action-editrequirement_reqid-3.md |
| editrequirement&reqid=865 | edit a chapter-created requirement | yes | raw/pages/memberhome_action-editrequirement_reqid-865.md |
| createrequirement | create a requirement | yes | raw/pages/memberhome_action-createrequirement.md |
| createPointTracker | create a point tracker | yes | raw/pages/memberhome_action-createPointTracker.md |
| managerecords&reqid= | everyone's progress on one requirement | yes | raw/pages/memberhome_action-managerecords_reqid-3.md |
| viewrecords&reqid= | one member's own record for one requirement | yes | raw/pages/memberhome_action-viewrecords_reqid-3.md |
| manageevents&reqid= | events of one requirement type | yes | raw/pages/memberhome_action-manageevents_reqid-2.md |
| viewevents | upcoming events list | yes | raw/pages/memberhome_action-viewevents.md |
| eventcreate | create-event form | yes | raw/pages/memberhome_action-eventcreate.md |
| eventsignup&eventid= | one event's detail page | yes | raw/pages/memberhome_action-eventsignup_eventid-1152799.md |
| eventedit&eventid= | edit-event form | yes | raw/pages/memberhome_action-eventedit_eventid-1152799.md |
| pendingevents | events ready to be completed | yes | raw/pages/memberhome_action-pendingevents.md |
| brothers | the roster | yes | raw/pages/memberhome_action-brothers.md |
| managebrother&userid=&panel=account | Account Manager, one member | yes | raw/pages/memberhome_action-managebrother_panel-account.md |
| viewMembershipStages | transition members between stages | yes | raw/pages/memberhome_action-viewMembershipStages.md |
| inviteuser | four ways to add members | yes | raw/pages/memberhome_action-inviteuser.md |
| userspending | pending registrations to approve | yes | raw/pages/memberhome_action-userspending.md |
| managedues | dues, fees and payment logging | yes | raw/pages/memberhome_action-managedues.md |
| viewtransactions | transaction ledger | yes | raw/pages/memberhome_action-viewtransactions.md |
| managebudget | budgets per officer position | yes | raw/pages/memberhome_action-managebudget.md |
| billingoverview | what the chapter pays the vendor | yes | raw/pages/memberhome_action-billingoverview.md |
| viewmychapterinvoices | chapter invoices | yes | raw/pages/memberhome_misc-surfaces.md |
| viewmyuserinvoices | a member's invoices | yes | raw/pages/memberhome_misc-surfaces.md |
| createreport | progress / membership / complete report builder | yes | raw/pages/memberhome_action-createreport.md |
| createeventreport | attendance report builder | yes | raw/pages/memberhome_misc-surfaces.md |
| manageUserAwards | define chapter awards | yes | raw/pages/memberhome_action-manageUserAwards.md |
| manageballot | award voting setup | yes | raw/pages/memberhome_misc-surfaces.md |
| managechapterachievements | achievements list | yes | raw/pages/memberhome_action-createchapterachievement.md |
| createchapterachievement | create an achievement | yes | raw/pages/memberhome_action-createchapterachievement.md |
| managefamilies | lines (families) admin | yes | raw/pages/memberhome_action-managefamilies.md |
| families | view lines | yes | raw/pages/memberhome_misc-surfaces.md |
| viewAlumni | alumni employment directory | yes | raw/pages/memberhome_misc-surfaces.md |
| topbrothers | leaderboards | yes | raw/pages/memberhome_misc-surfaces.md |
| profile | a member's own profile | yes | raw/pages/memberhome_misc-surfaces.md |
| contactPreferences | notification settings | yes | raw/pages/memberhome_misc-surfaces.md |
| viewnotifications | in-app notifications | yes | raw/pages/memberhome_action-viewnotifications.md |
| viewlog | access log (audit trail) | yes | raw/pages/memberhome_action-viewlog.md |
| viewcomments | comment form settings and archive | yes | raw/pages/memberhome_misc-surfaces.md |
| selectEmailAudience | bulk email, step 1 | yes | raw/pages/memberhome_misc-surfaces.md |
| manageAnnouncements | announcements | yes | raw/pages/memberhome_misc-surfaces.md |
| viewstorage | file manager (blocked, needs a higher vendor plan) plus the subscription tier chart | yes | raw/pages/memberhome_action-viewstorage_tier-chart.md |
| whatsNew | the platform's release notes, 2018 to 2026 | yes | raw/pages/memberhome_action-whatsNew.md |
| viewforms | forms | yes | raw/pages/memberhome_action-viewforms.md |
| manageminutes | meeting minutes | yes | raw/pages/memberhome_action-manageminutes.md |
| viewCourses | course catalogue | yes | raw/pages/memberhome_misc-surfaces.md |
| managewebsite | external public website builder | yes | raw/pages/diamond-tier-sweep.md |
| manageSms | SMS message log | yes | raw/pages/diamond-tier-sweep.md |
| smsform | compose an SMS (form read, not submitted) | yes | raw/pages/diamond-tier-sweep.md |
| managealbums | photo albums, with an approval step | yes | raw/pages/diamond-tier-sweep.md |
| manageblog | chapter blog | yes | raw/pages/diamond-tier-sweep.md |
| createblog | new blog post form | yes | raw/pages/diamond-features-how-they-work.md |
| managepages | homepage columns and custom webpages | yes | raw/pages/diamond-features-how-they-work.md |
| managetabs | the four public header tab slots | yes | raw/pages/diamond-features-how-they-work.md |
| managethemes | website colour themes | yes | raw/pages/diamond-features-how-they-work.md |
| addpictures | add photos to an album; switched off by the vendor | yes | raw/pages/diamond-features-how-they-work.md |
| manageeventattachments | files on one event, with a six-month retention rule | yes | raw/pages/diamond-features-how-they-work.md |
| createFund | create a fundraising fund | yes | raw/pages/diamond-features-how-they-work.md |
| /alphadelta/blog.php | the chapter's public blog page | yes | raw/pages/diamond-features-how-they-work.md |
| managePaymentProcessors | Stripe connection | yes | raw/pages/memberhome_misc-surfaces.md |
| manageFunds | fundraising funds and campaigns | yes | raw/pages/diamond-tier-sweep.md |

## Routes captured in the completeness pass

All in `raw/pages/completeness-pass.md` unless noted.

| action | what it is |
|---|---|
| vieweventcalendar | month calendar, three scopes, one filter per requirement plus "Other Events" |
| vieweventcalendar_region | the same page scoped to Region B |
| vieweventcalendar_nation | the same page scoped to national headquarters |
| viewmessage | private member-to-member message threads |
| viewJobs | job board, with a fixed industry list |
| myDonations | a member's giving record: cash, non-cash gifts, soft credits |
| myMembersExternalInvoices | invoices sent to this chapter's members by other bodies |
| manageEmailSubscriptions | sent and draft e-mail |
| defineEmailFilters | e-mail audience, step 1 of a 4-step wizard |
| comment | the member-facing anonymous comment form |
| getHelp | vendor support routes |
| editofficerposition | edit one position; only the title is editable |
| editblog | edit a post; visibility and publish date are absent |
| edithomepageimage | public homepage image, max 2MB |
| createform | the form builder, 13 question types |
| createCourse | the course builder |
| manageCourses / manageforms / managechapterachievements / viewchapterachievements | empty on this chapter |
| managePaymentProcessors | Stripe, checkout pages |
| editprofile | the member's own profile editor; five visibility levels, affiliations, profile history |
| viewtransactions (Log Transaction form) | Withdraw / Deposit / Dues Payment / Fee Assessment, with a receipt file |
| createblog, managepages, managetabs, managethemes, addpictures, manageeventattachments, createFund, blog.php | see raw/pages/diamond-features-how-they-work.md |

## Routes found by reading the page source rather than the navigation

These do not appear in any menu. They were found by extracting every `action=` value from
the anchors on the dashboard, the profile and the Account Manager.

| action | what it is | raw file |
|---|---|---|
| editchapterlinks | edit the chapter's links, including the nav-menu ones | raw/pages/newly-found-verbs.md |
| manageUserAwardRecords | give an award to a member | raw/pages/newly-found-verbs.md |
| verifyRoster | audit and correct every member's account type | raw/pages/newly-found-verbs.md |
| createAlbum | create a photo album | raw/pages/newly-found-verbs.md |
| createuserfield | add a custom field to all member profiles | raw/pages/custom-fields-and-leads.md |
| editapoleads | a member's LEADS record | raw/pages/custom-fields-and-leads.md |
| changepassword | password and linked social logins | raw/pages/whatsNew-full-read.md |
| resetPassword | **not opened**; would reset a member's password | recorded only |

## Account Manager panels

`?action=managebrother&userid=<id>&chapterid=311&panel=<name>`, ten of them, all captured in
`raw/pages/managebrother-all-panels.md`: `profile` (alias `account`), `status`, `records`,
`awards`, `family`, `events`, `files`, `engagement`, `notifications`, `apoleads`.

## Routes that cannot be reached without writing

| Surface | Why |
|---|---|
| E-mail wizard steps 2 to 4 | reached only by submitting step 1 |
| Award ballot setup | behind a button labelled "Setup Ballot", a creation verb |
| Mobile check-in at run time | only appears on an event that has it enabled |
| Any invoice detail | this chapter has no invoices |
| Photo album image handling | the vendor has switched the page off |

## Routes deliberately not opened

Every row here would, or might, change data. They were read from links and recorded, not
visited. Each has an entry in `docs/03-api/write-operations.md`.

| action | why not opened |
|---|---|
| setnotifyupcomingeventsflag&notify=1 / &notify=0 | carries the value to store; a plain GET would change a setting |
| logout | would end the session mid-run |
| refreshUserInfo | the verb suggests it rewrites cached account data |
| deleteofficerposition&officerid= | destructive |
| deletestatus&statusid= | destructive |
| removerequirement&reqid= | destructive |
| eventdelete&eventid= | destructive |
| eventcomplete&eventid= | awards credit to every attendee |
| goLiveInvitations | sends activation e-mails |
| defineEmailFilters&eventid= , smsform&eventid= | lead to sending mail or SMS |
| campaign.php | public donation page; not opened to avoid touching a payment flow |

## Routes read later, in the unread-routes and flow sweeps (2026-08-29/30)

Once "not reached", now read in full (`raw/pages/unread-routes-sweep.md`,
`raw/pages/signup-flow-observed.md`, `raw/pages/award-and-password-flows.md`):
`manageCourses`, `createCourse`, `createform`, `createFund`, `smsform`, `defineEmailFilters`,
`getHelp`, `manageStore` (plan-gated), `register.php`, `familytree.php`, `manageblog`,
`viewJobs`, `viewmessage`, `manageEmailSubscriptions`, `manageforms`, `comment`,
`myDonations`, `contactPreferences`, `manageballot`, `changepassword`, `userspending`,
`inviteuser`, `viewMembershipStages`, `editrequirement&reqid=1/2/944`, and every
`managebrother` panel.

## Routes seen but still not read

A short list, all low value:
`?action=myMembersExternalInvoices`, `?action=managealbums`, `?action=manageSms`, and
`?action=viewchapterachievements` (this chapter has no achievements defined). Out-of-scope
multi-chapter views are also unread on purpose: `vieweventcalendar_region`,
`vieweventcalendar_nation`, and `viewchapter` with no id ("View All Chapters/Groups").
