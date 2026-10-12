# Who can do what, feature by feature

> Summary: For each feature, the actions a person can take on it, the privilege that gates
> each action, and which account types or officer positions hold that privilege on this
> chapter. This is the per-feature view of the two permission grids.
> Status: OBSERVED (privileges and who holds them, from the grids) with `[inferred]` marked
> where an action is linked to a privilege by reasoning rather than by the privilege's label.
> Read this if: you are building a screen and need to know, for one feature, what buttons to
> show and who may press them.
> Depends on: docs/04-system-design/02-auth-and-permissions.md,
> docs/04-system-design/02a-privilege-lists.md, docs/03-api/write-operations.md

## How to read this

A person's abilities are the union of two things: the privileges of their **account type**
(grid 1, what an ordinary member may do) and the privileges of every **officer position**
they hold (grid 2, what an officer may manage). Each table below lists an action, the
privilege that gates it, and who holds that privilege as this chapter configured it
(`raw/pages/permission-matrix-complete.md`). "The five" means the five positions that hold
every officer privilege: President, Chapter Advisor, Membership Vice President, Equity &
Inclusion Chair, Historian.

Two cautions. "Who holds it" is **this chapter's configuration**, not a product rule; another
chapter can set the grids differently. And the grids say what the settings grant; whether the
server refuses an action to someone without the privilege was not tested (see the auth
document).

## Events

| Action | Where / operation | Gating privilege | Who holds it here |
|---|---|---|---|
| View the event list and an event | `?action=viewevents`, `eventsignup` | `hideChapterEvents` (type, inverted) | every account type except Prospect |
| Sign up for an event (and cancel) | sign-up row on `eventsignup` | `rsvpevent` (type) | Officer, Active, PNM, Associate, Advisor, Alum, Honorary, Half-Active, System, Bad Standing. **Not** Prospect, Inactive, Leave of Absence, Deceased |
| See who else signed up | attendee list on the event | `disallowviewrsvp` (type, inverted) | every account type except Prospect |
| Create an event | `eventcreate` → `eventadd` | `createevent` (type) | **Officer account type only** |
| Edit an event you coordinate | `eventedit` | `cooredit` (type) | Officer, Active |
| Complete an event you coordinate (awards credit) | `eventcomplete` → `eventcompletedo` | `coorcomplete` (type) | **Officer account type only** |
| Text the attendees of an event you coordinate | event SMS | `eventsms` (type) | Officer, Active, PNM, Associate |
| Manually add a member to the attendee list | "Manually add member" on the event | `[inferred]` coordinator or a manage-requirement position | not stated on a grid |
| Delete an event | `eventdelete` (GET) | `[inferred]` coordinator/officer; no grid row names it | not stated on a grid |
| Create an event that credits no requirement ("Other" events) | event type "Other" | `otherevents` (position) | Pledge Trainer, Public Relations Chair, the five |
| Attach a file to an event | `manageeventattachments` | `[inferred]` `uploadfile` | see Files |

The split that matters: an Active member can be made a coordinator and **edit** the event,
but cannot **complete** it, so cannot cause credit to be written. Only the Officer account
type can complete.

## Roster and member profiles

| Action | Where / operation | Gating privilege | Who holds it here |
|---|---|---|---|
| View the roster and other members' profiles | `brothers`, `viewmember` | `hideMembers` (type, inverted) | **every account type, including Prospect** (the one thing a Prospect can do) |
| View anyone's requirement progress | progress on profiles / records | `hideprogress` (type, inverted) | every account type except Prospect |
| Edit your own profile | `editprofile` → `updateprofile` | none needed; own record | everyone with a login |
| Edit **another** member's profile | Account Manager `panel=account` → `updateprofile` | `editprofile` (position) | the five |
| Add, approve, reject new users; change a member's account type or positions | `userspending` → `approveusers`; `managebrother panel=status`; `inviteuser`; `verifyRoster` | `approveusers` (position) | the five (they also get an e-mail each time someone registers) |
| Force a password reset for another member | `resetPassword` | `[inferred]` `approveusers` or `editprofile`; no grid row names it | not stated on a grid |
| View the alumni directory | alumni directory | `hideAlumniDirectory` (type, inverted) | every account type except Prospect |
| Add or remove a custom profile field for all members | `createuserfield` | `[inferred]` `config` | the five |
| Configure the site (settings, term dates, positions, privileges) | `setterm`, `editofficerpositions`, `editprivileges`, `editofficerprivileges`, `editstatus` | `config` (position, "Site Admin") | the five |

## Requirements and credit

