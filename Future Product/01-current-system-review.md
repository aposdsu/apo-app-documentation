# What the current system does, and where it costs people time

> **What this is.** A review of the chapter management system the chapter uses today
> (APOonline, made by GreekTrack), written for the people who have to decide what the next
> product should contain.
>
> **Who it is for.** Product managers, product owners, designers, chapter officers, and
> anyone who needs to decide which parts of the current system to keep, change or drop.
>
> **What it is based on.** A screen-by-screen reading of the live system through an
> administrator account in August 2026, recorded in the `docs/` and `raw/` folders of this
> repository, plus several points confirmed by the chapter advisor who runs the chapter.
> Nothing on the live system was changed, and no member or officer was watched using it.
>
> **Feedback from users.** In addition, students and others who use the system have given
> written feedback about it. It is listed in full in section 5.1 and it drives findings F-16
> to F-22. It tells us what people experience. It is not the same as watching someone work
> or counting what they do, and it is labelled separately throughout.
>
> **What it does not contain.** Usage figures, support tickets, or any count of how often a
> feature is actually used. Where a conclusion would need that kind of evidence, this
> document says so instead of guessing.
>
> **Companion document.** `Future Product/02-future-product-plan.md` says what to build.
> This document says what exists now and why it matters.

---

## 1. How to read this document

### 1.1 Labels on statements

Every statement that is not obvious carries one of these labels, so a reader can tell a
fact from an opinion.

| Label | What it means |
|---|---|
| **Seen** | Read directly from a screen of the live system. The record of it is named. |
| **Worked out** | Not written on any screen. Reasoned from what was seen. The reasoning and a confidence level (high, medium or low) are given. |
| **Confirmed by the chapter** | Stated by the chapter advisor who runs the chapter, in August 2026. |
| **Reported** | Told to us by students or others who use the system. It is what they experience. It has not been checked against the screens unless the text says it has. |
| **Recommended** | Our opinion about what to do next. Not a fact about the current system. |
| **Not known** | We could not settle it. The text says what would settle it. |

### 1.2 Words used for the recommended treatment of each feature

The feature tables in section 6 use one of six words in the "Treatment" column. They mean
exactly this and nothing else.

| Word | Meaning |
|---|---|
| **Keep** | Build it in the new product, working close to the way it works now. |
| **Keep, changed** | Build it, but change how it works. The change is named in the same row. |
| **Later** | Worth building, but not in the first release. A chapter can run a semester without it. |
| **Drop** | Do not build it. The row says what the risk is if that turns out to be wrong. |
| **Replace** | The underlying need is real, but a different approach meets it better. The replacement is named. |
| **Out of scope** | The feature exists only because the current system serves many chapters, a region and a national office. A system for one chapter has no use for it. |

Everything in every column except the last is our observation or our recommendation. The
last column, **Owner decision**, is deliberately left empty. It is for the product owner to
fill in. Nothing in this document should be read as that decision having already been made.

### 1.3 Feature identifiers

Every existing feature has an identifier such as `LEG-F-041`. "LEG" is short for legacy,
meaning the system in use today. These identifiers do not change once assigned, so a
backlog item, a decision record or a later document can point at one feature without
ambiguity. They are used again in the plan document and in the coverage check in section 8.

---

## 2. The chapter and the system, in numbers

These figures come from the chapter's own screens in August 2026. They matter because they
describe this chapter as it stands today. They are not a target for the new product: a chapter
of ten and a chapter of a hundred and fifty both have to work, and this chapter will not be
this size in five years.

| What | Number | Where it was seen |
|---|---|---|
| Member records in the chapter's history | 589 | Officer dashboard, member counts |
| Current members | 66 | Officer dashboard |
| Alumni | 523 | Officer dashboard |
| People who registered and are waiting to be approved | 7 | Officer dashboard |
| Officer positions the chapter has defined | 19 (18 officer, 1 advisor) | Officer positions screen |
| Officer positions with nobody in them | 4 | Officer dashboard |
| Account types, meaning the chapter's own membership categories | 14 (10 shared with all chapters, 4 created by this chapter) | Account types screen |
| Requirement types, such as service hours, meetings and dues | 18 | Officer permission grid |
| Separate permission settings an administrator can change | 79 (40 for account types, 39 for officer positions) | The two permission grids |
| Distinct operations that write data | About 50 | `docs/03-api/write-operations.md` |

**Seen**, all of the above, recorded in `docs/01-pages/managemenu.md`,
`docs/04-system-design/02a-privilege-lists.md` and `docs/GAPS.md`.

One structural note, because it explains a lot of what follows. The whole system is a
single web page that changes what it shows based on a keyword in the address, for example
`memberhome.php?action=managerecords`. There are roughly ninety of these keywords. The
navigation menu shows some of them. Others can only be reached from a link inside another
screen, and a few can only be reached by typing the address directly. **Seen**
(`docs/INVENTORY.md` lists the keywords that were found only by reading the page source).

---

## 3. Who uses the system, and what each of them is trying to do

The system does not have user roles in the ordinary sense. What a person can do is decided
by two settings that are configured separately (see finding F-06). In practice, five kinds
of people use it.

### 3.1 A member

**What they need to know:** how many service hours, meetings and other credits they have
this term, how many they still owe, whether their dues are paid, and what is coming up.

**What they need to do:** sign up for events, and check their own progress.

**What they cannot do on this chapter:** create an event, record their own service hours,
or record their own attendance. All three are granted only to the "Officer" account type.
**Seen** (`docs/04-system-design/02b-feature-actions-and-permissions.md`).

### 3.2 An officer responsible for one area

For example the Service Vice President, the Treasurer or the Recording Secretary.

**What they need to know:** which events of their type are coming up, which have already
happened but have not yet been turned into credit, and which members are behind on the
requirement they look after.

**What they need to do:** create events, mark an event as complete so that everyone who
attended receives credit, correct the attendance list, add credit by hand for work done
outside chapter events, and produce a list of who is behind before a chapter meeting.

**Their reach is deliberately narrow.** The permission to manage the service hours
requirement is a different permission from the one for meetings, dues or fundraising.
**Seen** (the requirement map in
`docs/04-system-design/02b-feature-actions-and-permissions.md`).

### 3.3 The chapter president or advisor, acting as administrator

**What they need to know:** who is waiting for approval, which officer positions are empty,
and whether the chapter's settings are right for the coming term.

**What they need to do:** approve new members, assign people to officer positions, decide
what each position is allowed to do, set the term dates, and create or change requirements.

On this chapter, five of the nineteen positions hold every administrator permission,
including the permission that changes permissions. See finding F-07.

### 3.4 A person who wants to join

**What they need to do:** fill in a registration form, say whether they are a student, an
advisor or an alum, and then wait. They cannot sign in until an officer approves them.
**Seen** (`docs/04-system-design/03-flows.md`, workflow 1).

### 3.5 An alum

Alumni are by far the largest group in the system: 523 records out of 589. What the system
offers them is a directory, a job board and private messages. Whether any alum uses these
is **not known**. No usage data exists to answer it, and answering it would need either
usage logging or a short survey of alumni.

---

## 4. The main tasks, end to end

These six tasks are what the system is used for. Each is written so that someone who uses
the system would recognise it. Each ends with what works and what does not.

### Task A: A new person joins the chapter

1. The person opens the chapter's public registration link, or an officer adds them
   directly.
2. They create an account with an email address and a password, or by signing in with
   Google or Facebook.
3. They say whether they are a student, an advisor or an alum. This is what they are asking
   to become, not what they will be.
4. They fill in their name, contact details, addresses, pledge class year and graduation
   year, and choose who is allowed to see each field.
5. They submit the form, and then they wait. They cannot sign in yet.
6. An officer opens the list of people waiting. For each person the officer picks one of
   three outcomes from a single dropdown: skip them for now, reject them, or choose the
   account type that approves them.
7. Once approved, the person can sign in.

**Seen** throughout (`docs/04-system-design/03-flows.md`, workflow 1).

**What works.** The three-way decision is better than approve-or-nothing, because an officer
can decline someone without deleting their record. The waiting list is shown on the officer
dashboard with a count, so it is hard to forget entirely.

**What does not.** Seven people were waiting at the time of the review. Nothing in the
system shows how long any of them had been waiting, and nothing chases anyone. **Seen** (the
pending approvals screen has no date column). The people who receive an email when someone
registers are the five positions that hold every permission, rather than one named person
who is responsible for it.

**What the new product does instead.** None of this. The chapter decided the new product is
invite-only (decision D-08): an officer invites somebody or imports a roster, that person
receives an email, sets a password, and is in. There is no public link, no queue and nothing
to approve, because the invitation is the decision. This description stays here because it is
what the current system does, not because it is being carried forward.

### Task B: An event runs, and people get credit for it

This is the task the whole system is built around.

1. An officer creates the event. The form has roughly sixty fields: when, where, a
   description, how many people may attend, when sign-ups open, when they lock, when they
   close, who can see it, who can sign up, when the attendee list becomes visible, up to two
   coordinators, and whether people can offer rides.
2. The officer sets what the event earns. One event can award several different credits at
   once, for example one meeting credit and one required-event credit. An event can also
   award nothing at all.
3. Members sign up. If the event is full, further sign-ups go on a waiting list, and a
   member is told if a place opens for them.
4. The event happens. Nobody's progress has changed yet.
5. An officer opens the event, corrects the list by hand (adding anyone who came without
   signing up), and presses "Complete event".
6. Only now is credit written. Everyone on the list receives every credit the event defines,
   and each of them gets a notification saying what they were credited with.

**Seen** throughout (`docs/01-pages/pendingevents.md`, `docs/04-system-design/03-flows.md`,
workflow 3).

**What works.** Separating "the event happened" from "credit has been given" is the best
decision in the product. It gives an officer a moment to fix the list before anything is
written, and it means credit is never awarded by accident. The dashboard lists the events
that are waiting to be completed, so the step is hard to skip.

**What does not.** There is only one list per event. It is called the sign-up sheet on some
screens and the attendee list on others, and it is the same list. When someone signs up and
does not come, the officer removes them, and the fact that they promised to come and did not
is gone. See finding F-01.

### Task C: An officer checks who is behind

1. The officer opens the progress screen for one requirement, for example service hours.
2. The screen shows every member as a row, with the amount earned and the amount required,
   written as "0 of 15". A requirement can be split into parts (this chapter splits service
   into service to the campus, the community, the nation and the fraternity), and each part
   gets its own columns.
3. Credit earned at chapter events and credit earned elsewhere are counted in separate
   columns, because a requirement can limit how much may come from outside.
4. The date range defaults to the current term and can be changed to any range.
5. To produce a list for a chapter meeting, the officer uses the report builder: pick the
   fields, the requirements, the account types and the dates, tick "only show members
   lacking in the selected requirements", and view it or download it as a spreadsheet file.

**Seen** (`docs/01-pages/managerecords.md`, `docs/04-system-design/03-flows.md`, workflow 5).

**What works.** The "earned of required" cell, the free choice of dates, and the filter that
shows only members who are behind. Those three together answer the question an officer
actually has.

**What does not.** The required amount is looked up from the member's account type, and the
account type changes automatically when someone takes or leaves an officer position. So the
number a member is measured against can change without anyone deciding that it should. See
finding F-05.

### Task D: Dues are charged and paid

1. Dues are set on a special requirement called "Dues & Fees". The amount is set per account
   type, so an associate member can owe less than an active member. Each amount is split
   three ways, into chapter, region and national shares.
2. A due date is set, and it appears on the member's home page until they pay.
3. A member's dues appear as a progress bar next to their service hours, because dues are
   modelled as a requirement.
4. The Treasurer records each payment by hand: which member, cash, cheque, card or other, an
   amount, and a note. Payments reduce the member's balance.
5. Every payment and fee lands in a ledger with a date, who it was from, a note, a type and
   an amount. Each line can be attributed to a budget owned by an officer position.

**Seen** (`docs/04-system-design/03-flows.md`, workflow 7).

**What works.** One permission controls the whole money area, and on this chapter only the
Treasurer and the five all-permission positions hold it. Charging a one-off fee, recording a
payment and seeing a running balance are all in one place.

**What does not.** The system also offers online card payment and an automatic late fee. The
chapter has never used either. **Confirmed by the chapter** (August 2026). The chapter also
has two separate requirements that both look like dues. See finding F-11.

