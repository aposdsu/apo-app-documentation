# Seven places the real site differs from our first guess

> Summary: The corrections the walkthrough forced, and for each one whether the students
> should copy the vendor or do something else.
> Status: OBSERVED (the differences) and DESIGN (the recommendations)
> Read this if: you read the first version of the data model, or you are about to write
> the database schema.
> Depends on: docs/02-data-model/00-domain-model.md

Each section says what we guessed, what the site actually does, and what to build.

## 1. There are two permission grids, not one

**We guessed:** permissions come only from officer positions.

**The site:** two grids. Account types carry 40 privileges about what an ordinary member
may do. Officer positions carry 39 privileges about what an officer may manage.
(`raw/pages/memberhome_action-editprivileges_statusid-2.md`,
`raw/pages/memberhome_action-editofficerprivileges_officerid-2892.md`)

**Build:** copy this. It is the difference between "what kind of member are you" and "what
job do you hold", and both really do control access. Two join tables, one privilege list.

## 2. A requirement and an event type are the same record

**We guessed:** events have a `kind`, and requirements are separate rules.

**The site:** one record. The admin page for requirements is headed "Event Type", the same
numeric id is used in the requirement URL, the event-credit dropdown, the privilege key
`priv[req3]` and the progress URL. The link that creates one reads "create event type and
corresponding requirement progress bar".
(`raw/pages/memberhome_action-managerequirements.md`,
`raw/pages/memberhome_action-managemenu.md`)

**Build: do not copy this.** Merging them is why the site has an event type called "Dues
Requirement" and a requirement called "Charge as Admission Fee". Keep `requirement` and
let an event point at requirements through its credit rules. If a chapter wants to browse
"all service projects", that is a query over the credit rules, not a column.

## 3. An event's credits are a list, not one field

**The site:** each event carries zero or more credit rows. Each row is an amount, a
requirement, an optional category, and a flag for per-shift or per-event. The form calls
it "Requirement Credit" with a "+ add another credit" button. One event in this chapter
awards three different credits.
(`raw/pages/memberhome_action-eventcreate.md`, `raw/pages/memberhome_action-viewevents.md`)

**Build:** copy this exactly. Our `event_credit_rule` table was right. Add the per-shift
flag only if you build shifts.

## 4. Credit is created by an officer completing the event

**We guessed:** attendance produces credit, somehow.

**The site:** signing up does nothing to a member's progress. An officer opens the event
and completes it, and only then does everyone on the list get the credits the event
defines, along with a notification.
(`raw/pages/memberhome_action-pendingevents.md`,
`raw/pages/memberhome_action-viewnotifications.md`)

**Build:** copy this. It gives officers a moment to fix the list before anything is
awarded, and it gives you a natural place to make the award idempotent, meaning running it
twice does not double the credit.

## 5. The site seems to have no separate attendance record

**The site:** one list per event, called the sign-up sheet in some places and the attendee
list in others. Officers can "Manually add member" to it. Nothing observed records
"signed up but did not show up".
(`raw/pages/memberhome_action-eventsignup_eventid-1152799.md`)
This is `[inferred]`, confidence medium: we did not open an event's attendance screen
after completion, so a separate record may exist and simply not be visible from the pages
we read. It is in `docs/GAPS.md`.

**Build: do not copy this.** Keep `signup` and `attendance` as two tables. The gap between
who said they would come and who came is one of the things a chapter most wants to see,
and you cannot get it back later if you never stored it.

## 6. Internal and external credit are tracked separately, with a cap

**The site:** every requirement has a flag for whether outside work counts. Every goal is
two numbers: the total required, and the most that may come from outside events. Every
credit row carries an internal-or-external flag. The progress table shows Internal,
External and Total columns for the requirement and for each of its categories.
(`raw/pages/memberhome_action-createrequirement.md`,
`raw/pages/memberhome_action-managerecords_reqid-3.md`)

**Build:** copy the flag on the credit and the cap on the goal. This is a real rule that
chapters have, and it is cheap: one boolean and one extra number.

## 7. Profile fields and chapter fields are stored by number

**The site:** the profile form contains a field literally named `profile[473]` next to
named fields like `profile[firstname]`, each with a matching
`profile[visibility][<number>]`. The chapter form is entirely numbered:
`chapterinfo[1]` through `chapterinfo[9]`, `chapterinfo[20]`, `chapterinfo[21]`. The
profile page carries a link reading "Add a new field to all profiles".
(`raw/pages/memberhome_action-managebrother_panel-account.md`,
`raw/pages/memberhome_action-editchapterinfo.md`, `raw/pages/memberhome_misc-surfaces.md`)

`[inferred]`, confidence high: the site stores attributes as rows of (record, field id,
value) rather than one column per attribute. That is what lets a chapter add its own
profile field.

**Build: do not copy this for the fields you already know about.** Give `member` real
columns for name, e-mail, phone and so on. Real columns can be typed, indexed and
constrained; numbered rows cannot. If the students later want chapter-defined extra
fields, add one small side table for those alone. A design that stores everything as
numbered rows is called EAV (entity-attribute-value), and it makes every query harder for
the rest of the project's life.

## 8. Big/little is many-to-many, and we had it wrong

**We guessed:** one big per member, stored as `member.big_member_id`.

**The site:** "If they have more than one big member or little member select each
individually from the boxes on the right", with separate add-one-big and add-one-little
forms (`raw/pages/managebrother-all-panels.md`).

**Build:** a `lineage(big_id, little_id)` join table, which the schema now has. This is the
cheapest correction in this document to make now and the most annoying to make later,
because a single column that turns out to need to be a table takes a migration plus every
query that touched it.

## 9. Half the vocabulary is a chapter setting

**The site's own words are configurable.** `?action=editfamilysettings` lets a chapter
rename Family to Group or to anything else, and Big/Little to Parent / Child or anything else.
Alpha Delta set family to "line/lines", which is why every screen says Line
(`raw/pages/full-read-findings.md`). Requirements are the same: `text_what` and `text_unit`
are free text, which is why one chapter's "Service Project" / "Service Hour" is another's
something else.

**Build: copy the idea, cheaply.** You do not need a settings screen for it. Put the
singular and plural label on the row itself, the way `account_type` already carries `name`
and `name_plural` in the schema, and read the label from the data rather than writing it
into templates. That is the difference between a system a chapter can adopt and one they
have to argue with.

It also means **a reader of this documentation should not treat any on-screen noun as the
product's own term** without checking. "Line", "Big", "Little", "Service Hour" and every
requirement name are Alpha Delta's words.

## Two smaller notes

**Per-field visibility.** Every profile field has its own audience, and there are five of
them: "Anyone", "Anyone + Staff", "Alpha Delta Only + Staff", "Officers",
"Hidden (Staff Only)". Two of the five exist only because the vendor's own staff are a
party to the data (`raw/pages/completeness-pass.md`). `[design]` A single chapter has no
vendor staff, so three of those five collapse immediately. Recommend one visibility setting
covering contact details as a whole, and only expand if members ask.

**Profile history.** The vendor keeps every past value of a profile field and offers a
"clear your profile history" action (`raw/pages/completeness-pass.md`). `[design]` Do not
build this. It is a privacy liability for a student project: it means a member who corrects
their own phone number or name has not actually removed the old one. If the chapter wants
history, keep it in the audit log where it is bounded and reviewable, not as a shadow copy
of every profile field.

**Vendor plan gating.** Some features are switched off unless the chapter pays more:
document storage, mobile check-in and others need the Diamond plan
(`raw/pages/memberhome_action-billingoverview.md`). This is a business rule of the vendor,
not of a chapter. Ignore it entirely.