| Action | Where / operation | Gating privilege | Who holds it here |
|---|---|---|---|
| See your own progress bars | home page | none; own record | everyone |
| Log credit for **yourself** on requirement X | "Add Record" on `viewrecords` → `addrecord` | `req<X>` (type, "Log their own: Internal X") | **Officer account type only** (14 of the 17 requirements). No other type may self-log; an officer must enter it. |
| Log or adjust credit for **another** member on requirement X, and edit requirement X | `managerecords`, `addrecord`/`deleterecord` for others, `editrequirement` → `updaterequirement` | `req<X>` (position, "Manage X Requirement") | per chair, plus the five (see the requirement map below) |
| Create a requirement or a point tracker | `createrequirement` / `createPointTracker` → `updaterequirement` | `[inferred]` `config`; creating one also creates a new `req<id>` privilege in both grids | the five |
| Delete a requirement | `removerequirement` | `[inferred]` `config` | the five |
| Award credit to every attendee at once | completing an event | `coorcomplete` (type) | Officer account type only |

Requirement map on this chapter (position privilege `req<id>`):

| Requirement | Positions that may manage it (plus the five) |
|---|---|
| Dues & Chapter Finances (`req1`) | Treasurer only |
| Meetings (`req2`) | Recording Secretary |
| Service Hours (`req3`) | Service VP, Philanthropy Chair, Public Relations Chair |
| Fellowship (`req865`) | Fellowship VP |
| Leadership (`req866`) | Leadership VP |
| Fundraising (`req867`) | Treasurer, Fundraising Chair |
| Interchapter (`req912`) | Interchapter Chair |
| Chair credit (`req925`) | Philanthropy Chair |
| Special Fellowship (`req937`) | Fellowship VP |
| Committee credit (`req944`) | 14 of 19 positions (used as a general "may grant credit") |
| Academic (`req1507`) | Leadership VP, Academic Chair |
| External Relations (`req1511`) | Public Relations Chair, Special Events Coordinator |
| Open Forum (`req1605`) | Leadership VP |
| Required Events (`req2130`) | none but the five |
| Philanthropy Hours (`req2164`) | Service VP, Philanthropy Chair |
| Dues (`req2234`), Philanthropy Credit (`req2236`), Training (`req2377`) | none but the five (Philanthropy Credit also Philanthropy Chair) |
| Other (non-associated) events (`otherevents`) | Pledge Trainer, Public Relations Chair |

## Money

| Action | Where / operation | Gating privilege | Who holds it here |
|---|---|---|---|
| See your own balance and dues due date | home page, own records | none; own record | everyone |
| View the budget and the transaction ledger | `managebudget`, `viewtransactions` | `viewbudget` (type) | **Officer account type only** |
| Log a payment, charge a fee, edit the Dues requirement, manage invoices and payment processors, allocate budgets | `managedues`, `viewtransactions` (Log Transaction), `editrequirement&reqid=1`, invoices, `managePaymentProcessors`, `managebudget` | `req1` (position, "Manage Dues Requirement **& Chapter Finances**") | **Treasurer** and the five |
| Manage fundraising funds and campaigns | `createFund`, campaigns | `fundraising` (position) | the five |
| Pay dues online (member) | checkout page, if enabled | none beyond being the member; feature toggle on the Dues requirement | unused on this chapter |

`req1` is the single gate on the whole money section. Only the Treasurer and the five hold it.

## Communication

| Action | Where / operation | Gating privilege | Who holds it here |
|---|---|---|---|
| Send bulk e-mail to a filtered audience | `defineEmailFilters` / `selectEmailAudience` → send | `bulkemail` (position; also a type privilege no type holds) | Treasurer, Recording Secretary, Leadership VP, Pledge Trainer, Interchapter Chair, the five |
| Send bulk SMS | `smsform` → send | `bulksms` (position; type privilege held by no type) | Treasurer, Pledge Trainer, the five |
| Post an announcement to every home page | announcements | `announcements` (position) | Treasurer, Recording Secretary, Leadership VP, Pledge Trainer, Interchapter Chair, the five |
| Send anonymous feedback to officers | `comment` → send | `commentform` (type) | **Bad Standing only** on this chapter (deliberately configured; no other type has it) |
| Message another member privately | `viewmessage` | `[inferred]` none beyond a login; no grid row | everyone with a login |
| Set your own notification preferences | `contactPreferences` | none; own record | everyone |

## Blog, photos, minutes, files