### Task E: The term changes

Two things happen, and they are not connected to each other.

**The date window moves by itself.** The chapter sets a repeating month and day for the
start of each term (here, 20 December and 20 June). When that date passes, "this term" means
the next window, every progress bar starts again from zero, and nothing is copied, archived
or announced.

**People are moved by hand.** Officers are reassigned on a single page that lists every
position, with one button at the bottom labelled "Update Officers and Send Activation
Emails". Members are moved between stages (prospect, potential new member, member, alumni)
by ticking boxes and pressing "Graduate Members".

**Seen** (`docs/04-system-design/03-flows.md`, workflow 6; `docs/01-pages/setterm.md`).

**What does not work.** This is the weakest part of the system.

- A member's account type is stored as one current value, not as a value per term. The
  system keeps a dated note of each change on the member's timeline, but there is no way to
  ask "who was an active member in Spring 2025". **Seen** (`docs/GAPS.md`).
- Officer assignments work the same way. Last term's assignments are overwritten by this
  term's.
- Changing the two term-start dates changes every progress bar and every default report
  window for the whole chapter, backwards as well as forwards, and the screen carries no
  warning. See finding F-03.

### Task F: An administrator decides who can do what

1. The chapter creates its own officer positions and says whether each one is an officer
   position, an advisor position, or both. This choice cannot be changed afterwards.
2. For each position, the administrator opens a grid of 39 permissions with an "allow" and a
   "disallow" button on each row, and saves the whole grid at once.
3. Separately, for each of the 14 account types, the administrator opens a different grid of
   40 permissions and does the same again.
4. What a person may do is everything their account type allows, plus everything each of
   their positions allows.

**Seen** (`docs/04-system-design/02-auth-and-permissions.md`).

**What works.** Permissions are settings, not something a developer has to change. A chapter
can invent a new officer position on a Tuesday and give it exactly the permissions it needs.
Creating a new requirement automatically creates a permission for managing it, so a Service
Vice President can manage service hours without also being able to change dues. This is the
best-designed part of the product, and it should be carried forward.

**What does not.** Two grids of near-identical rows, 33 grids in total, no way to see them
side by side, and no way to name a set of permissions and reuse it. The result on this
chapter is configuration that has drifted in ways nobody appears to have intended. See
findings F-06, F-07 and F-08.

---

## 5. What is wrong today, and what to do about it

Each finding follows the same shape: what happens now, why it is a problem for the people
using the system, what should change, what should improve as a result, and what still needs
checking before anyone relies on it.

These findings come from two sources. Findings F-01 to F-15 came from reading the screens
and the chapter's own configuration. Findings F-16 to F-22 came from feedback given by
students and others who use the system, and several of them are also supported by what the
screens show.

**Nobody has been watched using the system, and no usage data was available.** Feedback
tells us what people experience, which is real evidence and a different thing from
measurement. Where a finding would be stronger with observation or counts, it says so under
"still needs checking".

### 5.1 The feedback, item by item

Every item of feedback received is listed here with an identifier, so that a later document
can point at one item, and so that nothing was quietly dropped for being inconvenient. The
"How it stands against the system" column says whether the screens support it.

| ID | What was reported | How it stands against the system | Dealt with in |
|---|---|---|---|
| FB-01 | There is no second step when signing in | Confirmed. There is none | F-13 |
| FB-02 | The system's endpoints are effectively open; anyone can call them | Not verified, and deliberately not tested. See F-22 | F-22 |
| FB-03 | Hard to navigate, especially for new members. It only gets easier once you have memorised where things are | Consistent with what was seen: about ninety screens, some reachable only by typing an address | F-16 |
| FB-04 | Too many links that lead somewhere other than where they say | Partly confirmed. One such link was found during the review | F-16 |
| FB-05 | Every screen looks the same, only the colours differ | Consistent with the structure: one page that changes by keyword | F-21 |
| FB-06 | The interface reads as early-to-mid 2010s | Reported only. Appearance was deliberately not recorded during the review | F-21 |
| FB-07 | There is no guidance on how to use the site. Changing the colour theme is possible but nobody can find it | Consistent. No help screen was found other than the vendor's support links | F-16 |
| FB-08 | The dashboard is not useful. There is no way to change what it shows to match what matters to the chapter. On signing in a member wants to see the events they signed up for, announcements, documents officers have recently uploaded, and other things the chapter chooses | Matches. The page cannot be changed at all, and two of those four things are not on it | F-23 |
| FB-09 | There is no announcements feature at all | Contradicts what was seen. The system has one | F-17 |
| FB-10 | Announcements have moved to Discord and get lost there | Reported only, and it explains FB-09 | F-17 |
| FB-11 | There is no central place for documents. People constantly ask where the bylaws are | Contradicts what was seen. A file store exists, but it was switched off on this chapter's plan until the chapter upgraded on 29 August 2026 | F-17 |
| FB-12 | The blog is not worth having and is tied to a website builder | Matches. It is already recommended for dropping | LEG-F-102 |
| FB-13 | Profiles cannot hold custom fields such as preferred contact method | Contradicts what was seen. The system can add a field to every profile | F-17 |
| FB-14 | Every semester the pledge trainers make everyone fill in a separate directory form instead of using profiles | Reported only, and it is the cost of FB-13 | F-17, LEG-F-014 |
| FB-15 | No flexibility with officers. A non-officer such as a leadership chair cannot be given access to a requirement. The system dictates how the chapter can organise itself | Matches what was seen | F-19 |
| FB-16 | Events can be pushed to Google Calendar but not pulled from it | Matches. The event page has a one-way link | F-20 |
| FB-17 | No way to compare chapter events against your real schedule without moving between tabs | Matches | F-20 |
| FB-18 | Requirements and progress are hard to read because officers update them late, often a day or two after an event | Matches the design: credit exists only after an officer completes the event | F-18 |
| FB-19 | Attendance is collected with Google Forms plus a photo for verification | Reported only, and it is new information about how the chapter actually works | F-18 |
| FB-20 | There is no pending state. You do not know whether you got credit until an officer updates it | Matches. Nothing between attending and being credited was found | F-18, F-14 |
| FB-21 | There is no marketplace or shop | Correct for this chapter. The product has one, but it is not switched on here | LEG-F-083, decision D-12 |
| FB-22 | No practical visibility of other chapters. The Region B calendar is empty and most chapters' sites are down | Matches, and it strengthens the case for leaving cross-chapter features out | LEG-F-125, LEG-F-126 |
| FB-23 | Still built in PHP, everything on the server, barely any features added in ten years | Partly correct. See the note below this table | Noted below |

**One reported item needs care, and one earlier reading of this list was wrong.**

**FB-08 was misread the first time this document was written.** It was recorded as
conflicting with the screens, on the reasoning that the home page does show progress bars
and upcoming events, so the content was there and the complaint must be about the content
being crowded or out of date. That reasoning was wrong. The person who reported it has since
explained what was meant: the page cannot be changed. Finding F-23 records the corrected
version. The mistake is left visible here rather than quietly edited out, because it is a
good example of the risk in this whole document: reading a piece of feedback against the
screens and deciding what the person must have meant. Ask instead.

**FB-23, the pace of change.** The vendor's release notes run from September 2018 to June
2026 and list a large number of additions (**Seen**). What the evidence does support is that
little has changed in what this chapter uses day to day, and that nine of the newer features
are charged as extras on a higher plan. Recorded as partly correct, because the distinction
matters: the product is being developed, but not in the direction this chapter needs.

### F-01: The system cannot tell who signed up and did not come

**What happens now.** Each event has one list of people. Some screens call it the sign-up
sheet, others call it the attendee list, and it is the same list. An officer running an
event corrects that list by hand: they add people who turned up without signing up, and
remove people who signed up and did not come. Nothing records that the second group ever
signed up. **Seen** (`docs/01-pages/eventsignup.md`; a completed event and a future event
were compared and the table is identical, with no present or absent column).

**Why it is a problem.** Attendance that was promised and not delivered is one of the things
a chapter argues about most. Officers who need this today have to remember it, or keep their
own list outside the system. The information cannot be recovered later, because it was never
stored.

**What should change.** Keep both facts on **one list** (decision D-02). Everyone on an
event's list has a state: signed up, and then present or absent. When the officer closes the
event they tick people off. Somebody who signed up and did not come is **marked absent, not
deleted**.

That is one list to work with, which is what the chapter asked for, and it still answers the
question the current system cannot. Two lists would have been the obvious way to keep both
facts; a state on one row is cheaper for the officer and keeps the same information.

**What should improve.** An officer can see, for one member or for the whole chapter, how
often a promise to attend was kept, without managing two lists. Nobody has to keep a private
list.

**Still needs checking.** Whether officers actually want this recorded, or would find it
uncomfortable to record. Ask two or three officers before building it.

### F-02: Deleting something leaves pieces of it behind

**What happens now.** Deleting a record does not remove the things it created. Deleting an
award leaves the "received award" line on the member's timeline until that line is deleted
separately. Deleting an event leaves behind the credit it awarded and the notifications it
sent. **Seen** (`docs/04-system-design/03-flows.md`, workflow 8, from an award that was
granted and removed during the review).

**Why it is a problem.** A member can see a note saying they received an award they no
longer have. Credit can go on counting towards a requirement for an event that no longer
exists, and the officer who deleted the event has no way to know that.

**What should change.** Decide, for each kind of record, what deleting it should do to the
records it produced, and say so on the confirmation screen. For example: "Deleting this
event will also remove 14 service hour credits from 9 members. Their progress bars will
change." Where a deletion should not remove the credit, say that instead.

**What should improve.** The person deleting something is told what else will change before
they confirm, and no member is left looking at a record of something that did not happen.

**Still needs checking.** Which of these deletions the chapter actually performs, and how
often. The audit log would answer this if it were reviewed for a term.

### F-03: One small screen silently changes every member's progress

**What happens now.** The term dates screen collects a repeating month and day for the start
of each term. Changing those two values changes what "this term" means everywhere: every
progress bar, every default report range, and what counts as this term's work. The change
applies backwards as well as forwards. The screen carries no warning and no confirmation
step. **Seen** (`docs/01-pages/setterm.md`).

**Why it is a problem.** An administrator correcting a typo can move every member's progress
in the chapter without knowing they have done it. Members would see their progress bars
change with no explanation.

**What should change.** Two things. First, keep a real list of terms with a name, a start
date and an end date, one row per term, instead of a repeating rule. Second, when a term's
dates are edited, show what will change before saving: how many terms are affected, and how
many credits move in or out of a term.

**What should improve.** A term can be corrected when a semester starts late, without
affecting any other term. The person making the change sees the effect before they commit
to it.

**Still needs checking.** Nothing. The behaviour is on the screen and the risk follows
directly from it.

### F-04: Information about one member is spread across ten screens

**What happens now.** Work about one member is spread across screens that do not link to
each other in an obvious way. A member's record has ten separate panels (profile, status,
records, awards, family, events, files, engagement, notifications and a national programme
tab). Progress on each requirement is a separate screen, one per requirement. The screen for
editing the navigation menu is reached from a dashboard panel that points at a different
screen entirely. **Seen** (`docs/01-pages/00-index.md`, which notes that the dashboard's
external links panel points at the wrong screen).

**Why it is a problem.** To answer "is this member in good standing", an officer has to open
several screens and hold the answers in their head. Anything that requires more than one
screen tends to get done less often.

**What should change.** Build one page for one member that answers the questions officers
actually ask: their account type, the positions they hold, their progress on every
requirement in one table, their dues balance, and their recent activity. Keep editing on
separate screens if that is clearer, but do not split reading across ten of them.

**What should improve.** An officer can answer a question about a member from one screen
instead of six.

**Still needs checking.** Which questions officers ask most often about a member. This is a
short conversation with two or three officers and it would change the order of the page.

### F-05: Becoming an officer silently changes what a member owes

**What happens now.** Two things are joined that should not be. First, assigning a member to
an officer position changes their account type to "Officer", and removing them from it
returns them to "Active". **Confirmed by the chapter** and stated on the assignment screen.
Second, the amount a member owes on each requirement is looked up from their account type.
**Seen** (`docs/04-system-design/02-auth-and-permissions.md`; the requirement targets grid).

