# Feature inventory

> Summary: Everything APOonline does, with each feature marked build first, build later,
> or skip, for a single chapter.
> Status: OBSERVED (confirmed and corrected during the authenticated walkthrough)
> Read this if: you are deciding what to build.
> Depends on: docs/GLOSSARY.md

This lists everything APOonline does, and says which parts are worth building.

It began as a reading of APOonline's public features page. It has since been checked
against the real site with an admin account, page by page. The tags are unchanged unless
a note says otherwise; the notes now cite what was actually seen. Features the marketing
page never mentioned are listed in the last section.

APOonline serves many chapters, grouped into sections, regions, and a national office.
You are building for one chapter. That difference removes a large amount of work before
anyone writes a line of code, and it is the most useful decision on this page.

Each feature is tagged:

- **CORE.** Build this first. The system does not work without it.
- **LATER.** Useful, but the system works without it. Add it once the core runs.
- **SKIP.** APOonline has it. Your chapter probably does not need it, or it costs far
  more to build than it returns.

## Membership

| Feature | Tag | Notes |
|---|---|---|
| Member profiles with contact details | CORE | |
| Roster with account types | CORE | Confirmed. The chapter defines its own account types on top of six national statuses. This chapter added Bad Standing, Leave of Absence, Half-Active and System. |
| Status can differ each term | CORE | Still the right design, but the real site does NOT do this: it stores one account type per member, not one per term. Build it per term anyway; the history cannot be recovered later. |
| Alumni database | LATER | Almost no extra work once status is stored per term. An alumnus is a member whose latest status is "alumni". |
| Family tree (big/little) with leaderboard | LATER | A member record points at another member record. Small to build, and a good way to learn queries that follow a chain. |
| Chapter awards shown on profiles | LATER | |

## Requirements and credits

This is the most important section, and the part most worth thinking carefully about.

| Feature | Tag | Notes |
|---|---|---|
| Chapter sets its own requirements | CORE | Rules differ per chapter and change over time. Store them as rows in a table, not as numbers written into the code. |
| Requirements differ by account type | CORE | Confirmed exactly. Every requirement carries a target for each of the 14 account types, and a target of 0 hides the progress bar for that type. |
| Members earn credit toward requirements | CORE | Stored separately from attendance. See the note below the table. |
| Attending an event earns credit | CORE | Confirmed, with a step in between: an officer completes the event, and that is what writes the credits. |
| Officer can add or adjust credit by hand | CORE | Real chapters always have exceptions. Without a manual override, officers will keep a separate spreadsheet and stop using the system. |
| Page showing progress toward requirements | CORE | |
| CoE and PPoE progress reports | SKIP | These are national program reports with their own formats. Build the general progress page first. Add these only if your chapter actually submits them. |

**Attendance and credit are two different things.** Attendance records whether someone
showed up. Credit records what showing up earned them.

Storing them as one thing is the most common mistake in this kind of system. It breaks as
soon as someone volunteers outside a chapter event, or attends something that earns
nothing.

## Events and meetings

| Feature | Tag | Notes |
|---|---|---|
| Create and list events | CORE | |
| Signups, with a limit on how many can attend | CORE | |
| Take attendance at an event | CORE | |
| Meeting attendance and statistics | CORE | Settled: a meeting is requirement id 2, handled by the same screens as every other requirement. |
| Meeting minutes | LATER | Mostly a text field attached to a meeting. |
| Calendar view | LATER | A different way to display events. No new data to store. |
| Scheduled email reminders | LATER | The first feature that needs code running on a schedule rather than in response to a click. Good to build eventually, for that reason. |

## Permissions

| Feature | Tag | Notes |
|---|---|---|
| Chapter-configurable officer positions | CORE | |
| Granular per-function privileges | CORE | |
| Position holds privileges, member holds position, by term | CORE | Confirmed, with one correction: positions are not the only source. Account types carry privileges too. |

APOonline stores its permission rules as data. A chapter creates its own officer
positions, then checks off which permissions each position gets. Nobody edits code to add
an officer.

Writing the roles into the code would be faster to build. Do not do it. Chapters really
do have different officer structures, and this is the part of the system most worth
learning from.

## Finance