| Action | Where / operation | Gating privilege | Who holds it here |
|---|---|---|---|
| Write a blog post | `createblog` → `insertblog` | `postblog` (type) | Officer account type only |
| Approve or publish blog posts (and post as an officer) | blog admin | `approveposts` (position) | Recording Secretary, Leadership VP, Fellowship VP, Public Relations Chair, Fundraising Chair, the five |
| Delete a blog post | `deleteblog` | `[inferred]` `approveposts` | as above |
| Upload photos to an album | `addpictures` | `postimage` (type) | Officer, Active, PNM, Associate |
| Approve photos; manage albums | `managealbums`, `createAlbum` | `approveimages` (position); `managephotos` (type, held by no type) | Recording Secretary, Leadership VP, the five |
| View meeting minutes | minutes | `hideChapterMinutes` (type, inverted) | every account type except Prospect |
| Write or edit meeting minutes | minutes admin | `adminminutes` (position; type privilege held by no type) | Recording Secretary, Pledge Trainer, Fellowship VP, Public Relations Chair, the five |
| View chapter files | `viewstorage` | `hideChapterFiles` (type, inverted) | every account type except Prospect |
| Upload a file to the chapter file manager | `viewstorage` upload | `uploadfile` (type or position) | types: Officer, Active, Associate; positions: the five |
| Upload a file to your own attachments | Account Manager `panel=files` | none; own record | everyone |

## Lineage, awards, achievements

| Action | Where / operation | Gating privilege | Who holds it here |
|---|---|---|---|
| View the family tree / lineage | `familytree.php`, Line tab | `hidefamily` (type, inverted) | every account type except Prospect |
| Edit your **own** bigs, littles, line | `editfamilytree` → `addbig`, `addlittle`, `updatemyfamily` | `ownfamily` (type) | **Bad Standing only** on this chapter (an odd configuration; Officer and Active do not hold it) |
| Manage anyone's families / groups | `managefamilies` | `families` (position) | the five |
| Grant an award to a member, run award voting | `manageUserAwardRecords` → `addUserAwardRecord`; `manageballot` | `awards` (position) | the five |
| Define and grant achievements | `createchapterachievement` | `achievements` (position) | the five |
| Vote in an award ballot | ballot | `[observed]` eligibility is set per ballot by account type; not a grid privilege | whoever the ballot setup names |

## Forms, courses, and other admin tools

| Action | Where / operation | Gating privilege | Who holds it here |
|---|---|---|---|
| Create a form | `createform` | `createform` (position) | the five |
| Fill in a form | form page | `[observed]` audience is set per form by account type; not a grid privilege | whoever the form's audience names |
| Complete forms requested by national staff | staff forms | `submitform` (position) | the five |
| Manage courses, quizzes, grading | `manageCourses`, `createCourse` | `lms` (position) | the five |
| Take a course | course page | `[observed]` audience is set per course by account type | whoever the course's audience names |
| Manage the external website pages, links, header tabs, homepage image | `editchapterlinks`, `managetabs`, `edithomepageimage` | `webpages` (position) | the five |
| Manage external sales tools (companies, products, external invoices) | CRM, `myMembersExternalInvoices` | `crm` (position) | the five |
| Manage calls for applications | applications | `applications` (position) | the five |
| Read the access / audit log | `viewlog` | `[inferred]` `config` | the five |
| Run reports and export CSV | `createreport` | `[inferred]` `config` or any officer; not stated on a grid | not stated on a grid |

## What this view makes visible

- **Three actions are Officer-account-type only, and they are the ones that matter:**
  create an event, complete an event (which writes credit), and log your own credit. An
  ordinary Active member on this chapter can do none of them.
- **A Prospect can do exactly one thing: view the roster.** Everything else is denied.
- **Inactive, Leave of Absence and Deceased cannot sign up for events** (no `rsvpevent`);
  every other type can.
- **Two privileges are held only by Bad Standing** (`commentform`, `ownfamily`). That is
  almost certainly a configuration accident, and it is the kind of thing this per-feature
  view exposes and the grid view hides.
- **Money has one gate,** `req1`, held by the Treasurer and the five. **Users and settings
  have one gate,** `approveusers` / `config`, held by the five.
- **Several actions have no privilege row at all** (delete an event, force a password reset,
  read the audit log, run reports, delete a blog post). They are marked `[inferred]`. The
  product ties them to a broader privilege or to being the record's owner; a rebuild should
  give each one an explicit privilege rather than inherit the ambiguity.
- **Some privileges exist in the account-type grid but no type holds them** (`bulkemail`,
  `bulksms`, `managephotos`, `adminminutes`). On this chapter those abilities come only from
  a position.

`[design]` For the rebuild, this table is the checklist: every row is one server-side
permission check, and every "not stated on a grid" row is a privilege you should define
explicitly.