Putting those together: when someone takes office, the number they are measured against
changes. **Worked out**, confidence high. The credits they have already earned are kept
unchanged; it is the target that moves (**seen**, `docs/GAPS.md`).

**Why it is a problem.** A member can be told they are behind, or told they are finished,
because of a change nobody made deliberately. It also makes some real situations impossible
to record: a member cannot be on a leave of absence and hold the Historian position at the
same time, because holding the position overwrites the account type.

**What should change.** Keep the two separate. A member has an account type, and separately
holds zero or more positions. Nothing about taking office should change their account type.
If officers should owe different amounts, make that an explicit setting on the requirement,
not a side effect.

**What should improve.** The chapter can record what is actually true about a person, and
nobody's target changes without a decision.

**Settled** (decision D-05, 4 September 2026). Officers can owe more, and it is a deliberate
rule rather than a side effect: an account type can build on another, and a position or group
can add requirements of its own. Nothing about holding a position changes a member's account
type.

### F-06: Permissions come from two grids that nobody can see together

**What happens now.** What a person may do is the sum of two separately configured lists: 40
permissions attached to their account type, and 39 permissions attached to each officer
position they hold. There are 33 grids in total. No screen shows a person's actual
permissions, and no screen compares two positions. **Seen**
(`docs/04-system-design/02-auth-and-permissions.md`).

Some of the permission settings are also stored backwards. The setting for "view roster and
profiles of other members" is stored as "hide members", so allowing it means saving a
"false". Eight settings work this way. **Seen**
(`docs/04-system-design/02a-privilege-lists.md`).

**Why it is a problem.** An administrator cannot answer "what can this person do" without
opening several grids and adding them up in their head. Settings stored backwards are read
wrongly by people as well as by software.

**What should change.** Three things. Store every permission as a positive statement ("may
view the roster"). Add one screen that shows, for a chosen person, every permission they
have and where each one comes from. Add one screen that compares positions side by side.

**What should improve.** Administrators can check a person's access in one place, and
mistakes become visible instead of staying hidden in a grid nobody opens.

**Still needs checking.** Nothing about the problem. How often administrators change
permissions is unknown, and would tell you how much to invest in the comparison screen.

### F-07: Five of the nineteen positions can do everything

**What happens now.** Every one of the 33 permission grids was read. Five positions hold all
39 officer permissions, including the ability to change the permission grids themselves:
President, Chapter Advisor, Membership Vice President, Equity and Inclusion Chair, and
Historian. The system labels only the first two as primary positions. One position, the
Conference Chair, holds no permissions at all, and the system prints "missing privileges"
next to it. **Seen** (`docs/04-system-design/02-auth-and-permissions.md`).

Two more oddities. The permission to manage committee credit is held by 14 of the 19
positions, far more than any other, which suggests it is being used as a general "may give
credit" permission rather than for its stated purpose. Two permissions (using the anonymous
comment form, and editing one's own family lineage) are held only by the "Bad Standing"
account type, and by no other type. **Seen**, same source.

**Why it is a problem.** The chapter almost certainly did not intend a Historian to be able
to change everyone's permissions, or a member in bad standing to be the only person who can
send anonymous feedback. Nobody has noticed, because there is no screen that would show it.

**What should change.** Two things. Give the new product a small number of named permission
sets (for example "chapter administrator", "requirement manager", "treasurer") that
positions point at, instead of copying a grid nineteen times. And show a warning on the
permission screen when a position is about to be given the ability to change permissions.

**What should improve.** Configuration mistakes become visible. Giving someone full
administrative access becomes a deliberate act, not a side effect of copying a grid.

**Still needs checking.** Whether these settings are intentional. Show this finding to the
chapter and ask. That conversation is worth having before any migration of settings.

### F-08: Ordinary members cannot record anything, so officers do all the typing

**What happens now.** On this chapter, only the "Officer" account type may create an event,
complete an event, or record their own credit. An ordinary active member can do none of the
three. **Seen** (`docs/04-system-design/02b-feature-actions-and-permissions.md`). The
account type "Officer" is set by the system when someone is given an officer position (see
F-05), so in practice the people who can do these things are the officers.

The system does offer per-requirement settings for members to log their own credit, but the
screen heads that whole group of settings with the words "(not recommended)".

**Why it is a problem.** Every hour a member does outside a chapter event has to be typed in
by an officer. That is slow, it delays members seeing their own progress, and it makes
officers the bottleneck at exactly the time of term when they are busiest.

**What should change, and what the chapter decided.** This document first recommended letting
members submit their own credit for an officer to approve. The chapter decided otherwise
(decision D-01), and drew a line this recommendation had missed:

| The member can | The member cannot |
|---|---|
| Submit **attendance** at an event, with whatever proof the event asks for, and see it waiting | Write **credit** of any kind |
| | Enter hours for work done outside a chapter event |

Credit only ever comes from two places: an event that awards it, or an officer or chair who
holds the permission for that requirement typing it in. So the member reports a fact about
themselves and somebody with the permission decides what it is worth.

**What should improve.** The typing that officers do today for event attendance moves to the
people who were there, and the officer approves a list instead. Hours worked outside a chapter
event still go through an officer, which is what this chapter wants.

**Settled**, decision D-01, 4 September 2026. The earlier recommendation was not what the
chapter wanted, and the distinction between reporting attendance and writing credit is the
part it was missing.

### F-09: There is no record of who was a member in a past term

**What happens now.** A member's account type is a single current value. Changes are noted
as dated lines on the member's timeline, so the history exists as a list of events but not
as an answer to a question. Officer assignments are not kept per term at all: reassigning a
position overwrites who held it. **Seen** (`docs/GAPS.md`,
`docs/04-system-design/03-flows.md`, workflow 6).

**Why it is a problem.** Questions the chapter genuinely asks cannot be answered: who was
active last spring, who held this position two years ago, how many members completed their
service requirement in Fall 2024. Anyone who needs the answer has to read the timeline of
each member one at a time.

**What should change.** Store one row per member per term recording their account type for
that term, and one row per position per term recording who held it. This is the change that
is cheapest to make now and most expensive to make later, because the history cannot be
reconstructed once the terms have passed.

**What should improve.** The chapter can answer questions about any past term directly, and
officer handover stops destroying last term's record.

**Still needs checking.** Nothing about the need. Whether the chapter wants to import
history from the current system is a separate decision (see decision D-08 in the plan
document).

### F-10: The requirement list has grown to eighteen types with overlapping names

**What happens now.** The chapter has 18 requirement types. Several look like duplicates of
each other: "Dues & Fees" and "Dues"; "Philanthropy Hours" and "Philanthropy Credits";
"Fellowship Events" and "Special Fellowships"; "Chair Credits" and "Committee Credits". One
of them is spelled "Philanthropy Hourses". **Seen**
(`docs/04-system-design/02a-privilege-lists.md`, which lists all eighteen by name).

Creating a requirement is easy, and every requirement creates two new permission settings
automatically. Nothing in the system retires a requirement or marks it as no longer in use.
Deleting one is possible but destructive.

**Why it is a problem.** Members see up to eighteen progress bars, some of which mean
nothing to them. Officers choosing what an event should award have to pick from a long list
with similar names. Each unused requirement also adds two rows to every permission grid.

**What should change.** Add a way to retire a requirement: it stops appearing on new events
and on members' progress screens, but its past credits are kept and still appear in reports
for past terms. Separately, before any migration, review the eighteen with the chapter and
agree which are still in use.

**What should improve.** Members see only the requirements that apply to them now. Officers
choose from a short list. Nothing is lost from the record.

**Settled** (decision D-04, 4 September 2026). None of the eighteen move across. The chapter
builds its requirement list fresh in the new product and can add or remove requirements at any
time, so which of the old ones are still in use no longer decides anything. The lesson stays:
a product that makes requirements easy to create and impossible to retire ends up with
eighteen of them.

### F-11: Dues are modelled in two ways at the same time

**What happens now.** Dues are both a requirement (with a target per account type and a
progress bar, alongside service hours) and a money record (with a balance, payments, a
ledger, invoices and budgets). The built-in "Dues & Fees" requirement carries settings that
no other requirement has: a three-way split into chapter, region and national shares, a due
date and time, an automatic late fee, and an option to accept online payment. **Seen**
(`docs/02-data-model/00-domain-model.md`).

**Why it is a problem.** A member's dues appear next to their service hours as though they
were the same kind of thing, which they are not. An officer looking for anything to do with
money has to know that it lives on a screen for editing requirements. And the chapter has a
second, chapter-created requirement also called "Dues", so it is not obvious which one is
authoritative.

**What should change.** Make dues their own part of the product, with its own screens: what
is owed, by whom, when it is due, what has been paid. Keep the progress bar on the member's
home page, because members do want to see it there, but drive it from the money record.

**What should improve.** Officers find money in one place. Members still see whether they
are paid up. Nobody has to know that dues are stored as a requirement.

**Settled by not mattering** (decisions D-03 and D-06). Dues gets its own screens in the first
release, and no requirements are brought across, so the chapter never has to work out which of
its two dues requirements was the real one.

### F-12: Nothing reaches a member unless an officer remembers to send it

**What happens now.** The system can send email to a filtered group through a four-step
process, send text messages, pin announcements to home pages, and show in-app notifications
when someone is credited. Each member has a detailed set of notification preferences,
including which activities they want to hear about and how far in advance to be reminded of
an event. **Seen** (`docs/02-data-model/00-domain-model.md`).

What is missing is anything that happens without someone pressing a button. Reminders before
an event, a chase when a member is behind, and a chase when a registration has been waiting,
all require an officer to remember to send them.

**Why it is a problem.** The work of noticing falls on officers. Members find out they are
behind at the point where it is too late to fix it.

**What should change.** Build two automatic messages first: a reminder before an event a
member has signed up for, and a summary near the end of term to any member who is short on a
requirement. Keep both as settings the chapter can switch off.

**What should improve.** Members are told in time to act. Officers stop being the only
mechanism by which anyone finds anything out.

**Still needs checking.** Which messages members would welcome and which they would find
excessive. The existing preference settings show what the vendor thought; they do not show
what this chapter's members want.

### F-13: Signing in is weaker than it should be

**What happens now.** A member signs in with an email address and password, or with a Google
or Facebook account. There is no second step of any kind, no authenticator app, and no
one-time code. **Seen** and **confirmed by the chapter**. The public registration form
limits a password to 15 characters. **Seen**
(`docs/04-system-design/02-auth-and-permissions.md`).

**Why it is a problem.** The accounts that hold every administrative permission are
protected by a password alone, and a limit on password length makes a password weaker rather
than stronger. The system holds members' addresses, phone numbers, birthdays and national
identification numbers.

**What should change.** Remove any limit on password length. Offer a second sign-in step
using an authenticator application, and require it for anyone holding a permission that can
change permissions or record money.

**What should improve.** The accounts with the most access are harder to take over, without making
sign-in harder for ordinary members.

**What the chapter decided.** The password length limit goes, and **the second sign-in step is
in the backlog rather than the first release** (decision D-09, 4 September 2026). Until it is
built, every account including the ones that can change permissions is protected by a password
alone. That is the same position as today, so the new product is no worse, and this finding
stays open rather than being closed by the decision.

### F-14: Credit is written with no approval and no way to review it

**What happens now.** Credit exists as soon as an officer completes an event or types it in.
There is no pending state and no review. **Worked out**, confidence medium, from the absence
of any approval screen across the records screens, the officer dashboard and the
notification text (`docs/04-system-design/03-flows.md`).

The audit log does record who did what, with names, record identifiers and a timestamp.
**Seen** (`docs/01-pages/viewlog.md`).

**Why it is a problem.** A single mistake, such as completing an event with the wrong
attendance list, moves many members' progress with nothing to catch it. The audit log records
that it happened but nothing draws attention to it.

**What should change.** Do not add an approval step for every credit; that would slow down
the normal case for a rare problem. Instead, make completing an event safe to run twice
without giving anyone double credit, and add a way to undo a completion that removes exactly
the credits it created.

**What should improve.** Officers can correct a mistake in one action instead of removing
credits one member at a time.

**Still needs checking.** How often this actually goes wrong. The audit log for one past
term would answer it.

### F-15: The words the system uses do not match each other

**What happens now.** The same thing has several names, and different things share a name.
The clearest cases are in section 7. **Seen** throughout.

**Why it is a problem.** New officers are trained by other officers, and inconsistent words
make that harder. It also makes the system harder to search and harder to write
documentation for.

**What should change.** Agree one word per concept, listed in section 7, and use it in the
new product's screens, its documentation and its training.

**What should improve.** One word per thing, so an officer explaining the system to their
successor is not also translating it.

**Still needs checking.** Whether the chapter's own words (for example calling a family
group a "line") should be kept as a chapter setting. Our recommendation is that they should.


