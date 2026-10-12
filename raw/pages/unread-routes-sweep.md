# Unread-routes sweep (2026-08-29)

> Capture pass. Reading the routes that were captured in structure but never read in full,
> looking for new entities and hidden rules. Reading only; structure only, no member data.

## Courses (`createCourse` / `manageCourses`) — new entity, LMS-style

`manageCourses` is empty on this chapter (no courses) with a "Create Course" link.
The create form (`action=createCourse`, POST) fields:

- `courseTitle` (text), `courseDescription` (text)
- `showSetting` (radio: "show immediately" | "hide until <date>"), `dateToShow` (date)
- `forceOrder` (radio: modules completed "in sequential order" | "in any order")
- `limitSessions` (radio, completion frequency, same 5-value enum as requirements:
  only once per semester | per academic year | per calendar year | ever | unlimited any time)
- audience: `scope` (radio), `memberStatusId[]` (checkboxes), `officerFilter` (radio),
  `accountTypeIds[]` (checkboxes over all 14 account types) — who can see the course
- a certificate can be attached ("Attach a certificate ... for members to download/print
  after completion", "+ create certificate")

So a **Course** has: title, description, publish/visibility, module ordering, a completion
frequency, an audience filter (by membership status and/or account type), and an optional
downloadable **certificate**. **Modules** are child records added after the course is
created (the form sets only their ordering rule, not their content). This is a small
learning-management feature. `[design]` For a single chapter this is LATER/optional.

Possible lead on the "Guest" gap: the audience labels here included "Guest" among status
names. Weak (could be a stray label); noted for follow-up, not resolved.

## Forms builder (`createform`) — Google-Forms-style, confirms member-field write-back

Fully read. A **Form** has: an optional header image (1000x150), a rich-text description
(TinyMCE), a target audience (account-type filter, 14 types), and scheduling:
- Availability: "completed multiple times, always available" OR "completed once, due on
  <date>".
- Hide Form Until: immediately | hide until <date> (12:00am chapter local time).
- Hide Form After: don't auto-hide (accept late if due date) | hide after <date> (11:59pm).
- **Anonymous?**: No (auto-record submitter name + affiliation) | Yes (don't record it).
  This is the "anonymous forms" feature from the release notes.

**Questions** (child records) have supporting text, a required flag, and an Answer Format
from this enum (13 types):
Text, Paragraph, Date, Phone Number, E-Mail Address, Mailing Address, Multiple Choice,
Linear Scale, Checkboxes, **Single Member**, **Multiple Members**, File Upload,
**Member Field to Update**.

Two of these matter for the model:
- **"Member Field to Update"** confirms the earlier finding that a form answer can write
  back into a member profile field. The form is a data-collection AND profile-update tool.
- **"Single Member" / "Multiple Members"** let a question reference members (typeahead),
  so a form response can link to other member records.

Forms also have **sections** ("+ Add Section Title & Description"). So the entities are:
Form (audience, schedule, anonymous flag), Question (type from the 13-value enum, required,
optional target member-field), Section, and FormSubmission (responses, with or without
submitter identity). `[design]` A full form builder is a large build; LATER for one chapter.

## Fundraising fund (`createFund`) — confirms donation/ledger double-write

A **Fund** has: Title, Description, Payment Options (a fund's campaigns use a "checkout
page"; "+ add new checkout pages"), and **Track as Income?** — "No, keep donations recorded
separately" | "Yes ... track as both a donation and a transaction." Confirms the earlier
finding that a fund can double-write a donation into the transaction ledger. Entities: Fund
-> Campaign(s) -> checkout page; Donation, optionally mirrored as a ledger Transaction.
`[design]` Alumni/donation scope; SKIP for one chapter.

## Custom profile field builder (`createuserfield`) — full per-field permission model

Fully read. A custom field definition has:
- `title`, `subtitle` (optional)
- **Merge Code** `{{member:...}}` — used in email templates to place the field's value.
- **Is Unique?**: No (any value) | Yes (require a unique value across all member profiles).
  So a custom field can carry a uniqueness constraint.
- **Type**: General Text, E-mail, Phone, Website, Yes/No, Date, Date & Time,
  Selection Drop-Down, Multi-Selection. (This is the custom-field type enum.)
- **Membership Statuses**: show for all statuses | only some statuses. Field can be scoped
  to particular membership statuses.
- **Field Usage**: "Public, Profile Field" (shown on profile) | "Private, Officer Only
  Notes Field" (hidden from active members, only shown to staff). This is how internal
  notes fields are defined.
- **Importance**: Optional (profile only) | Recommended (registration + profile) | Required
  (registration + profile). This controls whether the field appears on the public
  registration form.
- **Who can view?** (a full ACL, richer than the 5 display scopes on built-in fields):
  Any logged-in APO member | Only initiated members | Only Region B members | Only members
  | Only Alpha Delta members | Only Alpha Delta members excluding PNMs | Only the member and
  their officers/advisors | Only the member — plus a "All staff may also view" add-on.
- **Who can edit?** (separate from view): The member + officers/advisors | Only
  officers/advisors — plus "All staff may also edit".

So each profile field carries BOTH a view ACL and an edit ACL, can be unique, can be
scoped to membership statuses, can be a private officer-notes field, and can be pushed onto
the registration form. This is materially richer than the earlier "five visibility levels"
note (which came from the built-in-field editor). For the rebuild, a field definition needs
{ type, unique flag, view-scope, edit-scope, registration-importance, status-scope,
merge-code, public-vs-officer-notes }.

## SMS (`smsform`) — confirms shared audience model

Core Filter: "All members of the Alpha Delta site" | "Only Members attending the following
event: <event dropdown>". Same everyone-or-one-event audience as bulk email. (Message body
and the 128-character cap were already recorded.) No new entity.

## Confirmations, no new entities

- `defineEmailFilters` / `selectEmailAudience`: same audience model as SMS (all members |
  attendees of one selected event). No new entity.
- `createAlbum`: a photo Album is just Album Name + Album Description (photos are children;
  the officer approval step for photos was already recorded). Minimal.
- `getHelp`: vendor support only ("Open a Ticket", "Email Support"). No chapter data. SKIP.

## Plan-gated feature confirmed: Store Manager

`?action=manageStore` returns "Store Manager Not Enabled — It looks like your APOonline
subscription doesn't include the store manager feature. ... contact APOonline support at
support@greektrack.com." So the online store / e-commerce feature is gated by subscription
tier and is NOT enabled for this chapter; its schema cannot be read here. This confirms
that features are gated by plan (like the earlier Diamond-tier findings). `[design]` The
store is out of scope for a single-chapter rebuild anyway.

## Public registration (`register.php`) — three role paths

The registration entry page is "Select your status" with three self-selected paths, each
leading to its own flow (this covers the "both remaining status paths" unread item):
- **I am a student** — register for events/meetings, pay dues/fees, view roster and message.
- **I am an advisor** — help manage roster, review transactions during an audit, ensure
  officer transitions.
- **I am an alum** — browse alum directory by industry/location, browse/post jobs, email
  subscriptions.

So registration branches by role before collecting fields. (The student path's field set,
including the 15-char password cap, was already captured in
`raw/pages/register-and-remaining.md`.) The forms were not submitted (registration creates
an account, which is prohibited).

## The Dues requirement (`editrequirement&reqid=1`) is a special requirement type

Reading the Dues requirement's edit form shows it is NOT a generic requirement. It has
finance-specific fields the others do not:
- **Three-way dues split**: "Your Dues Requirement" = **Chapter Dues** (kept for the
  chapter) + **Region Dues** (sent to Region B) + **National Dues** (sent to the National
  Office). So a dues amount is decomposed into three destinations.
- **Per-account-type amounts** ("Individual Requirements"): a dues target for each of the
  14 account types, with the same "set to 0 to hide the progress bar" rule as other
  requirements.
- **Total Required**.
- **Dues Due Date** with a time (am/pm) — "shown on each member's homepage as a reminder
  until paid".
- **Automatic Late Fee**: "Impose an automatic late fee assessed on the due date" (toggle).
- **Accept Online Payments**: "Accept online payments for dues & fees" (toggle).

So the Dues requirement (reqid 1) unifies the requirement/progress-bar model with the
finance model: it is a requirement (per-account-type goal, progress bar) AND a dues
definition (chapter/region/national split, due date, late fee, online payment). For the
rebuild, dues is best modeled as its own thing that also drives a progress bar, not as a
plain requirement. This enriches the Money section of the data model.

## Correction: lineage (big/little) IS populated; named "lines" are not

`familytree.php` (public) renders a full big/little family tree for the chapter with many
members in it (names not recorded). Earlier notes assumed this page "would be empty because
the chapter has no lines". That conflated two different things:
- **Named lines / families** (the `updatemyfamily` entity): the chapter has none defined
  (72 members sit in "No line listed").
- **Big/little lineage** (the `addbig`/`addlittle` relationships): these ARE populated, and
  the family tree draws them.
So lineage relationships exist and are used even though named family-groups are not. The
`lineage` join table in the schema is therefore exercised by real data, and "line/family"
(the named group) is a separate, optional, currently-unused feature. (Structure only; no
member names copied.)

## manageblog confirms blog post entity

`manageblog` lists blog posts with Title, Last Modified, and author ("by <name>"). One real
post exists ("Leadership Update", Mar 2015). Confirms a blog post has title, body, modified
timestamp, and an author. No new fields beyond the blog lifecycle already captured.

## Alumni / messaging entities (SKIP scope, recorded for completeness)

- **Job Board** (`viewJobs`): a job-listing board filtered by industry (the same ~20-value
  industry enum used by Work Experience: Accounting, Engineering, Healthcare, Software, ...).
  Members can "Post Listing". Entity: JobListing (title, company, industry, location,
  description, posted-by). Alumni feature. `[design]` SKIP for one chapter.
- **Member-to-member messaging** (`viewmessage`): private DMs, "view your message history
  with them or create a new message". Entity: Message / thread between two members.
  `[design]` LATER/SKIP.
- **Bulk email records** (`manageEmailSubscriptions`): a list of bulk emails with Subject,
  Date, "Sent By", Actions, and a DRAFT state (drafts and sent items both persist). So a
  bulk email is a saved record (subject, body, sender, sent-or-draft, date), not fire-and-
  forget. Confirms email is an entity, with drafts. (Sender names not recorded.)

## Final tail

- `manageforms`: empty ("No member forms yet created"); list columns Form / Due Date /
  Status / Actions. Confirms the Form entity; nothing new.
- `comment` (send a comment to officers): a Comment field plus "Make this comment anonymous
  (your status will still show - e.g., 'Anonymous Active')". So an anonymous comment still
  exposes the sender's account type, just not their name. Minor detail.
- `myDonations`: a member donation summary. A donation total decomposes into **cash +
  non-cash gifts + soft credits**, reported over This / Last / Lifetime periods. So a
  Donation carries a type (cash, non-cash gift, soft credit) and a date. Alumni/fundraising
  scope. `[design]` SKIP for one chapter.

## Sweep summary

Routes read in full this pass: manageCourses, createCourse, createform, createFund,
createuserfield, smsform, defineEmailFilters, createAlbum, getHelp, manageStore (gated),
register.php, editrequirement&reqid=1 (Dues), familytree.php, manageblog, viewJobs,
viewmessage, manageEmailSubscriptions, manageforms, comment, myDonations.

New entities/rules found: Course (+ Module + Certificate), Form (+ Question 13-type enum
incl. member-field-update, + Section, + anonymous, + FormSubmission), the full custom-field
view/edit ACL and type enum, the Dues requirement as a special requirement type
(chapter/region/national split, late fee, online payments), Job Board (JobListing), member
messaging (Message), bulk email as saved draft/sent records, donation types
(cash/non-cash/soft credit), and the correction that big/little lineage is populated while
named lines are not. Store manager is plan-gated (not enabled).

## Contact Preferences (`contactPreferences`) — the notification model

A member's notification preferences have three parts:

1. **Email routing:** send to login e-mail or contact e-mail.
2. **Per-notification-type settings:**
   - weekly digest each Sunday of upcoming events (on/off)
   - reminder when an attending event approaches, with a lead time: Never, 1/2/3/12 hours,
     1/2/3/4/5/6 days, or 1 week before
   - when hours for an attended event are reported (i.e. credit awarded)
   - when a private message is received
   - **when promoted from a waitlist** (confirms events have a waitlist)
   - **when the member's account type changes** (confirms account-type-change notifications)
3. **Consent matrix by source x channel:** three sources (National, Region B, Chapter)
   crossed with channels Email / Call / Text / Paper Mail, each an OK toggle, with email
   split into "general updates" and "ad-hoc" and marked RECOMMENDED.

So the rebuild needs a notification-preferences entity: per-member email routing, a set of
per-event/per-activity notification toggles (several with a lead-time value), and a
source x channel consent matrix. This also confirms two features seen only indirectly
before: the event **waitlist** and the **account-type-change notification**. The multi-source
(national/region/chapter) consent is a national-hierarchy concern a single chapter can
collapse to one source.

## Member panels: engagement and leads

- `panel=engagement`: a per-member log of emails/SMS sent TO that member (Sent On, Subject,
  Message). So outbound messages are recorded per recipient (a delivery log). Empty for the
  operator.
- `panel=leads`: reuses the profile / education / work-experience data (LEADS is the alumni
  networking use of that data); no distinct entity beyond the profile child records already
  documented.

## Confirmed: Dues is the only special requirement

Checked other requirement edit forms to see whether any share the Dues requirement's
finance fields. They do not:
- `editrequirement&reqid=944` (Committee Credit): generic (label, categories, hours-or-
  percentage, external-credit toggle).
- `editrequirement&reqid=2` (Meeting): generic (label, hours, per-account-type goals,
  Total Required).
So reqid 1 (Dues) is the single special requirement; every other requirement uses the
generic form. No need to read the remaining reqid variants individually.
