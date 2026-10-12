# The complete privilege lists

> Summary: Every privilege the platform has, in both grids, with the internal field name
> and the exact label shown on screen.
> Status: OBSERVED
> Read this if: you are seeding the `privilege` table, or you want a feature list that is
> guaranteed to be complete, because each privilege names a feature.
> Depends on: docs/04-system-design/02-auth-and-permissions.md

Source files:
`raw/pages/memberhome_action-editofficerprivileges_officerid-2892.md` and
`raw/pages/memberhome_action-editprivileges_statusid-2.md`.

Where a field name begins with `hide` or `disallow`, the "Allow" column sends `false`.
Those rows are marked "inverted".

## Grid 1: account type privileges (40)

### Event privileges

| Label on screen | Field name | Inverted |
|---|---|---|
| View chapter/group events | hideChapterEvents | yes |
| Create an event | createevent | no |
| Sign up for an event | rsvpevent | no |
| View attendees for an event | disallowviewrsvp | yes |
| Edit event information as Event Coordinator | cooredit | no |
| Complete event as Event Coordinator | coorcomplete | no |
| Send Text (SMS) to event attendees as Event Coordinator | eventsms | no |

### Access privileges

| Label on screen | Field name | Inverted |
|---|---|---|
| View roster and profiles of other members | hideMembers | yes |
| Post on the blog | postblog | no |
| Upload photos to photo albums | postimage | no |
| Manage photos and photo albums | managephotos | no |
| View meeting minutes | hideChapterMinutes | yes |
| Manage meeting minutes | adminminutes | no |
| View budget and transactions | viewbudget | no |
| View anyone's requirement progress | hideprogress | yes |
| View family lineage | hidefamily | yes |
| Edit own family lineage | ownfamily | no |
| Send feedback to officers using the Comment Form | commentform | no |
| Send Bulk Emails | bulkemail | no |
| Send Bulk Text (SMS) Messages | bulksms | no |
| View chapter/group files in the File Manager | hideChapterFiles | yes |
| Upload files to the File Manager | uploadfile | no |
| View Alumni Directory | hideAlumniDirectory | yes |

### Record privileges, headed "(not recommended)"

One per requirement, labelled "Log their own: Internal &lt;requirement&gt;", field name
`req<requirement id>`. On this chapter: req1507 Academic Credits, req925 Chair Credits,
req944 Committee Credits, req2234 Dues, req1511 External Relations Credits,
req865 Fellowship Events, req867 Fundraising Credits, req912 Interchapter Credits,
req866 Leadership Credits, req2 Meetings, req1605 Open Forum Credits,
req2236 Philanthropy Credits, req2164 Philanthropy Hourses, req2130 Required Events,
req3 Service Hours, req937 Special Fellowships, req2377 Training Credits.

Requirement 1, "Dues & Fees", has no row here.

## Grid 2: officer position privileges (39)

### Access privileges

| Label on screen | Field name |
|---|---|
| Configure Site Settings (Site Admin) | config |
| Invite/Approve New Users to this Site & Manage Users' Account Type/Status | approveusers |
| Manage External Webpages | webpages |
| Post and Approve Photo Album Images | approveimages |
| Post and Approve Blog Posts | approveposts |
| Edit Member Profile Information | editprofile |
| Manage Fundraising Campaigns | fundraising |
| Post Announcements | announcements |
| Send Bulk Emails | bulkemail |
| Send Bulk SMS | bulksms |
| Manage Families/Groups | families |
| Manage Achievements | achievements |
| Manage Meeting Minutes | adminminutes |
| Manage Awards and Award Voting | awards |
| Upload Files to the File Manager | uploadfile |
| Create Forms | createform |
| Complete Forms Requested by Alpha Phi Omega staff | submitform |
| Manage Courses, Course Content, Setup Quiz Answer Keys, and Grade Quizzes | lms |
| Manage External Sales Tools: Companies, Employees, Products, and external Invoices | crm |
| Manage Calls for Applications | applications |

A note printed under the second row, verbatim: "Members with this privilege will receive
an email notification each time someone registers and needs approval."

### Requirement / Point Tracker privileges

One per requirement, labelled "Manage &lt;requirement&gt; Requirement", field name
`req<requirement id>`, plus one extra:

| Label on screen | Field name |
|---|---|
| Manage Dues Requirement & Chapter Finances | req1 |
| Manage Meeting Requirement | req2 |
| Manage Service Hour Requirement | req3 |
| Manage Fellowship Event Requirement | req865 |
| Manage Leadership Credit Requirement | req866 |
| Manage Fundraising Credit Requirement | req867 |
| Manage Interchapter Credit Requirement | req912 |
| Manage Chair Credit Requirement | req925 |
| Manage Special Fellowship Requirement | req937 |
| Manage Committee Credit Requirement | req944 |
| Manage Academic Credit Requirement | req1507 |
| Manage External Relations Credit Requirement | req1511 |
| Manage Open Forum Credit Requirement | req1605 |
| Manage Required Event Requirement | req2130 |
| Manage Philanthropy Hours Requirement | req2164 |
| Manage Dues Requirement | req2234 |
| Manage Philanthropy Credit Requirement | req2236 |
| Manage Training Credit Requirement | req2377 |
| Manage Other (Non-Associated) Events | otherevents |

Note that `req1` is worded "Manage Dues Requirement **& Chapter Finances**". That one
privilege is what gates the whole money section of the site, which is why the treasurer
needs it and nobody else should have it.

## Suggested seeding for your own build

Some field names appear in both grids. Four mean the same thing in both: `bulkemail`,
`bulksms`, `uploadfile`, `adminminutes`. The `req<id>` names appear in both too, but they
mean different things: in the officer grid `req3` is "Manage Service Hour Requirement",
and in the account-type grid `req3` is "Log their own: Internal Service Hours". Treat them
as two separate privileges when you seed your table, for example `service.manage` and
`service.log_own`.

That is why the `privilege` table in the proposed schema has a `grantable_to` column,
whose value is `both` only for the four that really are the same privilege.

`[design]` A single chapter will not need `crm`, `applications`, `lms`, `submitform`, or
`webpages`. Seed the ones whose feature you are actually building, and add rows as
features land. An unused privilege row is harmless; a missing check is not.