### F-16: The system has to be memorised, and there is nothing to read

**What happens now.** **Reported:** the system is hard to navigate, especially for new
members, and it only becomes easier once you have memorised where things are (FB-03). There
are links that lead somewhere other than what their text says (FB-04). There is no guidance
on how to use it; changing the colour theme, for example, is possible but nobody can find it
(FB-07).

The screens support this. There are about ninety of them, some reachable only by typing an
address (**Seen**, `docs/INVENTORY.md`). At least one misdirecting link is confirmed: the
officer dashboard's panel for external links points at a different screen from the one that
actually edits those links (**Seen**, `docs/01-pages/00-index.md`).

**Why it is a problem.** Officers change every semester and are trained by the officer before
them. When knowledge lives only in someone's memory, it leaves with them. New members who
cannot find things stop trying, which is the group least able to ask.

**What should change.** Four specific things.

1. One navigation menu that names every screen a person is allowed to reach. Nothing
   reachable only by typing an address.
2. Every link checked to land where its text says. The one confirmed case above is fixed.
3. A short written guide kept with the product, covering the tasks in section 4, written for
   someone who has never used it.
4. Screens named after the task ("record a payment") rather than after the record
   ("manage dues").

**What should improve.** A member or a new officer can find the task they came for without
being shown by somebody else.

**Still needs checking.** Which tasks new members actually fail at. Watch two new members
try to find their own service hours and sign up for an event.

### F-17: Some features exist, and the people using the system believe they do not

**What happens now.** Three cases where the software has the feature and the people using it
report its absence.

| Feature | What the system has | What was reported |
|---|---|---|
| Announcements | A screen that pins a message to every member's home page (**Seen**, LEG-F-088) | There is no announcements feature at all, and announcements have moved to Discord where they get lost (FB-09, FB-10) |
| Custom profile fields | A field can be added to every profile, with its own type and its own view and edit permissions (**Seen**, LEG-F-014) | Profiles cannot hold custom fields, so the pledge trainers run a separate directory form every semester (FB-13, FB-14) |
| Document storage | A file store with folders, an audience per file, and links to files held elsewhere (**Seen**, LEG-F-104) | There is no central place for documents, and people constantly ask where the bylaws are (FB-11) |

One of the three has a partial explanation: the file store was switched off on this
chapter's subscription plan until the chapter upgraded on 29 August 2026 (**Seen**). The
other two were available throughout.

**Why it is a problem.** The chapter is paying for these features and paying a second time
in effort, by rebuilding them in Discord, in Google Forms and in a directory spreadsheet. A
feature nobody can find is worth the same as a feature that does not exist, and it costs
more, because it still has to be maintained and it still appears in every menu.

**What should change.** Treat "can someone find this without being told" as part of
finishing a feature, not as something to add afterwards. Concretely, for the new product:
every feature in the first release is reachable from the main menu in one step, appears on
the officer dashboard when it needs attention, and is named in the written guide from F-16.

Separately, before building any of the three above, open each one with an officer and check
whether the existing feature does what they need. It may be that announcements were never
missing, only invisible.

**What should improve.** The chapter stops keeping the same information in three places,
and the new product does not repeat the failure by building a feature nobody opens.

**Still needs checking.** Whether the three existing features actually meet the need or only
appear to. Thirty minutes with an officer and each screen settles it.

### F-18: The real attendance process happens outside the system

**What happens now.** **Reported:** attendance is collected using Google Forms plus a photo
for verification (FB-19). Progress is hard to read because officers update it late, often a
day or two after the event (FB-18). A member does not know whether they were credited until
an officer updates it by hand (FB-20).

This matches the design exactly. Credit is created only when an officer presses "complete
event" (**Seen**, LEG-F-055). There is nothing between attending and being credited, and no
way for a member to submit anything (**Seen**, F-14, F-08).

**Why it is a problem.** The most important number in the whole system, whether a member has
met their requirements, is produced by a process the system knows nothing about. Every step
is manual and can be missed. Members cannot see where they stand, so they ask an officer,
which is more work for the officer.

**What should change.** Move the whole process inside the product. The chapter described the
flow it wants (4 September 2026) and it is this:

1. **The event is created with an organiser and, if the organiser wants, one or more event
   chairs.** The organiser decides whether those chairs may approve attendance and close the
   event.
2. **The event says what it asks attendees to submit.** A short list of fields chosen when the
   event is created: a summary of what they did, a start and end time, a photograph, or just
   their name.
3. **A member who attended submits it**, and sees it immediately as waiting, next to their
   progress, with the credit it would earn.
4. **After the event, whoever may close it opens one list**, goes through the submissions,
   approves or rejects each one, and presses submit.
5. **Everyone approved is credited at once and the event closes.** Nothing is credited before
   that moment.

Three things go with it. **Every event closes by hand** for now; closing an event that awards
nothing automatically is in the backlog. **The whole submission step is optional per event**,
so an officer who prefers to run a form outside the system loses nothing. And **photographs
are visible only to the approver and the member who submitted them, and are deleted at the end
of the term** (decision D-14).

**What should improve.** A member knows the day after an event whether they have credit or
whether it is waiting. Officers approve one list instead of reading a spreadsheet and typing
each person in. Progress figures stop being one or two days out of date.

**Still needs checking.** How many events per term use the Google Form, and what the photo
is actually being checked for. Ask the pledge trainers and one service officer.

### F-19: A permission can only be attached to an officer title

**What happens now.** A person's permissions come from two places: their account type, and
the officer positions they hold (**Seen**). There is no way to give one person one
permission on its own. **Reported:** the chapter cannot give a non-officer, such as a
leadership chair, access to a requirement, so the system dictates how the chapter can
organise itself (FB-15).

The two fit together. Requirement permissions appear only in the two grids, and taking a
position also changes the person's account type, which changes what they owe (F-05).

**What already works here, and should not be rebuilt.** The link between a position and its
permissions is already the right shape. The chapter creates its own officer positions and
ticks which permissions each one gets, and any position can hold any combination of them
(**Seen**, task F in section 4). Nobody edits code to add an officer or to change what one
can do.

So the problem is narrower than "the positions are built into the software". What is fixed
is not which permissions a position can have. It is two other things: a permission can only
reach a person through a position or an account type, and the same set of permissions has to
be ticked again by hand for every position that needs it. There are 33 separate grids and no
way to name a set of permissions and reuse it, which is the most likely reason five of the
nineteen positions ended up holding every one (F-07).

**Why it is a problem.** To give one person one permission, the chapter has to invent an
officer position, which then changes that person's account type and their requirement
targets. Committees, one-term projects and helpers do not fit anywhere.

**What should change.** Three parts.

1. Keep permission sets, and allow a set to be granted either to a position or directly to
   one member for one term.
2. Never change a member's account type as a side effect of holding a position (F-05,
   LEG-F-068).
3. Allow a role to exist that is not an officer of the chapter, for example a committee
   chair, so the chapter's real structure can be recorded.

**What should improve.** The chapter describes its own structure instead of bending it to
fit the software.

**Still needs checking.** Which roles in the chapter today have no officer position. Ask for
the list; it is probably short and it will tell you how much flexibility is needed.

### F-20: The calendar only sends events out, never takes anything in

**What happens now.** An event page carries an "Add to Google Calendar" link (**Seen**,
`docs/01-pages/eventsignup.md`, LEG-F-130). **Reported:** events can be pushed to Google
Calendar but not pulled from it (FB-16), and there is no way to compare chapter events
against your real schedule without moving between tabs (FB-17).

**Why it is a problem.** Members decide what to sign up for by comparing two calendars by
hand, one event at a time. Chapter events compete with classes, work and everything else,
and the system can see none of it.

**What should change.** Two steps, in this order, because the first is small and the second
is not.

1. **Publish a calendar feed the member subscribes to once.** Chapter events then appear in
   their own calendar and stay up to date on their own. This solves most of FB-17 and costs
   little.
2. **Decide separately whether the product should read a member's personal calendar**
   (plan document, decision D-13). Reading someone's schedule means holding their personal
   information, and matching events to free time is a much larger piece of work.

**What should improve.** A member sees chapter events beside their classes without opening
the system at all.

**Still needs checking.** Whether the one-way subscription is enough. Ask five members
whether "chapter events appear in my own calendar automatically" would solve the problem.

### F-21: The screens are hard to tell apart

**What happens now.** **Reported:** every screen looks the same and only the colours differ
(FB-05), and the interface reads as early-to-mid 2010s (FB-06). Appearance was deliberately
not recorded during the review, so there is no direct evidence either way. What is confirmed
is the structure that produces it: the whole system is one page that changes according to a
keyword in the address, so every screen shares one layout (**Seen**).

**Why it is a problem.** When screens look alike, people navigate by memory rather than by
reading, which is exactly what FB-03 describes. It also makes it hard to tell a screen that
changes something from one that only shows it.

**What should change.** This is a design brief rather than a data decision, and it should go
to whoever designs the screens with two specific requirements: each of the six tasks in
section 4 gets a layout a person can recognise without reading the title, and a screen that
changes something looks different from a screen that only shows something.

**What should improve.** Someone who has used a screen once recognises it the next time.

**Still needs checking.** Nothing about the report itself. What "it looks dated" costs in
practice is better measured through the navigation problems in F-16 than through opinions
about appearance.

### F-22: Two security claims, one confirmed and one deliberately not tested

**What happens now.** Two claims were reported.

The first is that there is no second step when signing in (FB-01). That is confirmed, both
from the screens and by the chapter, and it is finding F-13.

The second is that the system's endpoints are effectively open, so anyone could call them
(FB-02). **This is not verified.** The review had only an administrator account, and an
administrator is almost never refused, so nothing in it tests whether the system checks
permissions on the server rather than only hiding buttons (**Seen**,
`docs/04-system-design/02-auth-and-permissions.md`).

**Why it matters.** If the claim is right, the permission settings in the current system are
presentation only, and member records (addresses, phone numbers, birthdays, national
identification numbers) are readable by anyone who knows the address. If it is wrong,
nothing changes.

**What should change.** Do not test this against the live system. Probing a running service
that holds other people's personal data is not ours to do, and this project's first rule is
that it changes nothing on the live site. Treat the answer as settled for the new product
instead: every permission is checked on the server before the action runs (rule R-12 in the
plan document), no screen relies on a hidden button to stop anyone, and each check has a
test that fails if it is removed.

**What should improve.** This is about the new product, not the current one.

**Still needs checking.** If the chapter wants to know whether the current system has this
problem, the question goes to the vendor in writing. It is not something to find out by
trying.

### F-23: What a member sees on signing in is fixed, and it is missing things

**What happens now.** A member signing in lands on a home page that shows their account
status, upcoming events, shortcuts for officers, a progress bar for each requirement that
applies to them, and their dues due date until it is paid. Announcements appear here too,
when the chapter uses them (all **Seen**, `docs/01-pages/00-index.md`, LEG-F-038, LEG-F-073,
LEG-F-088).

**Reported:** the page is not useful, and there is no way to change it to show what matters
to this chapter. What a member wants on signing in is the events they have signed up for,
announcements, documents that officers have recently uploaded, and other things the chapter
would choose (FB-08).

Comparing the two, three separate problems sit inside one complaint.

| What is wanted | What exists today |
|---|---|
| The events **I signed up for** | The page shows upcoming events. Whether that means all of them or only the ones this member signed up for is **not known**, and it matters, because they answer different questions |
| Announcements | The feature exists and can pin a message to every home page, but the chapter is not using it and believes it does not exist (F-17) |
| Documents officers recently uploaded | Does not exist. The file store is a separate screen with no view of what is new (LEG-F-104) |
| Anything else the chapter decides matters | Not possible. The page is fixed. No screen was found that changes what appears on it |

**Why it is a problem.** The first screen a member sees is the only screen most members will
ever look at. If it does not answer their question, they either ask an officer or stop
signing in. And because the page cannot be changed, the chapter has no way to fix that, even
when it knows exactly what is missing.

