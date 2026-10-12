# Evidence map

> Summary: Every entity and every non-obvious claim in this documentation, next to the raw
> file that backs it and a confidence rating.
> Status: REFERENCE
> Read this if: you want to check a claim without reading the whole capture set.

Every row is a claim and its evidence. If a claim in the documentation has no row here, it
is not finished. If a row cites a file that does not contain the claim, the claim is wrong.

All paths are relative to the repository root. Every raw file was written during the
walkthrough on 2026-08-28.

## Entities

| Entity | Type | Evidence | Confidence |
|---|---|---|---|
| Chapter (a "group", with a type and a region) | entity | raw/pages/memberhome_action-viewchapter_id-311.md | high |
| Chapter attributes stored as numbered fields | field storage | raw/pages/memberhome_action-editchapterinfo.md | medium-high (inferred from `chapterinfo[1..21]`) |
| Term, defined by a recurring month and day | entity | raw/pages/memberhome_action-setterm.md | high |
| Term window used by every progress screen | behaviour | raw/pages/memberhome_action-managerecords_reqid-3.md, raw/pages/memberhome_action-managemenu.md | high (two independent screens agree) |
| Member, with the field list | entity | raw/pages/memberhome_action-managebrother_panel-account.md | high |
| Member exists across chapters | relationship | raw/pages/memberhome_action-inviteuser.md | high (page text: "may already be in the system") |
| Member number is per chapter | field | raw/pages/memberhome_action-managebrother_panel-account.md (`chapternumber[311]`) | high |
| Custom profile fields | field storage | raw/pages/memberhome_action-managebrother_panel-account.md (`profile[473]`), raw/pages/memberhome_misc-surfaces.md ("Add a new field to all profiles") | high |
| Account type, chapter-defined | entity | raw/pages/memberhome_action-managestatuses.md | high |
| Account type maps to a national membership status | relationship | raw/pages/memberhome_action-editstatus_statusid-111.md | high |
| The six national membership statuses | enum | raw/pages/memberhome_action-editstatus_statusid-111.md | high |
| The 14 account types on this chapter, with ids | enum | raw/pages/memberhome_action-managestatuses.md, raw/pages/memberhome_action-createrequirement.md | high (two files agree on the mapping) |
| The four membership stages | enum | raw/pages/memberhome_action-viewMembershipStages.md | high |
| Officer position, chapter-defined | entity | raw/pages/memberhome_action-editofficerpositions.md | high |
| Position can be officer, advisor or both | field | raw/pages/memberhome_action-editofficerpositions.md (`officerOrAdvisor`) | high |
| A position can be held by more than one member | cardinality | raw/pages/memberhome_action-brothers.md, raw/pages/memberhome_action-viewchapter_id-311.md | high (two files, three duplicated positions) |
| A member can hold more than one position | cardinality | raw/pages/memberhome_action-brothers.md | high |
| Privilege, with two grids | entity | raw/pages/memberhome_action-editofficerprivileges_officerid-2892.md, raw/pages/memberhome_action-editprivileges_statusid-2.md | high |
| Requirement, chapter-defined, no term | entity | raw/pages/memberhome_action-createrequirement.md | high (no term field on the form) |
| Requirement is the same record as an event type | equivalence | raw/pages/memberhome_action-managerequirements.md, raw/pages/memberhome_action-managemenu.md | high (page heading plus the shared id) |
| Requirement category | entity | raw/pages/memberhome_action-editrequirement_reqid-3.md, raw/pages/memberhome_action-eventcreate.md (`3-1` to `3-4`) | high |
| Requirement goal, per account type, two numbers | entity | raw/pages/memberhome_action-createrequirement.md | high |
| Goals can be fractional | field type | raw/pages/memberhome_action-editrequirement_reqid-3.md (7.5) | high |
| Point tracker is a requirement with a flag | entity | raw/pages/memberhome_action-createPointTracker.md | medium-high (same field names, hidden `isPointTracker`) |
| Event, with the field list | entity | raw/pages/memberhome_action-eventcreate.md | high |
| Event credit rule, repeating | entity | raw/pages/memberhome_action-eventcreate.md, raw/pages/memberhome_action-viewevents.md | high |
| One event can award several credits | cardinality | raw/pages/memberhome_action-viewevents.md, raw/pages/memberhome_action-viewnotifications.md, raw/pages/memberhome_action-managemenu.md | high (three independent files) |
| A repeating event is several event records | behaviour | raw/pages/memberhome_action-viewlog.md | high (five ids, one second apart) |
| Sign-up is its own row, created and deleted | entity | raw/pages/memberhome_action-viewlog.md | high |
| A sign-up can record a driver and open seats | field | raw/pages/memberhome_action-viewlog.md, raw/pages/memberhome_action-eventcreate.md | high |
| Requirement credit, with its field list | entity | raw/pages/memberhome_action-viewrecords_reqid-3.md | high |
| A credit can exist with no event | relationship | raw/pages/memberhome_action-viewrecords_reqid-3.md (the form sends no event id) | high |
| Credit carries an internal-or-external flag | field | raw/pages/memberhome_action-viewrecords_reqid-3.md | high |
| Credit is created by completing an event | behaviour | raw/pages/memberhome_action-pendingevents.md | high (the page states it) |
| Transactions, invoices, budgets | entity | raw/pages/memberhome_action-viewtransactions.md, raw/pages/memberhome_action-managedues.md, raw/pages/memberhome_action-managebudget.md | high |
| Achievement, automatic or manual | entity | raw/pages/memberhome_action-createchapterachievement.md | high |
| Award, with a ballot | entity | raw/pages/memberhome_action-manageUserAwards.md, raw/pages/memberhome_misc-surfaces.md | high |
| Line (family), optional | entity | raw/pages/memberhome_action-managefamilies.md, raw/pages/memberhome_misc-surfaces.md | high |
| Audit log, with actor, target and time | entity | raw/pages/memberhome_action-viewlog.md | high |