| Feature | Tag | Notes |
|---|---|---|
| Track who owes dues and who has paid | CORE | Tracking the money is core. Collecting it is not, see the next row. |
| Collecting dues online | SKIP | Taking card payments means a payment provider, security rules about card data, and handling refunds. That is a large project on its own. Record who paid instead, and collect the money however the chapter already does. |
| Record of all money in and out | LATER | |
| Budget per officer position, with remaining balance | LATER | A good exercise in summing rows and comparing to a limit, once the money records exist. |

## Communication and content

| Feature | Tag | Notes |
|---|---|---|
| Email a filtered group of members | LATER | The useful part is choosing who to send to. The sending itself is a small piece. |
| Email notifications | LATER | |
| Chapter blog | SKIP | Chapters that want one already have better tools for it. |
| Photo albums | SKIP | Needs file uploads, storage, image resizing, and moderation. Large, and it teaches little that the rest of the project does not. The vendor's own upload page has been switched off since "Summer 2025" and was still offline in August 2026 (`raw/pages/diamond-features-how-they-work.md`), which is its own argument. |
| Activity feed | SKIP | |
| Custom colors and themes | SKIP | |

## What to build first

Build only this, then stop and let real officers use it:

terms, members, membership by term, officer positions and privileges, events, attendance,
requirements, credits, and one page showing each member's progress.

That is enough for your chapter to run a full semester on. Everything else builds on top
of it, and everything marked LATER really can wait.


## Features the public page never mentioned

These were found during the walkthrough. Each cites the file that shows it.

| Feature | Tag | What it is | Evidence |
|---|---|---|---|
| Privileges per account type | CORE | A second permission grid, 40 privileges, deciding what an ordinary member may do. We had missed this entirely. | raw/pages/memberhome_action-editprivileges_statusid-2.md |
| Requirement categories | LATER | A requirement can be split into named parts, each with its own target. Service is split four ways here. | raw/pages/memberhome_action-editrequirement_reqid-3.md |
| Internal versus external credit, with a cap | CORE | Every credit is flagged as chapter-hosted or outside, and each target sets how much may come from outside. | raw/pages/memberhome_action-createrequirement.md |
| Percentage requirements | LATER | A requirement can be counted as a share instead of a total: "Percentage — Each member must attend X% of the total number of events of this type of event." | raw/pages/memberhome_action-createrequirement.md |
| Point trackers | SKIP | A requirement with no targets, used as a plain counter. Unused on this chapter. | raw/pages/memberhome_action-createPointTracker.md |
| The completion step | CORE | Credit is created when an officer completes an event, not when members sign up. | raw/pages/memberhome_action-pendingevents.md |
| Event coordinators, with a bonus | LATER | One or two members run an event and can be given extra units for doing so. | raw/pages/memberhome_action-eventcreate.md |
| Ride and driver matching | SKIP | Sign-ups can record that a member is driving and has open seats. | raw/pages/memberhome_action-viewlog.md |
| Event shifts | SKIP | An event can be split into shifts, with credit per shift or per event. | raw/pages/memberhome_action-eventcreate.md |
| Event groups | SKIP | A semester-long series counted as one event. | raw/pages/memberhome_action-eventcreate.md |
| Sign-up windows | LATER | Three separate moments: sign-ups open, lock and close. | raw/pages/memberhome_action-eventcreate.md |
| Attendee-list visibility | SKIP | Five settings, from always visible to always hidden. | raw/pages/memberhome_action-eventcreate.md |
| Approval queue for self-registration | CORE | A public registration link, with every new account held until an officer approves it. | raw/pages/memberhome_action-userspending.md |
| CSV import of members | LATER | Bulk-add a roster from a file. | raw/pages/memberhome_action-inviteuser.md |
| Access log | CORE | Every change recorded with actor, target and time. | raw/pages/memberhome_action-viewlog.md |
| Notifications | LATER | Members are told in the app when they were credited. | raw/pages/memberhome_action-viewnotifications.md |
| Per-field profile visibility | SKIP | Each profile field has its own audience. | raw/pages/memberhome_action-managebrother_panel-account.md |
| Chapter-defined profile fields | SKIP | "Add a new field to all profiles". | raw/pages/memberhome_misc-surfaces.md |
| Achievements | LATER | Badges awarded automatically at a unit threshold, or by hand. | raw/pages/memberhome_action-createchapterachievement.md |
| Award voting | SKIP | A ballot per award, with eligible account types and write-ins. | raw/pages/memberhome_misc-surfaces.md |
| Leaderboards | LATER | Top members per requirement, for the chapter, region or nation, and separately for pledge classes. Three rules stated on the page: Inactive, Alumni, Honorary and Advisor members are not eligible; only **internal** credit counts; and the default window is the current term. | raw/pages/full-read-pass-2.md |
| Transaction ledger and invoices | LATER | A real money ledger with export, plus invoices and payment processors. | raw/pages/memberhome_action-viewtransactions.md |
| Budget per officer position | LATER | An allocated amount per office, measured against the ledger. | raw/pages/memberhome_action-managebudget.md |
| Reports with CSV export | CORE | Pick fields, requirements, account types and dates; view or download. | raw/pages/memberhome_action-createreport.md |
| Comment form | SKIP | Anonymous feedback to officers, visible for 30 days. | raw/pages/memberhome_misc-surfaces.md |
| Courses and quizzes | SKIP | Modules in fixed or any order, a repeat policy (once per semester / academic year / calendar year / ever / unlimited), an audience filter, and a downloadable certificate on completion. | raw/pages/completeness-pass.md |
| Forms | SKIP | A real form builder: 13 question types (text, paragraph, date, phone, e-mail, address, multiple choice, linear scale, checkboxes, single member, multiple members, file upload, and "Member Field to Update"), an open and close window, a due date, and an anonymous mode. The last question type writes the answer back into the member's profile. | raw/pages/completeness-pass.md |
| Alumni employment directory | LATER | Search alumni by industry, employer or location. | raw/pages/memberhome_misc-surfaces.md |
| Job board | SKIP | Alumni post jobs. | raw/pages/memberhome.md |
| Announcements | LATER | Messages pinned to every member's home page. | raw/pages/memberhome_misc-surfaces.md |
| Public website builder | SKIP | Custom pages, colours, header tabs, blog and albums for a public site. | raw/pages/memberhome_misc-surfaces.md |