**What should change.** Build the page as a set of separate blocks rather than as one fixed
layout, and let the chapter choose which blocks appear and in what order. Start with these
blocks: announcements, the events this member has signed up for, their progress on each
requirement that applies to them, what they owe, and documents added recently.

This is a "cheap now, expensive later" decision, like storing membership per term (F-09). A
page built from blocks on the first day can be made configurable in an afternoon. A page
built as one fixed layout has to be taken apart first.

Letting each **member** arrange their own version of the page is a separate and larger step.
Our recommendation is to leave it until the chapter has been choosing the blocks for a term
and it is clear whether anyone wants more than that (plan document, ASK-06).

**What should improve.** A member signs in and sees the four or five things this chapter has
decided matter, in the order it decided. When that turns out to be wrong, an officer changes
it without anyone writing code.

**Still needs checking.** Two things. First, whether the current home page lists all upcoming
events or only the ones the member signed up for. Open it with a member. Second, which four
or five blocks the chapter would choose. Ask two officers and two members separately, and
compare the answers, because they may not want the same page.

---

### F-24: Every position is an officer position, so there is no way to involve anyone else

**What happens now.** The system holds a flat list of 19 positions, 18 marked as officer
positions and 1 as an advisor position (**Seen**). There is no committee, no team, and no way
to say that one position sits under another. No screen recording anything of the kind was
found anywhere in the system.

**Many of those 19 are named as chairs**, for example the Equity and Inclusion Chair, the
Philanthropy Chair and the Fundraising Chair, and every one of them is an officer position
(**Seen**, `docs/04-system-design/02a-privilege-lists.md`). The chapter has confirmed this:
today a chair **is** an officer. So "chair" is a word in a position's name, not a kind of
position, and the two must not be treated as opposites anywhere in the new product.

One thing in the system looks like a workaround, and one earlier reading of it was wrong.

- **The committee credit permission is held by 14 of the 19 positions**, far more than any
  other, apparently used as a general "may give credit" permission rather than for its named
  purpose (**Seen**, F-07).
- **A free-text chair title on a member.** The member's status panel offers a chair position,
  typed in as free text, separate from the officer position checkboxes (**Seen**). It carries
  no permissions, because permissions come only from the two grids. An earlier version of this
  document recorded its purpose as settled, reading it as the name of a chair who holds no
  officer position. **That was too quick.** The chapter has no chairs who are not officers, so
  it is unlikely to be using the field that way, and the field's purpose is back to **not
  known**. Ask whether anyone has ever filled it in.

**What the chapter actually needs to record.** Explained by the chapter, 4 September 2026:

- **Some chairs are officers and some are not.** Today all of them are. The chapter wants to
  keep chairs on the executive board where that is right, and also have chairs who sit outside
  it. Being a chair and being an officer are two separate facts about a position.
- **Anyone in the chapter can hold a position.** Holding one does not by itself make somebody
  an officer or a member of the executive board.
- A chair sits under a committee or a team, and that committee or team has a head, usually an
  officer.
- More than one person can hold the same position. The current system already allows this:
  19 positions produced 26 assignment rows, because several positions are held by more than
  one person (**Seen**, `docs/GAPS.md`).
- A chair may be allowed to create events. Whether that needs approval from an officer first
  should be a setting, not a fixed rule.
- The chapter wants most of its members involved through positions, without most of them
  being on the executive board.

**Why it is a problem.** Almost none of that can be written down. The structure lives in
people's memories and in a free-text field. The permissions that should follow from holding a
chair have to be granted through an officer position instead (F-19), so either a chair is
made an officer to give them access they need, or they get a title and no access. Neither is
what the chapter means.

**What should change.** Record the structure as data the chapter controls: named groups the
chapter defines (an executive board, committees, teams, or whatever the chapter calls them),
positions that sit inside a group, more than one holder per position, and permissions that
can be granted to a group, to a position, or to one person. The model is set out in the plan
document, section 4.6.

Two things in that model are worth naming here because they are what makes it survive a
change in how the chapter organises itself. The names of the groups are typed in by the
chapter, not built into the software. And whether somebody is an officer is answered by which
group their position sits in, rather than by a flag on their record, so a chapter that
reorganises does not need anyone to change the software.

**What should improve.** The chapter's real structure is written down. A chair who is not an
officer can be given exactly the access their job needs, and nothing more. Broad involvement
stops requiring an inflated executive board.

**Settled, 4 September 2026.** How many committees and chairs there are is not a design
input. There may be one committee or many, one chair or twenty, and the same is true of any
other chapter that uses this software. The group layer is therefore always fully present and
no screen assumes a number (plan document, decision D-15).

---

### F-25: An event can belong to nothing, so nobody in particular is responsible for it

**What happens now.** An event does not have to be connected to anything. The create-event
form's starting state reads "This event will not count towards any requirement", the calendar
carries an eighteenth filter called "Other Events" alongside its seventeen requirement
filters, and there is a separate officer permission called "Manage Other (Non-Associated)
Events" (**Seen**, `docs/02-data-model/00-domain-model.md`,
`docs/04-system-design/02a-privilege-lists.md`).

That last one is the clearest evidence. The product had to invent a permission for events
that belong to no requirement, because the ordinary way of deciding who may manage an event is
to ask which requirement it counts towards. On this chapter only 7 of the 19 positions hold it.

**Why it is a problem.** Two things follow from an event belonging to nothing.

- **Nobody in particular manages it.** For every other event, the officer who manages the
  requirement manages the event. For these, the chapter had to hand out a separate permission,
  and it went to two positions plus the five that hold everything (F-07).
- **It cannot be found.** An event that counts towards nothing sits in a bucket called "Other
  Events" with everything else that counts towards nothing. An event run by the Fellowship
  committee and a talk run by the Academic chair land in the same undifferentiated list.

**What should change.** Separate two ideas that the current system runs together.

| Idea | Rule |
|---|---|
| **What the event is mainly about** | Every event names exactly one **primary** requirement. This is required, and it is what decides where the event appears on the calendar and who is responsible for it |
| **What else it counts towards** | An event may name further requirements as well. A fellowship event that also earns leadership credit names Leadership as a secondary |
| **What the event awards** | Each of those lines carries an amount, and the amount may be zero. An event whose primary is Fellowship Events with an amount of zero is still a fellowship event: it is about fellowship, it sits in the fellowship lane on the calendar, and it earns nobody anything |

**A requirement doing this job is what people already call an event type.** "A fellowship
event" means an event whose primary requirement is Fellowship. That is the natural way to
speak about it and the new product should use it. It also means the chapter never maintains a
second list of event types alongside its requirements. This chapter's event types are its
eighteen requirements: Fellowship Events, Service Hours, Meetings, Leadership Credits and the
rest. If a chapter ever needs a type that is not one of its existing requirements, it creates a
requirement with a target of zero for every account type. No progress bar appears, and events
can still be filed under it.

**The calendar and a search answer two different questions, so they behave differently.** On
the calendar an event appears once, under its primary requirement, because a month that shows
the same event in three lanes looks busier than the month really is. A search for a
requirement returns every event that credits it, primary or secondary, because somebody
looking for a way to earn leadership credit wants all of them. The chapter's example: search
for leadership credit and a fellowship event appears, because leadership is one of its
secondary lines.

**How the current system decides this is not known.** Its event form has repeating credit rows
with no primary among them (**Seen**), and nothing observed says which calendar filter a
multi-credit event appears under. It does not matter, because naming a primary removes the
question.

So an event that earns nothing is filed under the requirement it is about, with an amount of
zero,
rather than an "Other" event. The chapter has confirmed this is what it wants (4 September
2026): an event is always about at least one requirement, and whether it earns credit is a
separate question.

**What should improve.** Three things follow.

- Every event has an obvious owner: whoever manages one of the requirements it belongs to.
  The special permission for unattached events is no longer needed.
- The "Other Events" bucket disappears, and every event is findable under something a member
  recognises.
- When a chair proposes an event, the chapter already knows which officer would naturally
  review it, because the event names its area (F-24).

**Still needs checking, and it blocks nothing.** Old events that belong to nothing do not
have to be sorted out by hand. If events come across at all, any that belong to nothing can be
given one requirement the chapter names during the import, so this rule never holds up the
move.

The only thing worth knowing, and only eventually, is how common these events are. If most of
what this chapter runs today counts towards nothing, then asking officers to name an area for
every event is a real change in habit and should be introduced as one. Counting them under
the "Other Events" calendar filter would answer that.

---

## 6. Every feature the current system has, and what to do with it

### How to read these tables

- **ID** never changes, so other documents can point at one row.
- **Where it is today** gives the screen a user would recognise, with the system's own
  keyword in brackets for traceability.
- **Treatment** uses one of the six words defined in section 1.2.
- **Reason, and what replaces it** gives the reasoning in one line, and names the
  replacement wherever the treatment is Drop, Replace or Keep, changed.
- **Risk if dropped** is filled in for rows treated as Drop, Later or Replace. Rows we
  recommend keeping show a dash.
- **Owner decision** is empty on purpose. It is for the product owner, not for us.

There are 131 features listed. The coverage check in section 8 shows where the list came
from and how it was checked for holes.

### 6.1 Membership and the roster