## Non-obvious claims

| Claim | Where it is made | Evidence | Confidence |
|---|---|---|---|
| The site is server-rendered PHP with one controller and an `action` verb | docs/INVENTORY.md | every raw file; every URL is `memberhome.php?action=` | high |
| There is no JSON API and no XHR worth reading | docs/INVENTORY.md | no capture found one; every page was read as HTML | medium-high (absence of evidence, over 40 pages) |
| Permissions come from two places, not one | docs/04-system-design/02-auth-and-permissions.md | the two privilege files | high |
| Requirement privileges are generated per requirement | docs/04-system-design/02-auth-and-permissions.md | `priv[req865]` in both grids matches reqid 865 in the nav and the requirement list | high |
| Eight privileges are stored inverted | docs/04-system-design/02-auth-and-permissions.md | raw/pages/memberhome_action-editprivileges_statusid-2.md, which records which radio value sits in the Allow column | high |
| "Admin" is the `priv[config]` privilege on a position | docs/04-system-design/02-auth-and-permissions.md | raw/pages/memberhome_action-editofficerprivileges_officerid-2892.md | high |
| Taking or leaving an office changes a member's account type | docs/04-system-design/02-auth-and-permissions.md | raw/pages/memberhome_action-defineofficers.md (page text, plus the two omitted options) | high |
| Requirements do not belong to a term | docs/02-data-model/02-questions-answered.md | raw/pages/memberhome_action-createrequirement.md (no term field) | high |
| Progress is computed on demand, not stored | docs/02-data-model/02-questions-answered.md | the arbitrary date ranges on raw/pages/memberhome_action-managerecords_reqid-3.md and raw/pages/memberhome_action-viewrecords_reqid-3.md | medium-high (inferred) |
| The site has no separate attendance record | docs/02-data-model/01-how-the-vendor-differs.md | raw/pages/memberhome_action-eventsignup_eventid-1152799.md, raw/pages/memberhome_misc-surfaces.md | medium (inferred from absence) |
| Account type is stored once, not per term | docs/02-data-model/00-domain-model.md | raw/pages/memberhome_action-brothers.md (roster groups by current type only); no screen showed a history | medium (inferred from absence) |
| Some GET links perform writes | docs/03-api/write-operations.md | raw/pages/memberhome.md (`setnotifyupcomingeventsflag&notify=1`), raw/pages/memberhome_action-managestatuses.md, raw/pages/memberhome_action-managerequirements.md | high |
| Attributes are stored as numbered rows (an EAV design) | docs/02-data-model/01-how-the-vendor-differs.md | `profile[473]`, `profile[visibility][473]`, `chapterinfo[1..21]`, "Add a new field to all profiles" | high (inferred, four separate signs) |
| Chapters, sections and regions are one kind of record | docs/02-data-model/00-domain-model.md | raw/pages/memberhome_action-viewchapter_id-311.md ("Group Type: Chapter"), the site map's section and region paths | medium-high |
| Some features are gated by the vendor's paid plan | docs/05-rebuild-plan/00-feature-inventory.md | raw/pages/memberhome_action-billingoverview.md | high |
| The chapter has 589 member records and 66 current members | docs/02-data-model/00-domain-model.md, page write-ups | raw/pages/memberhome_action-editstatus_statusid-111.md (589 checkboxes), raw/pages/memberhome_action-managemenu.md (66) | high |
| No approval step exists for credits | docs/04-system-design/03-flows.md | no capture showed one across the record, dashboard and notification screens | medium (absence of evidence) |
| The platform has a scheduler for reminders and automation | docs/04-system-design/05-feature-infrastructure.md | raw/pages/memberhome_action-whatsNew.md ("Data/Email Automation", "reminder emails will be auto-rescheduled"), raw/pages/memberhome_misc-surfaces.md (twelve reminder offsets) | high |
| E-mail sending has a queue, tracking and per-scope unsubscribe | docs/04-system-design/05-feature-infrastructure.md | raw/pages/memberhome_action-whatsNew.md | high |
| Payments run through Stripe with ACH, payment plans and reconciliation | docs/04-system-design/05-feature-infrastructure.md | raw/pages/memberhome_action-whatsNew.md, raw/pages/memberhome_misc-surfaces.md | high |
| Files are records with an owner and a visibility, not paths | docs/04-system-design/05-feature-infrastructure.md | raw/pages/memberhome_action-whatsNew.md (sharable links, public files tab), raw/pages/memberhome_action-viewlog.md (Media ids) | medium-high (inferred) |
| Nine features are gated by the vendor's paid tier, and which tier has which | docs/05-rebuild-plan/00-feature-inventory.md | raw/pages/memberhome_action-viewstorage_tier-chart.md | high (read from the tick pattern per column) |
| The product's release history runs from September 2018 to June 2026 | docs/04-system-design/05-feature-infrastructure.md | raw/pages/memberhome_action-whatsNew.md | high |
| Files carry one of three audiences, and a "file" may be an external link | docs/04-system-design/05-feature-infrastructure.md | raw/pages/diamond-tier-sweep.md | high |
| Photo albums need officer approval before publication | docs/04-system-design/05-feature-infrastructure.md | raw/pages/diamond-tier-sweep.md | high |
| SMS messages are capped at 128 characters | docs/04-system-design/05-feature-infrastructure.md | raw/pages/diamond-tier-sweep.md | high |
| E-mail and SMS share one audience model: a core filter plus account types | docs/04-system-design/05-feature-infrastructure.md | raw/pages/diamond-tier-sweep.md, raw/pages/memberhome_misc-surfaces.md | high |
| Fundraising is funds (destinations) and campaigns (channels), with offline logging | docs/04-system-design/05-feature-infrastructure.md | raw/pages/diamond-tier-sweep.md | high |
| The subscription tier gates page access, not code | docs/04-system-design/05-feature-infrastructure.md, docs/05-rebuild-plan/00-feature-inventory.md | raw/pages/diamond-tier-sweep.md compared against raw/pages/memberhome_action-eventcreate.md | high (same 58 field names before and after the upgrade) |
| A blog post has a publish date and a public/members-only visibility | docs/04-system-design/05-feature-infrastructure.md | raw/pages/diamond-features-how-they-work.md | high |
| The public blog shows nothing while the admin list shows a stored entry | docs/04-system-design/05-feature-infrastructure.md | raw/pages/diamond-features-how-they-work.md | high (both pages read in the same session) |
| Event attachments are deleted after six months | docs/04-system-design/05-feature-infrastructure.md | raw/pages/diamond-features-how-they-work.md | high (the page states it) |
| A sign-up carries a free-text comment | docs/02-data-model/00-domain-model.md | raw/pages/diamond-features-how-they-work.md (attendee table headers) | high |
| A fund can double-write a donation into the transaction ledger | docs/04-system-design/05-feature-infrastructure.md | raw/pages/diamond-features-how-they-work.md | high |
| Photo album image upload has been offline since "Summer 2025" | docs/04-system-design/05-feature-infrastructure.md, docs/05-rebuild-plan/00-feature-inventory.md | raw/pages/diamond-features-how-they-work.md | high |
| An unknown `action` renders the home page rather than a 404 | docs/04-system-design/05-feature-infrastructure.md | raw/pages/diamond-features-how-they-work.md (two different unknown verbs) | high |
| Public header tabs are four slots from six fixed choices | docs/04-system-design/05-feature-infrastructure.md | raw/pages/diamond-features-how-they-work.md | high |
| Profile fields are versioned, with a "clear your profile history" action | docs/02-data-model/00-domain-model.md | raw/pages/completeness-pass.md, raw/pages/memberhome_action-viewlog.md | high |
| A member has affiliations, one marked primary | docs/02-data-model/00-domain-model.md | raw/pages/completeness-pass.md | high |
| There are five per-field visibility levels, not three | docs/02-data-model/01-how-the-vendor-differs.md | raw/pages/completeness-pass.md (corrects raw/pages/memberhome_action-managebrother_panel-account.md) | high |
| A form question can write back into a member profile field | docs/04-system-design/05-feature-infrastructure.md | raw/pages/completeness-pass.md (`userField=Member Field to Update`) | high |
| Transactions can carry an attached receipt file | docs/04-system-design/05-feature-infrastructure.md | raw/pages/completeness-pass.md (`file[]` on the Log Transaction form) | high |
| An event may have no requirement attached ("Other Events") | docs/02-data-model/00-domain-model.md | raw/pages/completeness-pass.md (calendar filter), raw/pages/memberhome_action-editofficerprivileges_officerid-2892.md (`priv[otherevents]`) | high |
| Blog visibility and publish date cannot be changed after creation | docs/04-system-design/05-feature-infrastructure.md | raw/pages/completeness-pass.md | high (the edit form lacks both fields) |
| Accounts can sign in with Google or Facebook as well as a password | docs/04-system-design/02-auth-and-permissions.md | raw/pages/whatsNew-full-read.md (live page plus release notes) | high |
| A Conference Manager exists with ticket options and per-ticket questions | docs/05-rebuild-plan/00-feature-inventory.md | raw/pages/whatsNew-full-read.md | high (release notes only; no UI entry on this chapter) |
| Bulk e-mail can be scheduled to send later | docs/04-system-design/05-feature-infrastructure.md | raw/pages/whatsNew-full-read.md | high |
| A seventh membership status, "Guest", was added in 2020 | docs/02-data-model/00-domain-model.md | raw/pages/whatsNew-full-read.md; NOT present in the live dropdown, which shows six | medium (conflicting evidence, recorded in GAPS) |
| An event with a capacity limit keeps a waitlist | docs/02-data-model/00-domain-model.md | raw/pages/partials-closed.md (`notify[waitlist]`, "when I am promoted from a waitlist") | medium-high (inferred from the notification plus `maxattendees`; no waitlist screen was seen) |
| Employers are records, not free text | docs/02-data-model/00-domain-model.md | raw/pages/partials-closed.md (`companyId`/`companyName` hidden fields) | high |
| Processor fees are excluded from ledger balances | docs/04-system-design/05-feature-infrastructure.md | raw/pages/partials-closed.md | high (the page states it) |
| The complete officer position id map, including advisor 6144 | raw evidence only | raw/pages/partials-closed.md; 6144 matches the dashboard's `filter=officer\|6144` | high |
| A member can have several bigs and several littles | docs/02-data-model/00-domain-model.md | raw/pages/managebrother-all-panels.md (the page states it; separate add-one forms) | high |
| "Personal Family" records non-member relatives, separate from Lines | docs/02-data-model/00-domain-model.md | raw/pages/managebrother-all-panels.md | high |
| Removing a member from a chapter leaves their account alive elsewhere | docs/02-data-model/00-domain-model.md | raw/pages/managebrother-all-panels.md (the page states it) | high |
| A manual account-type change records a reason and can notify the member | docs/02-data-model/00-domain-model.md | raw/pages/managebrother-all-panels.md (`reasons[N]`, `notify[N]`) | high |
| Every bulk e-mail and SMS is logged per recipient | docs/04-system-design/05-feature-infrastructure.md | raw/pages/managebrother-all-panels.md (Engagement panel) | high |
| The chapter's nav-menu links are edited at ?action=editchapterlinks | docs/01-pages/00-index.md | raw/pages/newly-found-verbs.md | high |
| Five Distinguished Service Key awards are built into the product | docs/05-rebuild-plan/00-feature-inventory.md | raw/pages/newly-found-verbs.md | high |
| Custom profile fields have 9 types, 8 visibility levels and a uniqueness rule | docs/02-data-model/01-how-the-vendor-differs.md | raw/pages/custom-fields-and-leads.md | high |
| The complete allowed-privilege set for all 19 positions and 14 account types | docs/04-system-design/02-auth-and-permissions.md | raw/pages/permission-matrix-complete.md | high |
| There is no JSON API, no XHR and no client-side state | docs/INVENTORY.md | network read: 42 requests, all documents, assets or the extension; no data-* attributes; no app JS globals | high |
| "Line", "Big" and "Little" are chapter-configured labels, not product terms | docs/02-data-model/00-domain-model.md, docs/02-data-model/01-how-the-vendor-differs.md | raw/pages/full-read-findings.md (`langfamilysingular="line"`, `familylabel=custom`) | high |
| Registration approval offers Skip, Reject or an account type, and applicants state a requested status | docs/04-system-design/03-flows.md | raw/pages/full-read-findings.md | high |
| A member-award record stores who granted it | docs/05-rebuild-plan/00-feature-inventory.md | raw/pages/full-read-findings.md (award report has an "Awarded By" column absent from the grant form) | high |
| An event with zero attendees can still be completed | docs/04-system-design/03-flows.md | raw/pages/full-read-findings.md | high |
| Chapter awards (incl. trophies and press) are separate from member awards | docs/02-data-model/00-domain-model.md | raw/pages/full-read-findings.md | high |
| Leaderboards are scoped by requirement, internal/external, and term/lifetime | docs/05-rebuild-plan/00-feature-inventory.md | raw/pages/full-read-findings.md ("Internal Lifetime Meetings") | high |
| The family listing hides alumni and inactive members by default | docs/02-data-model/00-domain-model.md | raw/pages/full-read-findings.md | high |
| System account types cannot be renamed, remapped or deleted | docs/02-data-model/00-domain-model.md | raw/pages/full-read-pass-2.md (disabled `name`, absent `memberStatusId`, no delete link) | high |
| Leaderboards exclude Inactive, Alumni, Honorary and Advisor, and count internal credit only | docs/05-rebuild-plan/00-feature-inventory.md | raw/pages/full-read-pass-2.md | high |
| The external cap is applied at display time; the uncapped total is stored | docs/02-data-model/proposed-schema.sql | raw/pages/full-read-pass-2.md (report footnote) | high |
| Activation e-mail goes only to members who have not activated | docs/03-api/write-operations.md | raw/pages/full-read-pass-2.md | high |
| Siblings are derived from shared bigs, not entered | docs/02-data-model/00-domain-model.md | raw/pages/full-read-pass-2.md (profile shows Siblings; no form creates one) | high |
| The upcoming-events list is future-only; the e-mail audience list is all-time | docs/04-system-design/05-feature-infrastructure.md | raw/pages/full-read-pass-2.md | high |
| A sign-up carries a member-entered comment, used in practice | docs/02-data-model/00-domain-model.md | raw/pages/full-read-pass-2.md | high |
| The server enforces the privilege model | not claimed anywhere | none. An admin session cannot test it. | recorded as unverified in docs/GAPS.md |