## Features visible only in the release notes

`?action=whatsNew` names features that no navigation entry on this chapter exposes. Some
are gated by the vendor's plan, some belong to the honor-society product line, and some
are simply not used here. All from `raw/pages/memberhome_action-whatsNew.md`.

| Feature | Tag | Note |
|---|---|---|
| Conference Manager: ticketed conferences | SKIP | A whole subsystem, not a small feature. Ticket options with prices, free ticket options, a unique set of form questions per ticket which are merged into one form at registration, one person registering several attendees and paying in a single transaction, and a customisable confirmation message. No navigation entry exposes it on this chapter. |
| A store with products, orders and shipping | SKIP | Products can be attached to invoices; orders can be marked shipped. |
| Invoice templates, payment plans, invoice merging, shareable invoice links | SKIP | Four years of accumulated payment machinery. The argument for not taking money. |
| ACH bank transfer, and Stripe payout reconciliation | SKIP | "ACH payments can take up to five days to complete." |
| General Ledger Accounts on invoice line items | SKIP | Real accounting, added for headquarters sites in 2018. |
| Data/Email Automation on a trigger | SKIP | Send on a birthday, or after a form is submitted. Needs a scheduler and a rules engine. |
| Saved Audiences and filtering e-mail on any member field | LATER | The genuinely useful half of bulk e-mail. |
| Scheduling a bulk e-mail to send later | LATER | A second background job, alongside reminders. |
| Sign in with Google or Facebook | LATER | Connect and disconnect are managed by the member. See the auth document. |
| Anonymous forms with one submission per person | SKIP | Anonymous and exactly-once at the same time is a genuinely hard pair to satisfy. |
| Form submissions assigned to an officer and marked complete | SKIP | Turns a form into a work queue. |
| Search that spans the whole member database, own chapter first | SKIP | Only meaningful across chapters. |
| Invoice templates per semester or quarter system | SKIP | |
| Image carousel component for the public site | SKIP | |
| Merge tags in e-mail (`{{first-name}}`) | LATER | Cheap once e-mail exists. |
| E-mail queue status codes, and open tracking | LATER | Rent this; do not build it. |
| Per-affiliation e-mail opt-out | LATER | Only meaningful if a member belongs to more than one group. |
| LMS courses with assessments and passing grades | SKIP | Chapters may author their own courses. |
| File manager with folders, sharable links and a public files tab | LATER | Needs object storage and per-file access control. |
| Personal Family with custom relationships (cousin, grandparent) | SKIP | Separate from the big/little Line structure. |
| Stage forms that auto-generate an invoice on a membership transition | SKIP | Membership Stages were added in 2018 for headquarters sites. |
| Bulk import of prospects and of donations by CSV | LATER | |
| Automatic setting of pledge class and graduation class on transition | LATER | A nice touch worth copying when you build transitions. |