| ID | Feature | What people use it for | Where it is today | Treatment | Reason, and what replaces it | Risk if dropped | Owner decision |
|---|---|---|---|---|---|---|---|
| LEG-F-001 | Member profile with contact details | Reaching a member; knowing who they are | Member record, profile panel (`managebrother`) | Keep | The core record everything else points at | – | |
| LEG-F-002 | Public registration link | Letting people join without an officer typing them in | Registration page (`register.php`) | Drop | The chapter decided the new product is invite-only (decision D-08). Somebody joins because an officer invites them or imports them, not by finding a link | Nobody can put themselves forward to join. For a chapter that recruits in person, that is how it already works | |
| LEG-F-003 | Approval queue with skip, reject or assign a type | Deciding who gets in, and as what | Pending approvals (`userspending`) | Drop | There is no queue, because there is nothing to approve. Invitation is the decision (decision D-08). This also removes the problem the review found, of seven people waiting with nobody responsible | The chapter loses a record of who asked to join and was turned down. It never had one worth keeping | |
| LEG-F-004 | Add a member by typing their details | Adding someone who did not register themselves | Add members (`inviteuser`) | Keep | Officers need a route that does not depend on the member acting | – | |
| LEG-F-005 | Find a person already in the shared cross-chapter database | Transfers from another chapter | Add members (`inviteuser`) | Out of scope | Only works because one company runs every chapter's system | A transfer student is typed in again by hand, which takes a few minutes | |
| LEG-F-006 | Import a roster from a spreadsheet file | Loading a whole roster at once | Add members (`inviteuser`) | Keep | Moved into the first release. With no data migration (decision D-06) and no public registration link (D-08), importing a file is how the system gets its members, and it is used again each autumn for a pledge class | – | |
| LEG-F-007 | Roster grouped by account type | Seeing who is in the chapter | Roster (`brothers`) | Keep | The most used read-only screen | – | |
| LEG-F-008 | Account types the chapter defines, each mapped to a national status | Saying what kind of member someone is, in the chapter's own words | Account types (`managestatuses`) | Keep | Chapters really do invent their own categories, such as this chapter's Half-Active | – | |
| LEG-F-009 | Change one member's account type by hand, with a reason and a choice to notify them | Correcting a mistake, or recording a change of standing | Member record, status panel | Keep | The reason field and the notify choice are both worth copying | – | |
| LEG-F-010 | Membership stages and the bulk "Graduate Members" button | Moving a whole graduating year to alumni at once | Membership stages (`viewMembershipStages`) | Keep, changed | Replace with a term rollover that sets each member's account type for the new term, so the previous term's record survives (F-09) | – | |
| LEG-F-011 | Roster verification page: confirm or correct every member at once | An annual audit of who is what | `verifyRoster` | Later | Useful, but only once the per-term record exists | Officers correct account types one at a time | |
| LEG-F-012 | Remove a member from the chapter while their account survives elsewhere | Someone leaves this chapter but stays in the organisation | Member record | Keep, changed | For one chapter this becomes: end their membership, keep the record and the history | – | |
| LEG-F-013 | A privacy setting on each profile field, five levels | Members controlling who sees their phone number and address | Profile editor | Keep, changed | Two of the five levels exist only so the software vendor's own staff can see data. Three levels are enough: everyone, members only, officers only | – | |
| LEG-F-014 | Chapter-defined extra profile fields, with separate view and edit permissions | Recording something this chapter cares about that the product does not offer | `createuserfield` | Keep | First release. The pledge trainers run a separate directory form twice a year because they believe profiles cannot hold this (FB-13, FB-14, F-17), so it pays for itself in the first term | – | |
| LEG-F-015 | Profile history: every previous value of every field is kept | Nothing a user asked for | Profile editor | Drop | A member who corrects their phone number or their name has not actually removed the old value. Keep changes in the audit log instead, where they are bounded and reviewable | Losing the ability to see what a field used to say, outside the audit log | |
| LEG-F-016 | A member number per chapter | The chapter's own numbering of its members | Member record | Keep, changed | One chapter means one number per member | – | |
| LEG-F-017 | One person belonging to several chapters, with one marked primary | People who move between chapters | Profile editor, affiliations | Out of scope | Only meaningful across chapters | – | |
| LEG-F-018 | A dated activity timeline per member, with manual entries | Seeing what has happened to one member over time | Member record, timeline | Later | Useful once there is enough history to look at | Officers reconstruct a member's history from separate screens | |
| LEG-F-019 | Files attached to one member, with folders and a sharing setting | Storing a form or a document about a member | Member record, files panel | Later | Needs file storage, which is work | Documents live in email or a shared drive instead | |
| LEG-F-020 | Education and work history on a profile | Alumni networking | Profile | Drop | Serves a directory this chapter has not been shown to use | Alumni networking is not supported. Reversible later | |
| LEG-F-021 | Alumni directory searchable by employer, industry or place | Alumni finding each other | `viewAlumni` | Later | 523 of 589 records are alumni, so the audience exists, but no evidence of use was found | Alumni have no directory. See "still needs checking" in section 3.5 | |
| LEG-F-022 | Big and little relationships, shown as a family tree; siblings worked out from shared bigs | The chapter's mentoring structure | `familytree.php`, family panel | Later | Actively used on this chapter, and small to build, but not needed to run a semester | The mentoring structure is recorded somewhere else | |
| LEG-F-023 | Named family groups, with wording the chapter chooses ("lines" here) | Grouping members into named families | `managefamilies`, `editfamilysettings` | Later | This chapter has defined none: all 72 members sit in a group called "no line listed" | Nothing, on current evidence. It is unused today | |
| LEG-F-024 | Personal family: a member's real relatives, who need not be members | Emergency contacts and family links | Member record, family panel | Drop | Different from the mentoring structure and not shown to be used | No record of relatives. Emergency contacts would need their own field if wanted | |
| LEG-F-025 | LEADS record: sessions a member attended, with date and place | A national leadership programme | `editapoleads` | Drop | Belongs to the national organisation's programme, not to chapter operations | A chapter that runs this programme records it elsewhere | |
| LEG-F-026 | A free-text chair title on a member, separate from officer positions | Not established. It may be for naming a chair who holds no officer position, but this chapter has none, so it probably does not use it that way (F-24) | Member record, status panel | Replace | Whatever it is for, a name typed into a box carries no permissions. Replaced by a real position inside a group, which can carry permissions and be held by several people | Low. Ask whether anyone has ever filled it in before assuming nothing is lost | |

### 6.2 Requirements and credit

| ID | Feature | What people use it for | Where it is today | Treatment | Reason, and what replaces it | Risk if dropped | Owner decision |
|---|---|---|---|---|---|---|---|
| LEG-F-027 | The chapter writes its own requirements | Setting what members have to do this term | Requirements (`managerequirements`) | Keep | Rules differ by chapter and change over time, so they must be settings, not code | – | |
| LEG-F-028 | A target per requirement per account type, fractions allowed | Asking less of an associate member than an active one | Edit requirement | Keep | Directly used here: 7.5 service hours for the Half-Active type | – | |
| LEG-F-029 | Splitting a requirement into named parts, each with its own target | This chapter splits service four ways | Edit requirement | Keep | In active use | – | |
| LEG-F-030 | Marking each credit as earned at a chapter event or outside it, with a cap on the outside share | Making sure members turn up to chapter events | Create requirement | Keep | A real chapter rule, and cheap to build | – | |
| LEG-F-031 | Counting a requirement as a share of all events of that type, rather than a fixed total | "Attend 60% of meetings" | Create requirement | Later | A second way of measuring, useful but not needed first | Chapters that measure attendance as a percentage set a fixed number instead | |
| LEG-F-032 | Point trackers: a requirement with no targets, used as a plain counter | Counting something without requiring it | `createPointTracker` | Drop | Unused on this chapter. A requirement with a target of zero does the same thing | Nothing on current evidence | |
| LEG-F-033 | Completing an event writes credit for everyone on the list | The main way credit is created | Complete event (`eventcomplete`) | Keep | The best decision in the product (task B) | – | |
| LEG-F-034 | An officer types in credit for a member | Work done outside a chapter event, and corrections | Member's record screen, "add record" | Keep | Every chapter has exceptions. Without this, officers keep their own spreadsheet and stop using the system | – | |
| LEG-F-035 | A member records their own credit, controlled per requirement and per account type | Members entering their own outside hours | Same screen, permission-controlled | Drop | Decision D-01: credit comes from an event, or from an officer or chair who holds the permission for that requirement. A member never writes credit. What a member can do is submit **attendance** at an event with proof, which an officer approves, and the credit then comes from the event | Members cannot enter hours worked outside a chapter event. An officer enters those | |
| LEG-F-036 | A member's own progress, over this term, this academic year, this calendar year or all time | "How am I doing" | Member's record screen | Keep | The question every member has | – | |
| LEG-F-037 | Every member's progress on one requirement, over any date range | "Who is behind" | Progress screen (`managerecords`) | Keep | The question every officer has | – | |
| LEG-F-038 | Progress bars on the member's home page | Seeing everything at once on arrival | Home page | Keep | The first thing a member sees; it should stay | – | |
| LEG-F-131 | The member home page itself: a fixed set of panels that nobody can change | The screen a member lands on when they sign in | Home page (no keyword) | Keep, changed | Build it from separate blocks and let the chapter choose which appear and in what order. The content is close to right; the fact that it cannot be changed is the problem (F-23) | – | |
| LEG-F-039 | Deleting a credit | Correcting a mistake | Records screens | Keep, changed | Record who deleted it and why, in the audit log | – | |
| LEG-F-040 | Blocking manual entry for some requirements (meeting credit must come from a meeting) | Stopping meeting attendance being invented | Member record, records panel | Keep, changed | Make it a visible setting on each requirement, with the reason shown on screen, rather than a rule that appears only in help text | – | |
| LEG-F-041 | Creating a requirement also creates the matching event type and two permissions | Setting up a new kind of credit in one action | Create requirement | Keep, changed | Keep the automatic permission, drop the merging of "requirement" and "event type". They are different ideas that happen to be created together (section 7) | – | |

### 6.3 Events

| ID | Feature | What people use it for | Where it is today | Treatment | Reason, and what replaces it | Risk if dropped | Owner decision |
|---|---|---|---|---|---|---|---|
| LEG-F-042 | Create an event with a time, a place and a description | Telling members what is happening | Create event (`eventcreate`) | Keep | – | – | |
| LEG-F-043 | One event awarding several different credits | A meeting that is also a required event | Create event | Keep, changed | In active use here; one event awards three credits. What changes is that one of them is marked as the primary, which decides the calendar lane and the owner, and any line may carry an amount of zero (F-25) | – | |
| LEG-F-044 | A repeat setting that creates several separate events | Weekly meetings | Create event | Keep, changed | Keep the convenience, but record that the copies belong together so all of them can be changed at once | – | |
| LEG-F-045 | Splitting an event into shifts, with credit per shift or per event | Long events staffed in blocks | Create event | Drop | Adds a second layer to every credit calculation. No evidence of use here | Long events are entered as several events | |
| LEG-F-046 | Signing up for an event, and cancelling | Saying you will be there | Event page | Keep | – | – | |
| LEG-F-047 | Three separate moments: sign-ups open, lock, and close | Stopping late changes before an event | Create event | Keep, changed | Two moments (opens, closes) cover the need. The third has to be explained to every new officer | – | |
| LEG-F-048 | A limit on attendees, a waiting list, and a message when a place opens | Events with limited places | Create event, notifications | Later | Real, but only matters for events that fill up | Officers manage a full event by hand | |
| LEG-F-049 | Recording that a member is driving and has spare seats | Getting people to a service site | Sign-up | Drop | Better served by whatever messaging tool the chapter already uses | Lift sharing is arranged outside the system | |
| LEG-F-050 | A note attached to a sign-up | "I can only stay an hour" | Event page | Later | Small and useful; not needed first | Members send the same note by message | |
| LEG-F-051 | Up to two event coordinators, who can be given extra credit for running it | Recognising and empowering the people running an event | Create event | Keep, changed | Moved into the first release, and reshaped (decision D-08 on events). Every event has an **organiser**, the person who created it, and any number of **event chairs** the organiser assigns. The organiser decides per event whether the chairs may approve attendance and close it. The current system allows two coordinators and controls the same thing through a chapter-wide permission instead | – | |
| LEG-F-052 | Six levels of who can see an event, and six of who can sign up | Restricting an event to officers, or opening it to the public | Create event | Keep, changed | Three levels are enough for one chapter: officers, members, public. The other three exist for the region and the national office | – | |
| LEG-F-053 | Five settings for when the attendee list becomes visible | Hiding who else is coming | Create event | Drop | Five settings for a question most chapters answer once | Everyone who can see the event can see who is coming | |
| LEG-F-054 | An officer adds a member to the attendance list by hand | People who came without signing up | Event page | Keep | Happens at every event | – | |
| LEG-F-055 | Completing an event awards the credit | Turning attendance into progress | Complete event | Keep, changed | Renamed to closing the event, and it now also approves the attendance in the same action. Every event closes by hand; automatic closing is in the backlog. Make it safe to press twice without doubling anyone's credit, and reversible in one action (F-14, F-18) | – | |
| LEG-F-056 | A queue of events that have happened and are waiting to be completed | Not forgetting the step that creates credit | Pending events | Keep | The single most useful thing on the officer dashboard | – | |
| LEG-F-057 | Event groups: a series counted as one event | A semester-long project | Create event | Drop | Rarely needed, and it changes how every credit total is worked out | A series is entered as several events, or as one event with hours | |
| LEG-F-058 | Events that award no credit at all | Anything the chapter runs that is not tracked towards a requirement | Create event | Keep, changed | Half of what a chapter puts on a calendar earns nothing, so this stays. What changes is that the event still names at least one requirement it belongs to, so it has an owner and can be found. The "Other Events" bucket and the separate permission for managing unattached events both disappear (F-25) | – | |
| LEG-F-059 | A month calendar with a filter for each requirement | Seeing the term laid out | Calendar (`vieweventcalendar`) | Later | A second way to look at the same events; no new information. In the new product each event appears in exactly one filter, its primary requirement, and the "Other Events" filter is gone (F-25) | Members read a list instead of a calendar | |
| LEG-F-060 | Files attached to an event, deleted automatically after six months | Sign-in sheets and instructions | Event attachments | Drop | Needs file storage, and the automatic deletion surprises people | Documents are shared by email or a shared drive | |
| LEG-F-061 | Checking members in from a phone at the event | Taking attendance on the day | Mobile check-in (charged as an extra by the vendor) | Later | Second release. It removes the step that is failing today (F-18), where attendance is collected on Google Forms and typed in later | Attendance keeps being collected outside the system | |
| LEG-F-062 | Emailing or texting everyone signed up to one event | "The location has changed" | Event admin actions | Later | Depends on messaging being built first | Officers use their existing group chat | |
| LEG-F-063 | Deleting an event | Cancelling something | `eventdelete` | Keep, changed | Say what else will change before deleting, and decide what happens to credit already given (F-02) | – | |
| LEG-F-130 | An "add to Google Calendar" link on an event | Putting one event into your own calendar | Event page | Keep, changed | Replace one link per event with a calendar feed the member subscribes to once, so every chapter event appears in their own calendar and stays up to date (F-20) | Members copy each event across by hand, as they do today | |

### 6.4 Roles and permissions

| ID | Feature | What people use it for | Where it is today | Treatment | Reason, and what replaces it | Risk if dropped | Owner decision |
|---|---|---|---|---|---|---|---|
| LEG-F-064 | Officer positions the chapter defines, marked as officer, advisor or both | The chapter's own list of jobs | Officer positions | Keep, changed | Positions sit inside a group the chapter names, so "is this an officer" is answered by which group it is in rather than by a flag (F-24). The flag stays only to say whether a position is filled by a student member or by an advisor, and it becomes changeable after creation. Today it cannot be changed | – | |
| LEG-F-065 | A grid of 39 permissions per officer position | Deciding what each officer may manage | Position permissions | Keep, changed | Replace the copied grids with a small number of named permission sets that positions point at (F-07) | – | |
| LEG-F-066 | A grid of 40 permissions per account type | Deciding what an ordinary member may do | Account type permissions | Keep, changed | Same change, plus write every permission positively rather than as "hide" or "disallow" (F-06) | – | |
| LEG-F-067 | Assigning members to positions on one page, saved once, sending activation emails | Officer handover at the end of term | Assign officers (`defineofficers`) | Keep, changed | Record assignments per term instead of overwriting, and separate sending the email from saving the assignment (F-09). Several people holding one position already works here (19 positions, 26 assignment rows) and is kept (F-24) | – | |
| LEG-F-068 | Taking a position automatically changes the member's account type to "Officer" | Nothing a user asked for | Assign officers | Drop | It changes what the member owes without anyone deciding it should, and makes some real situations impossible to record (F-05) | Officers stop being identifiable by account type. Replaced by "holds at least one position" | |
| LEG-F-069 | Creating a requirement automatically creates a permission to manage it | Letting a Service Vice President manage service hours only | Both grids | Keep | This is what makes narrow permissions possible without a developer | – | |
| LEG-F-070 | Administrator status as a permission, not a separate kind of account | Granting full access to a position | The "configure site settings" permission | Keep | Correct design. Add a warning when it is granted, and log every change to it | – | |

### 6.5 Money

| ID | Feature | What people use it for | Where it is today | Treatment | Reason, and what replaces it | Risk if dropped | Owner decision |
|---|---|---|---|---|---|---|---|
| LEG-F-071 | A dues amount per account type | Charging different members different amounts | Edit the dues requirement | Keep, changed | Move it to its own dues screen instead of an edit-requirement screen (F-11) | – | |
| LEG-F-072 | Splitting each dues payment into chapter, region and national shares | Passing money up the organisation | Edit the dues requirement | Out of scope | A single chapter has one destination | The chapter works out the shares outside the system, as many already do | |
| LEG-F-073 | A due date shown on the member's home page until they pay | Reminding members | Edit the dues requirement | Keep | Cheap, and it works | – | |
| LEG-F-074 | An automatic late fee on the due date | Charging late payers | Edit the dues requirement | Drop | Never used by this chapter (confirmed). Automatic charging of real money needs care that its value does not justify | Late fees are charged by hand with the existing one-off fee | |
| LEG-F-075 | Recording a payment: member, method, amount, note | The Treasurer's main task | Dues and fees | Keep | – | – | |
| LEG-F-076 | Charging a one-off fee to a member | Fines and extra charges | Dues and fees | Keep | – | – | |
| LEG-F-077 | A list of every member with what they owe | Chasing money | Dues and fees | Keep | – | – | |
| LEG-F-078 | A ledger of money in and out, with export | Treasurer reporting | Transactions | Later | Real value, but a chapter can run a semester with balances alone | The Treasurer keeps the ledger in a spreadsheet, as many do | |
| LEG-F-079 | A budget per officer position, measured against the ledger | Committee spending limits | Budgets | Later | Depends on the ledger existing first | Budgets are tracked in a spreadsheet | |
| LEG-F-080 | Invoices per member, moving through open, pending, paid and void | Formal billing | Invoice screens | Later | More formal than most chapters need, but it is how larger chapters bill | Members are told what they owe by message | |
| LEG-F-081 | Paying dues online by card | Members paying without meeting the Treasurer | Payment processors | Drop | Never used by this chapter (confirmed). Card payment brings a payment provider, rules about card data and refund handling. The vendor charges 3.9% plus 30 cents | Members pay by cash, cheque or transfer, which is what happens today | |
| LEG-F-082 | Fundraising funds, campaigns and donation records | Fundraising and alumni giving | Funds and campaigns | Drop | A separate area of work aimed at alumni giving | Fundraising is tracked outside the system | |
| LEG-F-083 | A shop with products, orders and shipping | Selling merchandise | Store (not enabled here) | Drop | Not switched on for this chapter, which is why it is reported as missing (FB-21). A shop is a separate product from a chapter management system, and selling gear online means taking card payments (LEG-F-081). Students have asked for one, so this is decision D-12 | The chapter has no automated way to sell gear. This is a real request, not an assumption | |
| LEG-F-084 | Invoices sent to this chapter's members by other bodies | Region and national billing | External invoices | Out of scope | Only exists because several bodies share one system | – | |

### 6.6 Telling people things

| ID | Feature | What people use it for | Where it is today | Treatment | Reason, and what replaces it | Risk if dropped | Owner decision |
|---|---|---|---|---|---|---|---|
| LEG-F-085 | Email to a chosen group of members, chosen through a four-step process, with the member's name inserted into the text | Chapter-wide announcements | Bulk email | Later | The valuable half is choosing who to send to. Sending is a small piece | Officers copy addresses into their own email | |
| LEG-F-086 | Saved audiences, and filtering on any member field | Reusing "everyone who is behind on service" | Named in the release notes | Later | Only worth building once bulk email exists | The filter is rebuilt each time | |
| LEG-F-087 | Bulk text messages | Urgent messages | Text message screen (`smsform`) | Drop | Costs money per message, and every chapter already has a group chat | Urgent messages go through the chapter's existing group chat | |
| LEG-F-088 | Announcements pinned to every member's home page | Something everyone must read | Announcements | Keep | Moved into the first release on the strength of the feedback. The feature exists today and is reported as absent (FB-09, F-17); announcements have moved to Discord and get lost there (FB-10) | – | |
| LEG-F-089 | A notification when a member is credited, saying what they received | Members knowing their hours were recorded | Notifications | Keep | This is what makes members trust the numbers | – | |
| LEG-F-090 | Per-member notification settings, including how far ahead to be reminded of an event | Members controlling what they receive | Contact preferences | Keep, changed | Keep the per-activity switches. Drop the grid of national, region and chapter against email, call, text and post | – | |
| LEG-F-091 | A consent grid of source (national, region, chapter) against channel (email, call, text, post) | National organisation contact consent | Contact preferences | Out of scope | Three of the four channels and two of the three sources do not exist for one chapter | The chapter cannot record national contact consent in this system | |
| LEG-F-092 | An anonymous comment form to officers, with comments visible for 30 days | Members raising something without naming themselves | Comment form | Replace | Not a feature of its own. Decision D-07: this is one form among many, so it is built on the form tool when that arrives (LEG-F-106). Until then the chapter links to an external form. On this chapter only the "Bad Standing" account type can use the current one, which appears to be a configuration mistake (F-07) | – | |
| LEG-F-093 | Private messages between two members | Members contacting each other | Messages | Drop | Every member already has three ways to message another member | Members use the messaging tools they already use | |
| LEG-F-094 | Sending an email automatically when something happens (a birthday, a submitted form) | Messages nobody has to remember to send | Named in the release notes | Later | Two of these are worth building early: an event reminder, and a warning to members who are behind near the end of term (F-12) | Officers have to remember to send every message | |

### 6.7 Recognition

| ID | Feature | What people use it for | Where it is today | Treatment | Reason, and what replaces it | Risk if dropped | Owner decision |
|---|---|---|---|---|---|---|---|
| LEG-F-095 | Awards the chapter defines, plus five built-in service keys | Recognising members | Define awards | Later | Recognition matters, but the chapter can run a semester without it | Awards are recorded outside the system | |
| LEG-F-096 | An officer grants an award to a member directly | The usual way an award is given | Grant award | Later | The simpler of the two routes, and the one to build if either is built | – | |
| LEG-F-097 | Running a vote for an award, with eligibility rules and write-in candidates | Chapters that vote on awards | Award ballot | Drop | A five-step process for something most chapters do once a year in a meeting | Chapters that vote do so in the meeting and record the result | |
| LEG-F-098 | Badges awarded automatically at a threshold, or by hand | Encouraging members | Achievements | Later | This chapter has defined none | Nothing on current evidence | |
| LEG-F-099 | Leaderboards per requirement and per pledge class | Friendly competition | Top members | Later | Cheap once progress totals exist. The rules are already written down: alumni, honorary, inactive members and advisors are excluded, and only chapter-earned credit counts | No leaderboard | |
| LEG-F-100 | Chapter-level awards and trophies, some granted by the national organisation | The chapter's own record of what it has won | Chapter page | Drop | Belongs to the national organisation's records, not to chapter operations | The chapter keeps this record elsewhere | |

### 6.8 Documents, content and the public site

| ID | Feature | What people use it for | Where it is today | Treatment | Reason, and what replaces it | Risk if dropped | Owner decision |
|---|---|---|---|---|---|---|---|
| LEG-F-101 | Meeting minutes | The record of what was decided | Minutes | Later | Mostly a piece of text attached to a meeting | Minutes live in a shared document, which is where most chapters keep them | |
| LEG-F-102 | A chapter blog, with posts approved before publishing | A public-facing news page | Blog | Drop | Other tools do this better, and it needs an approval process of its own. Confirmed by the feedback, which calls it not worth having (FB-12) | The chapter blogs elsewhere | |
| LEG-F-103 | Photo albums, with images approved before publishing | Sharing event photos | Photo albums | Drop | Needs file storage, image resizing and moderation. The vendor's own upload page has been switched off since mid-2025 and was still off in August 2026 | Photos are shared in the chapter's existing photo tool | |
| LEG-F-104 | A file store with folders, an audience per file, and links to files held elsewhere | Constitution, forms, training material | File manager | Later | Second release, moved up on the feedback: people constantly ask where the bylaws are (FB-11). Note it was switched off on this chapter's plan until 29 August 2026, so it has had no chance to be used | People keep asking each other where documents are | |
| LEG-F-105 | A builder for the chapter's public website: pages, header tabs, colours, homepage image | A public website | Website builder | Drop | A website builder inside a membership system. Other tools do this better | The chapter's public website is built elsewhere | |
| LEG-F-106 | A form builder with 13 question types, an open and close date, an anonymous option, and answers that can write back into a member's profile | Interest forms, applications, feedback, information gathering | Forms | Later | Second release (decision D-07). The chapter named what it needs: permissions on who sees the results, email when a form is submitted, a choice between anonymous and signed-in, and forms that can be opened to people outside the chapter. In the first release a form is a link to an external one, and linking out stays available afterwards for anyone who prefers it | Forms are collected with an existing survey tool, which is the first-release position anyway | |
| LEG-F-107 | Courses with modules, quizzes, a repeat rule and a certificate | Training members | Courses | Drop | A learning system inside a membership system. Empty on this chapter | Training is run with existing tools | |
| LEG-F-108 | A job board where alumni post jobs | Alumni helping students | Job board | Drop | No evidence of use, and it needs a steady flow of postings to be worth opening | No job board | |
| LEG-F-109 | Editing the chapter's own links and navigation menu | Adding a link to something the chapter uses | Chapter links | Keep, changed | Keep the ability to add links. Fix the fact that the dashboard panel for this points at a different screen (F-04) | – | |

### 6.9 Reporting and history

| ID | Feature | What people use it for | Where it is today | Treatment | Reason, and what replaces it | Risk if dropped | Owner decision |
|---|---|---|---|---|---|---|---|
| LEG-F-110 | A report builder: choose fields, requirements, account types and dates; view it or download a spreadsheet; show only members who are behind | The list an officer takes to a chapter meeting | Reports | Keep | This is the screen that makes the data worth collecting | – | |
| LEG-F-111 | An attendance report across events | Who came to what | Event reports | Later | Depends on attendance being recorded separately (F-01) | Attendance is read one event at a time | |
| LEG-F-112 | A log of who did what and when, naming the records affected | Answering "who changed this" | Access log | Keep | Build it on the first day. It cannot be filled in afterwards | – | |
| LEG-F-113 | National programme progress reports (Chapter of Excellence, Pledge Program of Excellence) | Reporting to the national organisation | Chapter page | Drop | Fixed national formats that change without notice. Build the general report first | A chapter that files these reports assembles them from the general report | |