## What the walkthrough changed about the original tags

- **"Meeting attendance and statistics" was tagged CORE with a note to check whether a
  meeting is just an event.** It is. Meeting is requirement id 2, handled by the same
  screens as every other requirement.
  (raw/pages/memberhome_action-managerequirements.md)
- **"Collecting dues online" stays SKIP,** and the walkthrough strengthens the case: the
  real product needs a Stripe connection, custom checkout pages, and a fee of
  "3.9% + $0.30". (raw/pages/memberhome_misc-surfaces.md)
- **"Family tree (big/little) with leaderboard" stays LATER.** The site calls a family a
  "Line", and this chapter has not created any: 72 members sit in a group called
  "No line listed". A feature the real chapter does not use is not a feature to build
  first. (raw/pages/memberhome_action-managefamilies.md)
- **"CoE and PPoE progress reports" stays SKIP** and is confirmed to exist: the chapter
  page has panels headed "CHAPTER OF EXCELLENCE PROGRESS" and "PLEDGE PROGRAM OF
  EXCELLENCE PROGRESS". (raw/pages/memberhome_action-viewchapter_id-311.md)
- **Photo albums, blog and custom themes stay SKIP,** and are in fact sold as an upsell:
  the vendor gates document storage and mobile check-in behind a more expensive plan.
  (raw/pages/memberhome_action-billingoverview.md)

## What the vendor charges extra for

The three subscription tiers gate nine features. Everything else is in all three.
(`raw/pages/memberhome_action-viewstorage_tier-chart.md`)

| Feature | BLUE $3 | GOLD $4 | DIAMOND $5 |
|---|---|---|---|
| Website Homepage, Photo Albums, Chapter Blog, Custom Themes | no | yes | yes |
| SMS Texting, Document Storage, Event File Attachments, Event Mobile Check-In, Fundraising Campaigns | no | no | yes |

This is a useful sanity check on our own tags: every one of those nine is already tagged
SKIP or LATER here, and the vendor charges extra for them because they are the expensive
ones to run. The 22 "Basic Features" in every tier are, near enough, the CORE list.

Note that this is a **billing** boundary, not a product one. Ignore it when deciding what
to build; it is only interesting as a second opinion on what is cheap and what is not.

The chapter upgraded to DIAMOND on 2026-08-29 and all nine were captured
(`raw/pages/diamond-tier-sweep.md`). The upgrade changed no navigation entry and added no
form field: the gate is on page access, not on the software. Every one of the nine keeps
its SKIP or LATER tag.

## Features and data-changes found in the flow and route sweeps (2026-08-29/30)

Two ideas drive this section. First, tracing the flows and sweeping the routes turned up
features the tables above did not name. Second, **every data change is a feature.** The
complete list of data-changing operations is `docs/03-api/write-operations.md` (about 50
operations); treat each entry there as one feature for the eventual full analysis. The rows
below are the features from this session's work that were not already listed above.