### 6.10 Signing in

| ID | Feature | What people use it for | Where it is today | Treatment | Reason, and what replaces it | Risk if dropped | Owner decision |
|---|---|---|---|---|---|---|---|
| LEG-F-114 | Signing in with an email address and password | Getting in | Login page | Keep, changed | Remove the 15-character limit on passwords. The second sign-in step recommended in F-13 is in the backlog, not the first release (decision D-09), so every account is protected by a password alone to start with | – | |
| LEG-F-115 | Signing in with Google or Facebook, linked and unlinked by the member | Not having another password | Change password screen | Later | Convenient and it removes a password to forget. Not needed first | Members use an email address and password | |
| LEG-F-116 | A member changes their own password, giving the current one | Ordinary account maintenance | Change password screen | Keep | – | – | |
| LEG-F-117 | A forgotten-password email | Getting back in | Login page | Keep | Without it, every lockout becomes an officer's problem | – | |
| LEG-F-118 | An officer forces a password reset for a member | Helping someone who is locked out | Member record | Keep, changed | Send the member a reset link rather than setting a password on their behalf, and record it in the audit log | – | |

### 6.11 Setting up the chapter

| ID | Feature | What people use it for | Where it is today | Treatment | Reason, and what replaces it | Risk if dropped | Owner decision |
|---|---|---|---|---|---|---|---|
| LEG-F-119 | Term dates set as a repeating month and day, for a semester or quarter calendar | Defining what "this term" means | Term dates | Replace | Keep a list of terms, each with a name, a start date and an end date, created from the chapter's calendar setting (F-03) | – | |
| LEG-F-120 | The chapter's timezone | Showing event times correctly | Site settings | Keep | – | – | |
| LEG-F-121 | The chapter's name, institution, address and contact details | The chapter's own record | Chapter profile | Keep | – | – | |
| LEG-F-122 | A 16-step setup checklist for a new chapter | Getting a new installation running | Setup | Later | Only matters at the start, but it matters a lot then | The first administrator works out the order themselves | |
| LEG-F-123 | Wording settings: what the chapter calls a family, a big, a little, a requirement and its unit | Using the chapter's own words on every screen | Family settings, requirement labels | Keep | This is the difference between a system a chapter adopts and one it argues with. This chapter renamed "family" to "line" | – | |
| LEG-F-124 | Subscription tiers, billing, and features switched off unless the chapter pays more | The vendor's commercial model | Billing overview | Out of scope | A rule of the software vendor, not of the chapter | – | |

### 6.12 Features that exist only because one system serves many chapters

Every row here is out of scope for a system built for one chapter. They are listed so that
nobody later finds them in the current system and assumes they were forgotten.

| ID | Feature | What it is for | Where it is today | Treatment | Reason | Risk if dropped | Owner decision |
|---|---|---|---|---|---|---|---|
| LEG-F-125 | Region and national event calendars | Seeing events run by other bodies | Calendar, region and national views | Out of scope | There is no region or national office inside a single-chapter system. The feedback confirms it is not working anyway: the Region B calendar is empty and most other chapters' sites are down (FB-22) | Members find regional events through the national organisation's own channels | |
| LEG-F-126 | Inviting other chapters to an event, and event visibility across chapters and regions | Joint events | Create event | Out of scope | Same reason, and it depends on other chapters using the same system, which the feedback says they largely do not (FB-22). A public calendar feed (plan document, ASK-13) covers the part that does not need them | Joint events are arranged by message. Whether an event counts for interchapter credit is still recorded, because that is a credit rule, not a cross-chapter feature | |
| LEG-F-127 | A member database shared across all chapters | Transfers, and finding someone who is already known | Add members | Out of scope | Same reason | See LEG-F-005 | |
| LEG-F-128 | A national staff level above chapter administrators | The vendor's and the national organisation's own access | Seen once, as a refusal message | Out of scope | Same reason | – | |
| LEG-F-129 | A conference manager: ticket types, prices, per-ticket questions, one person registering several attendees | Running a ticketed conference | Named in the release notes only | Out of scope | Not a chapter feature. A large separate product | A chapter running a conference uses a ticketing tool | |

---

## 7. Words that mean different things in different places

The current system uses several words for one thing, and one word for several things. This
section names each case and recommends a single working term. The recommended terms are
used throughout the plan document.

| What it is | Names used today | Recommended working term | Why |
|---|---|---|---|
| The rule a member has to meet (20 service hours) | Requirement, event type, point tracker, progress bar | **Requirement** | One word for the rule itself |
| The kind of thing an event is | Event type | **Event type**, meaning the event's primary requirement | Keep the word. It is what members already say, and "a fellowship event" means an event whose primary requirement is Fellowship. What must not be copied is the current system storing a requirement and an event type as one record, which is what gives it an event type called "Dues Requirement". Here they stay one requirement, and an event points at it (F-25) |
| A named part of a requirement | Category | **Category**, and only this | The word is already taken. This chapter splits Service into four named parts and the credit form sends a category identifier for them (LEG-F-029). It would be natural to also call an event's type its "category", and that must be avoided, because the two would be confused in every conversation and on every screen. An event has a **type**; a requirement has **categories** |
| The list of people expected at an event | Sign-up sheet, attendee list, RSVP list (three names for one list) | **Sign-up list** | Distinct from the list below |
| The list of people who actually came | Attendee list (the same list as above) | **Attendance list** | These are two different facts and should have two names (F-01) |
| An amount of progress earned | Credit, record, hours, units, points | **Credit** | "Record" is used for too many things to be useful |
| The chapter's own category for a member | Account type, status, membership status | **Account type** | The chapter defines these |
| The national organisation's category | Membership status, national status | **National status** | Six fixed values, used for reporting |
| A group used for bulk transitions | Membership stage | **Do not use.** Replaced by the term rollover (LEG-F-010) | A third grouping of the same people, for one purpose |
| A person in the chapter | Member, brother (in the system's own addresses) | **Member** | Not every member of the organisation uses the word brother |
| The officer's view of one member | Account Manager, profile, member record | **Member record** | One name for one screen |
| A named mentoring group | Line, family, group (the chapter chooses the word) | **Family group**, renameable by the chapter | Keep the chapter's own wording as a setting (LEG-F-123) |
| An event run with another chapter | IC, interchapter | **Interchapter event** | "IC" is used in conversation and does not appear on any screen. Note that this is a credit type the chapter already has, not a separate kind of event |
| The screen an officer works from | Officer dashboard, manage menu | **Officer dashboard** | |

---

## 8. Coverage and traceability check

This section exists so a reader can check that nothing was quietly left out.

### 8.1 Where the feature list came from

The 131 features were assembled from five separate sources and then cross-checked against
each other.

| Source | What it contributes | Where it is |
|---|---|---|
| The permission lists | Every permission names a feature. 79 permission rows across two grids | `docs/04-system-design/02a-privilege-lists.md` |
| The list of operations that write data | About 50 operations. Every data change is a feature | `docs/03-api/write-operations.md` |
| The list of screens | About 90 screen keywords, including some reachable only by typing the address | `docs/INVENTORY.md` |
| The vendor's release notes, 2018 to 2026 | Features with no menu entry on this chapter | `docs/05-rebuild-plan/00-feature-inventory.md` |
| Feedback from students and others | What people experience, including two features the review had not recorded (LEG-F-130, LEG-F-131) and three that exist but are believed not to (F-17) | Section 5.1 of this document |

### 8.2 The checks that were run

| Check | Result |
|---|---|
| Every permission row maps to at least one feature in section 6 | Passed. The 18 per-requirement permissions map to LEG-F-027 and LEG-F-069 rather than to one feature each, because they are generated, not designed |
| Every write operation maps to at least one feature | Passed |
| Every screen in the screen list maps to at least one feature | Passed. Four of those screens were never opened, so their feature rows describe what the screen is rather than what is on it (8.3) |
| Every feature has a treatment and a reason | Passed |
| Every feature treated as Drop, Later, Replace or Out of scope states the risk | Passed |
| No feature is recommended for both Keep and Drop in different places | Passed |
| Every finding in section 5 names at least one feature identifier or task | Passed |
| Every item of feedback in section 5.1 is dealt with in a finding or a feature row | Passed. 23 items, none set aside |
| Every item of feedback is marked as matching, contradicting or unverifiable against the screens | Passed. Two conflicts are stated openly under the table in 5.1 and are not resolved by guessing |

### 8.3 What is listed but was never opened

Four screens were recorded as existing but never read, because each is either empty on this
chapter or clearly outside the scope of one chapter. Their features are listed above from
what the screen is, not from its contents.

| Screen | Feature | Why it was not read |
|---|---|---|
| External member invoices | LEG-F-084 | Billing between separate organisations |
| Photo album management | LEG-F-103 | The vendor has switched off image upload |
| Text message history | LEG-F-087 | Text messaging is not recommended for the new product |
| Chapter achievements list | LEG-F-098 | This chapter has defined no achievements |

If any of these four is later judged important, the screen should be read before a decision
is made.

---

## 9. What this review could not establish

Being clear about this matters more than being complete. Each item says what would settle
it.

| Question | Why it is open | How to settle it |
|---|---|---|
| How often each feature is used | No usage data was available, and none is visible in the system | Ask the chapter to review the feature tables in section 6 and mark what they used this year |
| Whether members find the current system hard to use | Partly settled. Students report that it is (FB-03, FB-05, FB-07). Nobody has been watched using it, so we know that it is hard, not where it is hard | Sit with two officers and two members for thirty minutes each while they do a real task |
| Whether the three features in F-17 meet the need or only appear to | The feedback says they are missing; the screens say they exist. Both cannot be right | Open each of the three with an officer and ask whether it would do the job |
| How much of the chapter's real work happens outside the system | Google Forms and Discord are both confirmed as being used instead (FB-10, FB-19). There may be more | Ask each officer what they keep outside the system, and why |
| Whether alumni use the directory, the job board or messages | 523 of 589 records are alumni, and nothing shows whether any of them sign in | Ask the chapter, or count sign-ins if the vendor can report them |
| Whether the permission settings described in F-07 are deliberate | The settings are visible; the intent is not | Show F-07 to the chapter president and advisor |
| Whether the current system enforces its own permission rules on the server | Only an administrator account was available, and an administrator is rarely refused. Also reported as open by students (FB-02), which is not verified either | Not worth settling, and deliberately not to be tested (F-22). The new product enforces every permission on the server regardless. If the chapter wants to know, ask the vendor in writing |
| What the "chair title" field is for (LEG-F-026) | Still open. It was briefly recorded as answered on 4 September 2026, and that was wrong: the chapter has no chairs who are not officers, so it is unlikely to be using the field for that (F-24) | Ask whether anyone has ever filled it in |
| How common are events that count towards nothing | The "Other Events" bucket is not broken down anywhere (F-25) | Count them under that calendar filter. Not needed before building: it says how much officers' habits change under rule R-23, not how much work the move is |

One point of honesty about the whole review. It describes what the system offers, how it is
configured, and what the people using it say about it. It still does not describe how the
chapter actually works, because nobody has been watched doing the work and nothing has been
counted. Feedback tells you where to look; it does not tell you how often, or how much it
costs, or whether the person who did not complain has the same problem.

The feedback did change three things, which is worth recording because it is the argument
for gathering more of it:

- It found two features the screen review had not recorded: the one-way calendar link
  (LEG-F-130) and the member home page itself (LEG-F-131), which the review had described
  only through the things sitting on it.
- It moved four features into an earlier release, and one out of the "not scheduled" list
  entirely (announcements, documents, custom profile fields, member submission of
  attendance).
- It found three features that exist and are believed not to (F-17), which is a different
  kind of problem from a missing feature and needs a different fix.
- It corrected one reading in this document that was wrong (FB-08, now F-23). That reading
  was a guess about what somebody meant, made instead of asking. It is the only kind of
  error in this document that will not show up in any of the checks in section 8.

Every recommendation in this document should still be read as "this is what the evidence
supports", not as "this is what the chapter needs". The plan document lists, for each major
decision, what should be checked with real users before it is built.