| Feature | Tag | What it is | Evidence |
|---|---|---|---|
| Notification preferences | LATER | Per-member e-mail routing, per-activity toggles (weekly digest, event-reminder lead time, hours reported, private message, waitlist promotion, account-type change), and a source x channel (National/Region/Chapter x Email/Call/Text/Mail) consent matrix. | raw/pages/unread-routes-sweep.md |
| Event waitlist | LATER | When a capacity-limited event is full, further sign-ups go on a waitlist; a member is notified when promoted off it. | raw/pages/unread-routes-sweep.md |
| Activity timeline with manual logging | LATER | A per-member activity log (award received, achievement unlocked, elected to office, membership-status change); entries can be added by hand ("Log Activity"). This is where account-type history is stored, and it is not walked back when a source record is deleted. | raw/pages/gap-resolution-2.md |
| Member file attachments | LATER | A per-member file store with folders, a sharing scope per file, and external-link entries. Distinct from photo albums. | raw/pages/self-flows-observed.md |
| Education & work history on profiles | SKIP | Per-member alumni-networking child records, linked to institution and employer + industry lookups. | raw/pages/self-flows-observed.md |
| Member-to-member messaging | SKIP | Private direct-message threads between two members. | raw/pages/unread-routes-sweep.md |
| Direct award grant | LATER | An officer grants an award to a member directly (`addUserAwardRecord`), separate from the award ballot. Removing it (`deleteUserAwardRecord`) leaves the timeline entry behind. | raw/pages/self-flows-observed.md |
| Dues split, late fee, online payment | SKIP | The Dues requirement carries a Chapter/Region/National split, a due date and time, an automatic late fee toggle, and an accept-online-payments toggle. This chapter has never used the late fee or online payment. | raw/pages/unread-routes-sweep.md |
| Invoice status lifecycle | LATER | A per-member invoice moves through Open, Pending, Paid, Void. | raw/pages/self-flows-observed.md |
| External member invoices | SKIP | `?action=myMembersExternalInvoices` (not read; an external-invoice feature, finance/alumni scope). | not read; docs/INVENTORY.md |
| SMS management / history | SKIP | `?action=manageSms` (not read). SMS texting is a DIAMOND-tier feature; a filtered send form (`smsform`, 128-char) was read. | not read; raw/pages/unread-routes-sweep.md |
| Chapter achievements view | LATER | `?action=viewchapterachievements` (not read; empty here, this chapter defines no achievements). Achievements themselves are already listed. | not read |
| Photo album management | SKIP | `?action=managealbums` (not read). Photo albums are already listed SKIP; the vendor's image upload is switched off. | not read |
| Chair position / title | LATER | An optional free-text chair title on a member (`chairTitle`), separate from officer positions. | raw/pages/managebrother-all-panels.md |
| LEADS networking | SKIP | Alumni networking built on the profile, education and work-history data. | raw/pages/custom-fields-and-leads.md |
| Password: self-change, forgot, admin reset | CORE | Three password entry points: member self-change (needs current password), forgot-password (e-mail a reset), and officer-forced reset. No MFA exists. | raw/pages/award-and-password-flows.md |
| Membership stages and bulk "Graduate Members" | LATER | Four stages (Prospect, PNM, Member, Alumni) each holding a set of account types; tick members and press "Graduate Members" to move them to the next stage (assigns Alum). The transition tool, as opposed to the one-at-a-time status override. | raw/pages/memberhome_action-viewMembershipStages.md |
| Configurable term calendar | CORE | The chapter sets semester or quarter, and a recurring month/day for each term start (`setterm` → `updateterm`). This defines "this term" for every progress bar and report window. | raw/pages/memberhome_action-setterm.md |
| Chapter settings and profile | CORE | Timezone, chapter name/info, and the other site-wide settings behind the `config` privilege. Small, but every install needs it. | raw/pages/memberhome_action-managemenu.md |
| Roster verification / correction | LATER | `verifyRoster`: an audit page that confirms or corrects every member's account type and positions in one submit, sending the previous values so two officers do not overwrite each other. For corrections, not transitions. | raw/pages/newly-found-verbs.md |

The four routes still unread (`myMembersExternalInvoices`, `managealbums`, `manageSms`,
`viewchapterachievements`) are recorded above as features by what they are; their exact
field lists are the only thing not captured, and each is low value or empty on this chapter.
When they are read, add their fields to `docs/03-api/write-operations.md` and the data model.

## A note on how big this product is

The two privilege lists together hold 79 rows: 40 in the account-type grid and 39 in the
officer-position grid. Some field names appear in both grids and mean different things
there, so 79 is a count of rows, not of distinct abilities. That is a fair measure of the
product's size, because every one of them has to be checked somewhere in its code.

The recommendation in this document has not changed: build terms, members, membership by
term, account types and positions with their privileges, events, attendance, requirements,
credits, and one progress page. That is about a fifth of what is listed above, and it is
enough to run a semester on.
