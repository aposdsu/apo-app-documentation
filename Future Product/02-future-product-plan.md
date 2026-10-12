# What to build next, and what to decide first

> **What this is.** A plan for the chapter management product that replaces the one the
> chapter uses today. It says what the new product is for, what goes in the first release,
> what waits, what is not planned, and which decisions belong to the product owner rather
> than to this document.
>
> **Who it is for.** Product managers, product owners, designers and the people who will
> build it. Officers and members should be able to read sections 2, 3 and 5 and recognise
> their own work.
>
> **What it is based on.** The review in `Future Product/01-current-system-review.md`, which
> describes the current system feature by feature. This document does not repeat that
> reasoning. Where it refers to a finding (`F-05`) or a feature (`LEG-F-068`), the detail is
> in the review.
>
> **Feedback from users.** Students and others who use the current system have given written
> feedback about it, listed in full in the review, section 5.1. Section 7 records everything
> that was asked for, including the requests this plan does not meet.
>
> **Decisions.** All sixteen decisions in section 8 have been made, and each one is recorded
> with who made it and when. Where a decision went against what this document recommended, the
> recommendation is left visible next to it rather than quietly rewritten. Section 9 lists
> every feature that moved as a result.
>
> **The words used here.** The current system uses several words for the same thing. This
> document uses one word per concept, listed in the review, section 7. The main ones:
> a **requirement** is a rule a member has to meet, a **credit** is progress towards it, the
> **sign-up list** is who said they would come, and the **attendance list** is who came.
>
> **What it is not.** A commitment. Every recommendation here is ours. Every decision is the
> product owner's, and section 8 lists the ones that have to be made before building starts.

---

## 1. What the new product is for

**One sentence:** it lets one chapter run a semester, by keeping track of who is a member,
what each member has to do, what they have done, and what they owe.

Three things follow from "one chapter".

**It serves one chapter, whatever size that chapter is.** This one has 66 current members
today, and that number is not a design input. A chapter of 10 and a chapter of 150 both have to
work, and this chapter will not be the same size in five years. Nothing in the product should
assume a number of members, a number of officers, a number of committees or a number of
requirements. Where a screen would only work for a short list, it needs searching and paging
instead.

**It has no region and no national office inside it.** A large part of the current system
exists because one company runs the same software for hundreds of chapters, a set of
regions and a national office. Eleven features are set aside for this reason alone (listed
in section 9). Removing them removes a large amount of work before anything is built.

**Nobody is paid to run it.** Officers are students with other commitments and they change
every semester. Anything that needs someone to remember to do it will eventually not get done,
and anything that has to be explained by the last officer to the next one gets explained twice
a year, or not at all.
That is the reasoning behind the automatic messages in section 6 and the term rollover in
section 5.2.

### What success looks like

These are the measures we suggest, not measures anyone has agreed to. They are here so the
product owner can change them now rather than after the build.

| Measure | Why this one | How to read it |
|---|---|---|
| Every event that happened has been closed within one week | Closing an event is what creates credit. If it does not happen, no other number is true | Count events whose date has passed and which are not yet closed |
| No officer keeps a private spreadsheet of hours | The clearest sign the system is trusted | Ask the officers, once a term |
| A member can answer "am I behind" without asking an officer | The main reason a member signs in | Count how many members sign in during a term |
| Officer handover takes one sitting | The current system loses last term's record at handover (F-09) | Watch one handover |

---

## 2. Who it serves

The review, section 3, describes who uses the current system. The list below is who uses the
new one, and what each of them should be able to do without help from anybody else. It has one
more row than the review does, because a chair who is not on the executive board has nowhere to
exist in the current system (F-24).

| Person | Should be able to, on their own |
|---|---|
| A member | See what they owe and what they have done, sign up for events, and submit their attendance at an event with whatever proof it asks for. A member never writes credit (decision D-01) |
| An officer for one area | Create events, close them, correct attendance, add credit by hand for work done outside a chapter event, and get a list of who is behind |
| A chair who is not on the executive board | Run the work of their committee or team, including creating events, with an officer approving first if the chapter has set it up that way. Some chairs are on the board and some are not; both exist (F-24) |
| The Treasurer | See who owes money, record a payment, and charge a fee |
| The president or advisor | Invite new members or import a roster, assign positions, set what each position and group can do, and set the term dates |
| Someone who has been invited | Open the invitation, set a password, and be in. There is no public sign-up route (decision D-08) |

---

## 3. The rules that must survive

These are the parts of the current system that are correct and that a rebuild can easily
get wrong. Each one is a rule the new product must follow. If a design decision later
conflicts with one of these, the conflict should be raised, not resolved quietly.

| # | Rule | Why it matters |
|---|---|---|
| R-01 | One list per event, and nobody is deleted from it. Everyone on it has a state: signed up, then present or absent | Both facts matter and the difference cannot be recovered later. Deleting a no-show throws it away, which is what happens today (F-01, decision D-02) |
| R-26 | A member's target on a requirement can be set for that member alone, higher or lower, and the override records who set it and why | It is what removes the reason to invent an account type for every exception. It also changes what a person owes, so it needs an answer to "who decided this" (decision D-05) |
| R-27 | A setting that changes what many people owe shows what will change, and to how many, before it saves | Four settings do this: a term's dates, a target on any account type, moving an account type to a different parent, and a requirement a group carries. Changing a target on a base type reaches every type underneath it. The current system has the first of these and no warning on it, so an administrator can move every progress bar in the chapter without knowing (F-03) |
| R-28 | An inherited target is looked up when it is needed, never copied when it is set | It is what makes a base worth having. Change a requirement on Member and everyone underneath who has not set their own changes with it. Copy the value down at setup instead and the base becomes decoration: later changes reach nobody, and nothing on screen says so |
| R-02 | Credit is created when a person decides it is, not automatically when an event ends | It gives an officer the chance to fix the list first, and it means nothing is awarded by accident |
| R-03 | Closing an event twice must not give anyone double credit | This will happen. Two officers, one slow page, two clicks |
| R-04 | Reopening a closed event removes exactly the credits closing it created, and nothing else | Otherwise a mistake is corrected member by member (F-14) |
| R-05 | Credit does not need an event behind it | Work done outside a chapter event is real and must be recordable (LEG-F-034) |
| R-06 | How much a member owes depends on their account type, and can be a fraction | This chapter asks 7.5 service hours of its Half-Active members |
| R-07 | Each credit is marked as earned at a chapter event or outside it, and a requirement can cap the outside share | A real chapter rule, cheap to build, impossible to add to old data later |
| R-08 | A requirement can be split into named parts, each with its own target | This chapter splits service four ways |
| R-09 | A requirement rule does not belong to a term. The term decides which dates count | Otherwise every requirement has to be copied every semester |
| R-10 | Credits already earned are never changed by a change to a member's account type | Only the target changes. Confirmed on the current system |
| R-11 | Permissions are settings that an administrator changes, never code that a developer changes | The best-designed part of the current system (task F in the review) |
| R-12 | Every permission is checked on the server before the action runs | Hiding a button is presentation. The check is what stops someone |
| R-13 | Every action that writes or deletes a record is logged with who did it and when | It cannot be filled in afterwards (LEG-F-112) |
| R-14 | Deleting something says what else will change before it is confirmed | The current system leaves pieces behind (F-02) |
| R-15 | The chapter's own words appear on screen, as settings | This chapter calls a family group a "line" (LEG-F-123) |
| R-16 | A member can see that their attendance or their hours have been submitted and are waiting, before anyone approves them | Today there is nothing between attending and being credited, and not knowing is the most common complaint (F-18, F-20) |
| R-17 | A permission can be given to one person for one term without giving them an officer title | Otherwise the chapter has to invent an officer position in order to grant one permission (F-19) |
| R-18 | The page a member lands on is assembled from separate blocks, and which blocks appear is a setting | The current page is fixed, so the chapter cannot fix it even when it knows what is missing (F-23). Built from blocks on day one this is nearly free; retrofitted later it is not |
| R-19 | A permission reaches a person through a named role, and a role can be given to a group, to a position, or to one person | Today the same ticks are copied by hand into 33 separate grids, and a permission cannot reach anyone who does not hold an officer title (F-07, F-19). Section 4.6 sets out the model |
| R-20 | Whether somebody is an officer is answered by which group their position sits in, never by a flag on their record | A chapter that reorganises, renames its committees, or adds a kind of group the software has never heard of should not need anyone to change the software (F-24) |
| R-21 | More than one person can hold the same position at the same time | This already works in the current system (19 positions, 26 assignment rows) and is easy to lose in a rebuild that assumes one holder per job (F-24) |
| R-23 | Every event has exactly one primary requirement, and may name others as well. Each of those lines carries a credit amount that may be zero | The primary is what gives an event a single place on the calendar and a single owner. Without it, an event crediting three requirements belongs everywhere and to nobody, which is why the current system needs an "Other Events" bucket and a separate permission for managing what is in it (F-25) |
| R-25 | An event appears on the calendar once, under its primary requirement, and is found by a search for any requirement it credits | Two different questions. "What is on this month" should not show one event three times. "What can I do to earn leadership credit" should return every event that awards it, whether that is its primary or not |
| R-24 | An action that waits for approval is visible, with its age, to the people who can approve it | An approval queue nobody works recreates the problem it was built to solve: today credit waits two days because an officer has not got to it (F-18) |
| R-22 | Nothing is ever decided by reading the words in a position's title | Today most of the chapter's positions are named as chairs and every one of them is an officer position. "Chair" is part of a name, not a category. Software that tests for it will be wrong for this chapter now and for the next chapter always (F-24) |

---

## 4. What goes in the first release

**The test for the first release:** a chapter can run one full semester on it, and no
officer needs a spreadsheet alongside it.

58 of the 130 existing features are in the first release. The full list of identifiers is in
section 9. Grouped by what a person is trying to do:

### 4.1 Members and the roster

Member records with contact details. A roster grouped by account type. Account types the
chapter defines, each mapped to one of the six national statuses. Officer positions the
chapter defines, sitting in groups. Assigning members to positions, recorded per term.

**Getting people in: the system is invite-only** (decision D-08). Two routes, both in the
first release: an officer invites somebody by typing in their details, or imports a roster
from a spreadsheet file. Either way the person receives an email, sets a password, and is in.
There is no public link anybody can find, no queue and nothing to approve, because the
invitation is the decision.

**Profile fields the chapter defines** (LEG-F-014). Alongside the built-in fields, the chapter
can add its own, each with its own type and its own settings for who may see it and who may
edit it. This replaces the separate directory form that everybody fills in twice a year
(FB-13, FB-14).

**One change from today:** a member's account type is recorded per term, and so is every
officer assignment (F-09). This is the change that is cheap now and impossible later.

### 4.2 Terms

A list of terms, each with a name, a start date and an end date, created from the chapter's
calendar setting. One term is the current one. Changing a term's dates shows what will
change before it saves (F-03).

### 4.3 Requirements and credit

Requirements the chapter writes and can add to or remove at any time, each with optional
named parts and a cap on how much credit may come from outside chapter events. No requirements
are brought across from the current system; the chapter builds its list fresh (decision D-04).
A member's own progress over four time ranges. An officer's table of every member's progress on
one requirement, over any date range. Progress bars on the member's home page.

**Where a target comes from** (decision D-05). Three places, added together:

| Source | Example |
|---|---|
| The member's account type, which sits in a tree of any depth and builds on at most one other type, or on none | An officer builds on Active and owes everything an active member owes plus their own. The chapter can rearrange the tree later, for example putting a shared Member base underneath both Active and Pledge, and rule R-27 makes that change show its effect first |
| Any position or group they hold | A committee adds a requirement of its own for everyone in it, or none. A chair position adds chair credits. Neither changes anybody's account type |
| An override for that one member, set higher or lower by whoever manages the requirement | Somebody studying abroad owes 7.5 instead of 15. The override records who set it and why (rule R-26) |

**A type can change what it inherits, not only add to it.** Pledge, building on Member, can
raise one of Member's targets, lower it, or remove that requirement from itself altogether. So
building on another type is a starting point, not a floor.

**Working out what one member owes on one requirement**, in order:

1. **A per-member override wins** if there is one for that member and that requirement. It is
   the last word, because it is a deliberate decision about that person (rule R-26).
2. **Otherwise walk up the tree** from the member's account type. The nearest type that sets
   the target, raises it, lowers it or removes it decides the answer. A type that says nothing
   about a requirement passes the question up to the type it builds on.
3. **Then add what their positions and groups contribute** this term. A committee's own
   requirement applies to everyone in it, whatever their account type says, including a type
   that removed it.

Step 2 is what makes a base worth having: **change a requirement on Member and it changes for
everyone underneath who has not set their own.** Active, Officer and Pledge all move. Anyone
who overrode that particular requirement does not, because their own value is nearer. This is
also why rule R-28 matters, and why R-27 makes such a change show its effect before saving.

**Where credit comes from** (decision D-01). Two places only: an event that awards it, or an
officer or chair typing it in who holds the permission for that requirement. **A member never
writes credit.** What a member can do is report attendance at an event, which somebody
approves, after which the credit comes from the event. Section 5.1 describes that.

### 4.4 Events

Creating an event with a time, a place, a description, **the requirements it belongs to** (at
least one, rule R-23) and, separately and optionally, the credit it awards towards any of
them. Simple repeating events. Sign-ups, with a window that opens and closes. Who can see it and who
can sign up, at three levels: officers, members, public. **One list per event**, where each
person is signed up and then marked present or absent, and nobody is deleted (rule R-01).
Closing an event to award the credit, safely and reversibly. The queue of events waiting to be
closed. Deleting an event, with a clear statement of what else changes.

**How an event connects to requirements.** An event carries one or more lines. Each line names
a requirement, optionally a part of it, and an amount that may be zero. Exactly one line is
marked as the primary.

**The primary requirement is what everybody calls the event type.** "A fellowship event" means
an event whose primary requirement is Fellowship. The product should use that word, because it
is the one members already use. It also means the chapter never keeps a second list of event
types next to its requirements. This chapter's event types are its eighteen requirements:
Fellowship Events, Service Hours, Meetings, Leadership Credits and the rest. If a chapter ever
needs a type that is not one of its existing requirements, it creates a requirement with a
target of zero for everyone, so no progress bar appears and events can still be filed under
it.

| Line | Requirement | Amount | What it does |
|---|---|---|---|
| Primary | Fellowship | 1 | Decides the calendar lane and who is responsible for the event |
| Secondary | Leadership | 1 | Credit flows here too, and a search for leadership credit finds this event |

Which question is answered by which part:

| Question | Answered by |
|---|---|
| Where does this event appear on the calendar? | The primary line only (rule R-25) |
| Who manages it, and who would approve it if it were proposed by a chair? | Whoever manages the primary requirement |
| What credit does somebody who attended receive? | Every line with an amount above zero |
| "Show me events that give leadership credit" | Any line, primary or secondary (rule R-25) |
| "Show me only the ones that actually award something" | The amounts. A member filling a requirement wants lines above zero; a member looking for something to do on Friday wants everything |
| "How many fellowship events did we run this term?" | Primary lines only |
| How far along is this member on leadership? | The credits themselves, never the events. A member's progress is the sum of their credits, so credit earned at an event whose primary is something else still counts |

A note on the last row, because it is the one that gets built wrong: progress must never be
worked out from "events whose primary requirement is X". It is worked out from the credits,
which is how the current system already does it and how the new one should.

**How members find events.** Three filters, which combine: the event type (its primary
requirement), any requirement the event credits, and whether it awards credit at all. So
"fellowship events" and "everything that gives leadership credit" and "only events that
actually award something" are each one filter, and "fellowship events that award credit" is
two of them together.

`[A small call we made]` **Any line may carry an amount of zero, secondary lines included.** A
zero on a secondary line means "this event is also about that area, but earns nothing for it".
Allowing it everywhere is simpler than allowing it only on the primary, and it costs nothing.
Say so if you would rather a secondary line always carried real credit.

**Who runs an event.** Every event has an **organiser**, the person who created it, and any
number of **event chairs** the organiser assigns. The organiser decides per event whether those
chairs may approve attendance and close it. Whoever manages the primary requirement always can,
whatever the organiser set.

**What the event asks attendees for.** The organiser chooses a short list of fields from a
fixed set: name alone, a summary of what they did, a start and end time, a photograph. Not a
general form builder; that is the second release (LEG-F-106). Collecting submissions at all is
optional per event.

Rule R-23 applies to events created in the new product. There is no data migration in this
project (decision D-06), so no old events arrive needing a primary requirement assigned to
them.

### 4.5 Dues

What each account type owes, a due date, a balance per member, recording a payment by cash,
cheque, card or other, and charging a one-off fee. Dues have their own screens rather than
living inside a requirement (F-11), and they still show as a progress bar on the member's
home page.

Whether dues belongs in the first release at all is decision D-03. The two source documents
in this repository disagree about it.

### 4.6 Groups, positions and permissions

The current system already lets the chapter create its own officer positions and tick which
permissions each one gets, and that is the right shape. It is kept. What changes is two
things: how the chapter's own structure is written down (F-24), and how a permission reaches
a person (F-19).

**Five things, all created and changed by an administrator, none of them written into the
software:**

| Thing | What it is | Example |
|---|---|---|
| A permission | One action a person can take | "Create an event" |
| A role | A named set of permissions, made by the chapter | "Event organiser" |
| A group | A named part of the chapter that holds positions. The chapter types the names | "Executive Board", "Service Committee", "Recruitment Team" |
| A position | A job inside a group. Any number of people can hold it (rule R-21) | "Service Vice President", "Blood Drive Chair" |
| A grant | Giving a role to a group, to a position, or to one person, for one term | "Give the event organiser role to the Service Committee for Fall 2026" |

**The one rule that decides what anybody can do:** a member's permissions are everything in
every role granted to them directly, plus every role granted to a position they hold, plus
every role granted to a group containing a position they hold, this term. Nothing else grants
anything.

Three smaller points that make the model work:

- **A group has a head, recorded as one of its own positions.** The head of the Service
  Committee is whoever holds the Service Vice President position this term, so it changes at
  handover on its own.
- **"Officer" stops being a property of a person.** It becomes a question: does this person
  hold a position in the group the chapter has named as its executive board (rule R-20).
- **"Chair" is a word in a position's name, not a kind of position.** Today most of this
  chapter's positions are named as chairs and all of them are officer positions. Some chairs
  will stay on the executive board and some will sit in committees, and both are normal. The
  software never reads a title to decide anything (rule R-22), so where a position sits is
  decided only by which group it is in.

#### What this makes possible

| The chapter wants to | How the model does it |
|---|---|
| Have some chairs on the executive board and others not | Both are positions. One sits in the board group, the other in a committee group. Nothing about the word "chair" decides it (F-24, rule R-22) |
| Move a chair off the executive board without renaming the job | Move the position to a different group. Its title, its holders and its history do not change |
| Give a chair the ability to create events | Grant the event organiser role to that position, or to the whole committee group |
| Have two people share a chair | Two people hold the same position. This already works today and is kept (rule R-21) |
| Give one person one permission for one term | Grant a role to that person directly, with no position involved (rule R-17, F-19) |
| Change what every committee chair can do | Change the role once, rather than editing 33 separate grids (F-07) |
| Call committees something else, or invent a new kind of group | Groups are rows the chapter creates and names. The software has no list of allowed kinds (rule R-20) |
| Reorganise completely in three years | Same answer. Nothing about the structure is written into the software |

#### Permissions that need somebody's approval

**Approval is a setting on the grant, not a property of the permission.** The same permission
behaves differently for two people, because the chapter decided it should:

| Person | Permission | Mode |
|---|---|---|
| Service Vice President | Create an event | Does it |
| Blood Drive Chair | Create an event | Proposes it, and somebody signs off |

Anything an officer can do can be granted to a chair this way. Creating events, changing a
requirement, approving attendance: each one is granted either directly or with approval, and
the choice is made separately for every one of them. A chapter can give one chair everything
directly and another chair the same abilities with approval required on all of them.

**How a proposal works.** One mechanism serves every action, rather than a separate design
for each:

1. The person takes the action as they normally would.
2. Instead of happening, it is recorded as waiting, along with who proposed it and what it
   will do when it happens.
3. It appears for the people who can approve it, with its age showing (rule R-24).
4. Approving carries it out. Rejecting records the reason, and the proposer is told either
   way.

**Who approves is named when the role is granted** (decided 4 September 2026). The approver
can be a person, a position, or a group, using the same three choices as everything else in
this model. Two safeguards go with that choice, because naming an approver by hand is the
option with the most ways to get it wrong:

- **A warning when the named approver cannot do the action themselves.** An approver who does
  not hold the permission directly is not really checking the work, and the software should
  say so at the moment the role is granted rather than when the first proposal is stuck.
- **Nobody approves their own proposal**, even when they also hold the permission directly.

Because every event now names at least one requirement it belongs to (rule R-23), the
software can suggest the officer who manages that requirement as the approver. It is a
suggestion at the moment of granting, not an override.

**What is in the first release: proposing new things.** Changing something and deleting
something are in the backlog (decided 4 September 2026). A person either may change a record
or may not, with no middle setting, until that backlog item is picked up.

**A proposed event can be shown or hidden while it waits, and that is a setting** (decided 4
September 2026). Shown, it appears on the calendar marked as not yet confirmed, so members can
see what is coming. Hidden, only the proposer and the approvers see it. The setting has a
chapter-wide default and can be changed on a single event.

**Sign-ups stay closed until the event is approved**, even when the event is visible (decided
4 September 2026). A member who signs up for something that is then rejected has been told a
thing that was not true. The cost is that a late approval leaves less time for people to sign
up, which is an argument for working the queue rather than for opening sign-ups early.

#### Four deliberate limits

1. **The list of permissions grows when features are added, not when an administrator asks.**
   A permission is only meaningful if there is something behind it to permit, so a chapter
   cannot usefully invent one. The exception is the thing the current system already gets
   right and which is kept: creating a requirement creates its permissions automatically
   (LEG-F-069).
2. **Groups do not sit inside other groups.** One level only. A committee inside a committee
   is not supported, because supporting it complicates every screen that lists anything. If
   it is ever genuinely needed it can be added later.
3. **The group layer is always there, and a chapter can have exactly one group.** A chapter
   that does not want committees creates one group, calls it whatever it likes, and never
   meets the idea again. That is simpler to build and to use than making the layer optional,
   because optional means every screen has to work both ways (decision D-15).
4. **It arrives already set up, matching today exactly.** Nobody should meet an empty screen
   and have to invent a chapter from nothing. The first release ships with all 19 of this
   chapter's existing positions in a single group, because that is the truth today: every one
   of them is an officer position. Creating committee groups and moving positions into them is
   then the chapter's first piece of work, done when it is ready and not as a condition of
   starting.

All of this is in the first release, because the shape of a permission model and of an
organisation chart are two of the most expensive things to change once real data exists.

### 4.7 Signing in

Email address and password, with no limit on password length. An invitation email that lets a
new member set their first password. A member changes their own password. A forgotten-password
email. An officer can trigger a reset for a member.

**No second sign-in step in the first release** (decision D-09). It is in the backlog. Until it
is built, every account including the ones that can change permissions is protected by a
password alone, which is the position today. Finding F-13 stays open.

### 4.8 Announcements, and what a member sees on signing in

The page a member lands on is **built from separate blocks, and the chapter chooses which
ones appear and in what order** (rule R-18). This matters more than the blocks themselves:
today the page is fixed, so when the chapter knows something is missing it has no way to add
it (F-23).

The blocks in the first release:

| Block | What it answers |
|---|---|
| Announcements | "Is there anything I need to know?" |
| The events I have signed up for | "Where am I supposed to be?" |
| Progress on each requirement that applies to me | "Am I behind?" |
| What I owe | "Am I paid up?" |
| Events coming up that I can still sign up for | "What could I go to?" |
| Documents added recently | "What has changed that I should read?" (arrives with the file store in the second release, LEG-F-104) |

Two notes on that list. Two of the six do not exist today at all: the events **I signed up
for** as a separate block, and recently added documents. And announcements already exist in
the current system but the chapter believes they do not (F-17), so before building, open the
existing screen with an officer and check what it actually lacks. It may need to be visible
rather than different.

**Letting each member arrange their own version of this page is not in the first release.**
Once the chapter has been choosing the blocks for a term, it will be clear whether anyone
wants more than that (ASK-06).

### 4.9 Reports and the record

The report builder: choose fields, requirements, account types and dates, view it or
download a spreadsheet, and show only members who are behind. A log of who did what and
when. A notification to a member when they are credited.

### 4.10 What the first release depends on

Three things the first release needs that no screen shows, so they are easy to leave until
too late.

| What | Why it is needed | What happens without it |
|---|---|---|
| **Sending email** | Invitations are the only way into the system (decision D-08), and the forgotten-password email is the only way back in | Nobody can join and nobody can recover a locked account. This is the hardest dependency in the release, and it arrived with the decision to be invite-only |
| **Storing files** | Photographs submitted as proof of attendance (decision D-14) | The proof step in section 5.1 does not work. Everything else does, so this is the one piece that could be left until later without reshaping anything |
| **Something that runs on a schedule** | Photographs are deleted at the end of the term (decision D-14) | Photographs are kept for ever, which is not what was decided |

The third one is worth noticing. This plan had treated work that runs on a schedule as a
second-release concern, on the grounds that reminders and digests can wait (F-12). The
retention rule in D-14 brings a small piece of it forward, and it is better to know that now
than to discover it when the first term ends.

---

## 5. How the main tasks change

The review describes how six tasks work today. Three of them change enough to be worth setting
out step by step, and this section does that. The other three keep the shape they already have,
and their changes are named where the feature is: checking who is behind (sections 4.3 and
4.9), dues (section 4.5), and setting permissions (section 4.6).

### 5.1 An event happens, attendance is proved, and the event closes

This is the flow the chapter described on 4 September 2026, and it replaces a process that
currently runs on Google Forms and a spreadsheet (F-18). Today a member fills in a form with a
photograph, an officer reads the spreadsheet and types everybody's credit in by hand, and
nobody knows where they stand for a day or two.

In the new product:

1. **The event is created with an organiser and, if wanted, event chairs.** The organiser is
   whoever created it. Any number of event chairs can be assigned: people who will be there,
   watching the door and keeping things running. The organiser decides, on this event, whether
   those chairs may approve attendance and close it.
2. **The event says what it asks attendees to submit.** A short list of fields chosen when the
   event is created: their name alone, a summary of what they did, a start and end time, a
   photograph, or some combination. This whole step is optional per event, so an organiser who
   would rather run a form outside the system loses nothing.
3. **Members who attended submit it**, and see it immediately as waiting, next to their
   progress, with the credit it would earn. Nothing has been credited yet (rule R-16).
4. **Whoever may close the event opens one list**, works through the submissions, approves or
   rejects each one, and presses submit. Rejecting says why.
5. **Everyone approved is credited at once, and the event closes.** Somebody who signed up and
   did not come is marked absent on that same list, not deleted (rule R-01).

**Every event closes by hand.** Closing an event that awards nothing automatically is in the
backlog, with the condition the chapter suggested for it: any credit above zero would still
need approval first.

**Who may close it.** Whoever manages the primary requirement always can, and so can the
organiser. The event chairs can if the organiser said so on that event. The requirement
manager is the safety net: without it, an event whose organiser graduates has nobody who can
close it.

**Photographs** are visible to whoever approves the attendance and to the member who submitted
them, and are deleted at the end of the term (decision D-14). This is why file storage is in
the first release when nothing else needs it.

**Hours worked outside a chapter event are different.** A member cannot submit those. An
officer or chair who holds the permission for that requirement types them in (decision D-01).

**Why this is better.** The people who were there report it, at the time. The member sees
where they stand the same day. The officer works one list inside the product instead of
reading a spreadsheet and typing each person in. Nothing is credited until somebody with the
permission approves it.

### 5.2 The term changes

Today this is two unconnected things, and neither of them keeps a record (task E in the
review). In the new product it is one action, on one screen:

1. An officer opens "start a new term". The system shows the new term's name and dates,
   taken from the chapter's calendar setting, and lets them be changed.
2. It carries forward every member's account type into the new term, and shows the list so
   it can be corrected before anything is saved.
3. It shows the officer positions and who held each one last term, so the new holders can be
   entered. Positions with nobody in them are shown clearly.
4. It says what will not carry forward: progress starts again from zero for every
   requirement, because credit is counted inside the term's dates.
5. Saving records the new term. Last term's record is unchanged and can still be reported
   on.

**The first term is different**, because there is no previous term to carry anything forward
from and no data is being migrated (decision D-06). Setting up the first term means entering
the chapter's requirements, its groups and positions, and its members, by invitation or by
importing a roster file. Every term after that is the five steps above.

**Why this is better.** The chapter can answer questions about any past term (F-09). Nobody
has to remember that two separate screens both need attention. Nothing is overwritten.

**What to validate first:** whether officers would rather do this in one sitting or in
pieces over a week. Watch one handover (section 10).

### 5.3 A new person joins

This one gets shorter rather than better (decision D-08). Today somebody finds a public link,
fills in a form, and waits in a queue for an officer to notice them. In the new product:

1. An officer invites them, by typing in their details or by importing a roster file.
2. They receive an email, set a password, and are in.

There is no public link, no queue and no approval step, because the invitation is the decision.
The three problems the review found with the current route (nobody responsible for the queue,
no sign of how long anybody has waited, seven people sitting in it) do not need solving,
because the queue does not exist.

---

## 6. What waits, and what is not planned

### 6.1 The second release

26 features. The full list of identifiers is in section 9. In rough order of usefulness:

1. **A calendar members subscribe to once** (LEG-F-130), so chapter events appear in their
   own calendar and stay up to date. This replaces copying events across one at a time, and
   the same feed can be made public for people outside the chapter (F-20, ASK-13, decision
   D-13).
1b. **The form tool** (LEG-F-106): permissions on who sees the results, email when a form is
   submitted, anonymous or signed-in submissions, and forms that can be opened to people
   outside the chapter. Anonymous feedback to officers is then one form among many
   (LEG-F-092, decision D-07). Until it exists, a form is a link to an external one.
2. **Two automatic messages** (LEG-F-094): a reminder before an event a member signed up
   for, and a message to members who are behind near the end of term. This is the first
   thing that works without an officer remembering to do it (F-12).
3. **A central place for documents** (LEG-F-104). People currently ask each other where the
   bylaws are (FB-11). Check the existing file store first; it may only need to be visible.
5. **Email to a chosen group of members** (LEG-F-085). The valuable part is choosing who to
   send to.
6. **Checking members in at the event** (LEG-F-061), which removes the step that fails today.
7. **Attendance limits and a waiting list** (LEG-F-048), for events that fill up.
8. **The money ledger and budgets per position** (LEG-F-078, LEG-F-079).
9. **Awards granted to members** (LEG-F-095, LEG-F-096) and **leaderboards** (LEG-F-099).
10. **The big and little structure** (LEG-F-022) and **the member timeline** (LEG-F-018).
11. **Meeting minutes** (LEG-F-101), **the calendar view** (LEG-F-059), **percentage
    requirements** (LEG-F-031), **sign-in with Google** (LEG-F-115), and the rest listed in
    section 9.

Two features left this list for the first release: **spreadsheet import of a roster**
(LEG-F-006), because with no public sign-up route it is how the system gets its members, and
**event organisers and chairs** (LEG-F-051), because the attendance flow depends on knowing who
runs an event.

### 6.2 Worth building one day, with nothing scheduled

6 features, each waiting on an audience that has not been shown to exist or on work nothing
else needs: per-member files, the alumni directory, named family groups, online card payment,
saved email audiences, and achievements.

Four features have left this list. Chapter-defined profile fields, the chapter file store and
checking members in at events moved to the second release because the feedback showed a real
cost to going without them. The form builder moved to the second release because the chapter
asked for it directly (decision D-07).

### 6.3 Not planned

28 features. The reason for each is in the review, section 6. The seven that a reader is most
likely to question:

| Feature | Why not | What happens instead |
|---|---|---|
| The public registration link (LEG-F-002) and the approval queue (LEG-F-003) | The system is invite-only (decision D-08). The invitation is the decision, so there is nothing to queue | An officer invites somebody or imports a roster |
| Members recording their own credit (LEG-F-035) | Credit comes from an event or from an officer or chair with the permission for that requirement (decision D-01) | Members report attendance at an event, which somebody approves. Hours worked outside a chapter event are typed in by an officer |
| Online card payment (LEG-F-081) | Never used by this chapter. It brings a payment provider, rules about card data, and refund handling | Members pay the Treasurer as they do today, and the payment is recorded |
| Photo albums (LEG-F-103) | Needs file storage, image resizing and moderation. The current vendor's own upload page has been switched off since mid-2025 | Photos are shared in whatever tool the chapter already uses |
| Bulk text messages (LEG-F-087) | Costs money per message, and every chapter already has a group chat | The chapter's existing group chat |
| Private messages between members (LEG-F-093) | Members already have several ways to contact each other | Existing messaging tools |
| Profile history (LEG-F-015) | A member who corrects their name or phone number has not actually removed the old value | Changes are visible in the audit log, which is bounded and reviewable |

### 6.4 Out of scope

11 features exist only because one system serves many chapters, a region and a national
office. They are listed in section 9 so that nobody finds them later and assumes they were
forgotten.

---

## 7. What students and others have asked for

The feedback came with a list of what people want the new product to do. Every item is
recorded here with an identifier, whether or not this plan meets it. An item that is not
being built is still recorded, with the reason, so that nobody has to ask twice.

The "Where it lands" column uses the same words as the rest of this document: first release,
second release, a decision, a separate project, or not planned.

### 7.1 The requests

| ID | What was asked for | Where it lands | Why |
|---|---|---|---|
| ASK-01 | A full rewrite away from PHP: a modern JavaScript front end and back end, probably with a Postgres database | Technical decision, not made here (7.2) | It is already the project's working assumption, but which tools to use is not a product decision |
| ASK-02 | Endpoints that are locked down, so they cannot be called by anyone | Already a rule (R-12) | Every permission is checked on the server before the action runs. How that is built is a technical decision (7.2) |
| ASK-03 | A second step when signing in | **Backlog** (decision D-09) | Not in the first release. Until it is built, every account including those that can change permissions is protected by a password alone, which is the position today |
| ASK-04 | Data brought across from the current system | **Not in this project** (decision D-06) | The work is building the platform. Migration is a separate exercise planned once the platform exists. Test data during the build |
| ASK-05 | Run as an ongoing student project, with access to the code repository handed on each year | Delivery decision, not made here (7.2) | It does change one thing in the product: written guidance (F-16) and the record of who did what (LEG-F-112) matter more when the people maintaining it keep changing |
| ASK-06 | A landing page that can be changed to show what matters to the chapter: the events I signed up for, announcements, documents officers recently uploaded, and other things. Some people want upcoming events and some want the calendar, so let them arrange it | Split. **First release:** the page is built from blocks and the **chapter** chooses which appear and in what order (section 4.8, rule R-18). **Second release:** the recently added documents block, which arrives with the file store. **Later:** each **member** arranging their own version | The chapter being able to change the page is the part that is failing today (F-23) and it is nearly free if the page is built from blocks from the start. Each member arranging their own is a different and larger thing, and it is worth little until the chapter has settled what belongs there. Revisit after a term |
| ASK-07 | An announcements system on the front page, including things like meeting minutes | **First release** for announcements (LEG-F-088). **Second release** for meeting minutes (LEG-F-101) | Announcements already exist and are believed not to (F-17). Minutes are a larger piece and can follow |
| ASK-08 | A central document repository | **Second release** (LEG-F-104) | Needs file storage, which the first release now has anyway for attendance photographs (decision D-14), so this is smaller than it first looked. Check the existing file store first |
| ASK-09 | Profiles that can hold custom fields, replacing the directory form run every semester | **First release** (LEG-F-014) | The directory form is filled in by everyone twice a year, so this pays for itself in the first term. The current system can already do it (F-17), so open that with the pledge trainers before building anything |
| ASK-10 | A role and permission system that is not tied to officer titles | **First release** (rules R-17 and R-19, model set out in section 4.6) | Half of this already works: the chapter ticks which permissions each position gets, and that is kept. What changes is that permissions are grouped into named roles, and a role can be given to a position or to one person without an officer title (F-19). The shape is cheap to get right now and expensive to change later |
| ASK-11 | Two-way Google Calendar integration | Split. **Second release:** a calendar members subscribe to, so chapter events appear in their own calendar. **Decision D-13:** whether the product reads a member's own calendar | Publishing a feed is small and solves most of the complaint. Reading someone's personal calendar is a much larger piece of work and it means holding their private schedule |
| ASK-12 | Event suggestions based on when a member is free, and a weekly digest of events that fit their open time | Split. **Second release:** a weekly digest of upcoming events, with no matching against free time. **Not planned:** the matching itself, pending decision D-13 | The digest is useful on its own. Matching needs each member's real schedule, which is a privacy question before it is a feature |
| ASK-13 | A public calendar for chapter and interchapter events that anyone can subscribe to, including people outside the organisation | **Second release** | Small once the feed in ASK-11 exists, and it also answers ASK-21 |
| ASK-14 | Seeing other chapters' events, including whether something counts as an interchapter event | Split. **First release:** marking an event as earning interchapter credit, which the chapter already tracks as a credit type (LEG-F-043). **Not planned:** seeing other chapters' events | Seeing other chapters' events needs those chapters to use the same system. The feedback says they largely do not: the Region B calendar is empty and most chapters' sites are down (FB-22). The public feed in ASK-13 is the part that works without them |
| ASK-15 | Attendance submitted inside the app instead of on Google Forms | **First release** (section 5.1) | This is the process that is failing today (F-18). Note what it is not: the member reports attendance, and credit still comes from the event. Members never write credit (decision D-01) |
| ASK-16 | A pending state showing attendance submitted and credit owed | **First release** (rule R-16, section 5.1) | Not knowing whether you were credited is the most common complaint (FB-20) |
| ASK-17 | A photograph an officer reviews to check who was there | **First release** (decision D-14) | Moved up: proof of attendance is part of the flow the chapter described, so file storage is in the first release when nothing else needs it. Photographs are seen only by the approver and the member who submitted them, and are deleted at the end of the term |
| ASK-18 | Credit posted immediately on approval, with an override for an officer | **First release** (section 5.1) | This is how the approval step works. The override already exists today as adding a member by hand |
| ASK-19 | A public shop or marketplace for chapter gear | Decision D-12. Our recommendation is a separate project, not part of this product | A shop means stock, orders, postage and taking card payments from the public, which this plan otherwise avoids (LEG-F-081) |
| ASK-20 | A rebuild of the chapter's main public website, currently on Weebly | Separate project, out of scope here | It is a public website, not a membership system. Worth doing, and not this |
| ASK-21 | A public calendar of upcoming events embedded on that main website | **Second release**, served by the feed in ASK-13 | One feed serves both the members' own calendars and the public site |
| ASK-22 | Positions that anyone in the chapter can hold without becoming an officer or joining the executive board, while other chairs stay on the board | **First release** (section 4.6) | Today every one of the 19 positions is an officer position, so the only way to give somebody a job with any access is to make them an officer. The chapter wants broad involvement without an inflated board, and wants to keep the chairs that belong on it (F-24) |
| ASK-23 | Committees or teams, each with a head, holding the chair positions underneath | **First release** as groups (section 4.6) | The head is one of the group's own positions, so it changes at handover on its own |
| ASK-24 | More than one person holding the same position | **First release** (rule R-21) | This already works in the current system and would be easy to lose in a rebuild |
| ASK-25 | Permissions that can be given to a group, to a position, or to one person | **First release** (rule R-19, section 4.6) | One rule resolves all three: everything in every role that reaches you, by any of the three routes |
| ASK-26 | The chapter chooses what its groups are called, so committee, team, board or anything else all work | **First release** (rule R-20) | The software holds no list of allowed kinds. A group is a row the chapter creates and names, which is what makes the model survive a reorganisation |
| ASK-27 | A permission that requires approval from an officer, or does not, depending on a setting, on any permission rather than a chosen few | **First release** for creating things, on any permission. Changing and deleting are in the backlog (decision D-16) | Our first answer was to build this for a named few actions. That was based on assuming a separate design per action. Built once as a general mechanism, a proposal is recorded, waits, and is carried out on approval, which costs less than four special cases and does more |
| ASK-30 | Members filtering events by type, by any requirement the event credits, and by whether it awards credit at all | **First release** (section 4.4) | Three filters that combine. The third one separates "what can I do to finish my service hours" from "what is on this Friday" |
| ASK-29 | Events that always belong to at least one requirement, whether or not they award credit, with one marked as primary and any number of secondary ones | **First release** (rules R-23 and R-25, section 4.4) | The primary gives every event one place on the calendar and one owner. The secondary lines are what let a search for leadership credit return a fellowship event. It also removes the "Other Events" bucket and the separate permission for managing it (F-25) |
| ASK-28 | The ability to run without committees at all, for a chapter that does not want them | **First release** (section 4.6, limit 3) | The group layer is always present, and a chapter can have exactly one group and never meet the idea again. That is simpler than making it optional, because optional means every screen has to work both ways |

### 7.2 Technical and delivery matters, recorded and not decided here

These are real and they are not product decisions. They are recorded so that they are not
lost, and so that nobody mistakes silence for disagreement.

| Matter | What is recorded |
|---|---|
| The technology it is built with (ASK-01) | Not decided in this document. What the product must do does not depend on it. Two things in this plan do constrain it: every permission is checked on the server (R-12), and the record of who did what is written in the same step as the change it describes (R-13) |
| Endpoints that cannot be called by just anyone (ASK-02) | The requirement is rule R-12. It is not a separate feature; it is a property every feature has to have. Each permission check should have a test that fails if the check is removed |
| Handing the project on each year (ASK-05) | Not decided here. It raises the value of two things already in the plan: written guidance for users (F-16) and the audit log (LEG-F-112). It also argues for keeping the first release small enough that one person can understand all of it. Note that officers turn over every semester, faster than the people maintaining the code |
| Whether the current system's endpoints really are open (FB-02) | Not tested, and deliberately not to be tested. See finding F-22 in the review. If the chapter wants to know, the question goes to the vendor in writing |
| The claim that the current product has barely changed in ten years (FB-23) | Partly correct, and the distinction matters. The vendor's release notes run from 2018 to 2026 and list many additions. What is true is that little has changed in what this chapter uses daily, and several newer features are charged as extras |

---

## 8. Decisions the product owner has to make

Each decision below changes what gets built. Our recommendation is given, and it is only a
recommendation. The decision line is empty and is for the product owner to complete.

Decisions D-01 to D-04 should be made before building starts, because the answers change
the shape of the data. The rest can be made during the first release.

### D-01: Can members record their own hours? **Decided**

**The question.** When a member does service outside a chapter event, do they enter it
themselves for an officer to approve, or does an officer enter it?

**Why it matters.** It changes who does the typing, how quickly a member sees their
progress, and whether an approval step has to be built.

**The options.** (a) Officers only, as today. (b) Members submit, officers approve.
(c) Members submit and it counts immediately.

**Our recommendation:** (b), **in the first release**, with the choice available per
requirement so the chapter can switch it on for service hours and off for meetings.

**This recommendation changed after the feedback.** It was originally second release, on the
grounds that the current chapter has switched member self-entry off and the current system
labels the setting "not recommended". The feedback shows the chapter already does exactly
this outside the system, on Google Forms with a photograph, and that not knowing whether you
have been credited is the most common complaint (F-18, FB-19, FB-20). Building it in is not
a new behaviour; it replaces one that already exists and is not working.

**If the answer is (a),** LEG-F-035 leaves the plan, officers keep all data entry, and the
chapter should expect the Google Form to stay.

**Decision:** No. A member never writes credit. Credit comes from an event that awards it, or
from an officer or chair who holds the permission for that requirement. What a member can do is
submit **attendance** at an event, with proof, which somebody approves; the credit then follows
from the event. LEG-F-035 leaves the plan.

*This differs from our recommendation*, which was to let members submit credit for approval.
The chapter drew a line the recommendation had missed: reporting that you were somewhere is not
the same as deciding what it is worth.
**Decided by:** Kingsley Ramos, project owner.   **Date:** 4 September 2026

### D-02: Do we record who signed up and did not come? **Decided**

**The question.** Keep two lists per event (sign-up and attendance), or one, as today?

**Why it matters.** It is the one piece of information the current system loses forever
(F-01). It also means an officer confirms an attendance list rather than editing a sign-up
list.

**The options.** (a) Two lists. (b) One list, as today.

**Our recommendation:** (a). The extra work for an officer is close to zero, and the
information cannot be recovered later.

**If the answer is (b),** rule R-01 is withdrawn and the attendance report (LEG-F-111)
loses most of its value.

**Decision:** One list, and nobody is deleted from it. Everyone on an event's list has a state:
signed up, then present or absent. The officer ticks people off when closing the event, and
somebody who signed up and did not come is marked absent rather than removed. Both facts are
kept without a second list to manage.
**Decided by:** Kingsley Ramos, project owner.   **Date:** 4 September 2026

### D-03: Is dues tracking in the first release? **Decided**

**The question.** Does the first release include what members owe and what they have paid?

**Why it matters.** It is a whole area of screens, and the two planning documents already in
this repository disagree. The feature inventory calls dues tracking essential; the scope
document puts it in the second release.

**The options.** (a) In the first release: what is owed, payments, balances.
(b) Second release, with the Treasurer using a spreadsheet for one more term.

**Our recommendation:** (a). Dues is one of the two things a member most wants to check, and
the Treasurer is otherwise the officer most likely to keep a separate spreadsheet, which is
the failure the whole project is trying to avoid.

**If the answer is (b),** five features move out of the first release (LEG-F-071, 073, 075,
076, 077) and the first release is roughly a fifth smaller.

**Decision:** First release. What is owed, payments, balances and one-off fees.
**Decided by:** Kingsley Ramos, project owner.   **Date:** 4 September 2026

### D-04: Which of the eighteen requirements move across? **Decided**

**The question.** The chapter has 18 requirement types, several with overlapping names
(F-10). Which of them exist in the new product on day one?

**Why it matters.** Every requirement adds a progress bar for every member and a permission
for every position. Eighteen is a lot to look at.

**The options.** (a) Move all 18. (b) Move the ones used in the last two terms and archive
the rest. (c) Start with a short list agreed with the chapter and add more as needed.

**Our recommendation:** (b), with a count of credits per requirement over the last two terms
to decide which those are.

**If the answer is (a),** the ability to retire a requirement (F-10) becomes more urgent,
not less.

**Decision:** None of them. Requirements are built fresh in the new product, and the chapter
can add and remove them at any time. This follows from D-06: there is no data migration in this
project.
**Decided by:** Kingsley Ramos, project owner.   **Date:** 4 September 2026

### D-05: Does taking an officer position change what a member owes? **Decided**

**The question.** Today, taking a position changes a member's account type to "Officer",
which changes their requirement targets as a side effect (F-05). Should officers owe
different amounts?

**Why it matters.** It is currently happening without anyone deciding it, and it makes some
real situations impossible to record.

**The options.** (a) No. Account type and positions are independent. (b) Yes, and it becomes
a deliberate setting on each requirement.

**Our recommendation:** (a), with (b) available later if the chapter asks for it.

**Decision:** Targets are built up rather than set one cell at a time.

| Where a target comes from | How it works |
|---|---|
| The account type | The base. Account types can build on one another, so an officer who is also an active member owes everything an active member owes |
| A position or a group | Adds targets of its own. This is how a chair-specific requirement works without changing anybody's account type |
| A per-member override | Whoever manages a requirement can set one member's target higher or lower, for any reason. The override records who set it and why |

**How account types build on one another** (4 September 2026). Account types form a **tree of
any depth**. A type builds on **at most one** other type, or on none, and the software refuses
an arrangement that loops back on itself.

**The shape of that tree is the chapter's, and it can be rearranged later.** The chapter gave
two arrangements to show what the software must not care about. One is roughly today:

| Account type | Builds on | Its own targets |
|---|---|---|
| Active | nothing | the chapter's base requirements |
| Officer | Active | anything extra asked of officers, on top of everything an active member owes |
| Pledge | nothing | its own, deliberately not the active member ones |
| Associate | nothing | none. A type is allowed to owe nothing |

The other is a deeper tree the chapter may want later, with a base that everybody shares:

```
Member            the requirements everyone owes
├── Active        adds what is asked of active members
│   └── Officer   adds what is asked of officers, on top of both
└── Pledge        adds what is asked of pledges
```

Nothing in the product should assume either shape, or a fixed number of layers. A type that
should owe nothing still builds on nothing, which is how Associate stays empty even when a
base exists.

**Rearranging the tree changes what people owe**, which is why rule R-27 applies to it: moving
a type to a different parent shows how many members are affected and how their targets change,
before it saves. Without that it is the same trap as the term dates screen, where two fields
quietly move every progress bar in the chapter (F-03).

Committees and teams sit on top of this rather than inside it. Their members hold whatever
account type they hold, and the group may add a requirement of its own or none at all.

**A type can override what it inherits** (corrected 4 September 2026). An earlier version of
this decision said building up could only add, and that anything lower had to be a per-member
override. That was too narrow. A type can raise an inherited target, lower it, or remove the
requirement from itself entirely, so Pledge can owe less than Member on one requirement and
nothing at all on another.

Per-member overrides still exist and still win over everything, because they are a decision
about one person rather than about a category (rule R-26). Between them, the two kinds of
override remove any reason to invent an account type such as Half-Active for a single case.

Section 4.3 sets out the order in which the three sources are resolved.

Taking an officer position still never changes a member's account type, so LEG-F-068 stays
dropped. The two answers fit together: a position can carry requirements of its own without
rewriting who the person is.
**Decided by:** Kingsley Ramos, project owner.   **Date:** 4 September 2026

### D-06: How much history moves across from the current system? **Decided**

**The question.** The current system holds 589 member records and years of credit.

**Why it matters.** It is the largest piece of one-off work in the project, and the current
system's history is not shaped the way the new one stores it (there is no record of account
type per term, so past terms cannot be reconstructed exactly).

**The options.** (a) Current members only, with no credit history. (b) Current members with
their credit history. (c) Everything, including alumni.

**Our recommendation:** (b). Alumni records can be exported and kept as a file until someone
asks for them.

**If the answer is (c),** expect the import to take significantly longer, and expect the
account type of past terms to be unknown.

**Decision:** None, in this project. The work is building the platform. Data migration is a
separate exercise afterwards, planned once the platform exists. Test data is fine during the
build.

This also settles D-04 and D-11, and defers D-10.
**Decided by:** Kingsley Ramos, project owner.   **Date:** 4 September 2026

### D-07: Do members keep a way to send anonymous feedback? **Decided**

**The question.** The current system has an anonymous comment form. On this chapter only the
"Bad Standing" account type can use it, which looks like a configuration mistake (F-07).

**Our recommendation:** drop it from the product (LEG-F-092) and use a separate anonymous
form tool, which most institutions already provide. But ask the chapter first, because an
anonymous route can matter more than its usage numbers suggest.

**Decision:** Replaced by something larger. The chapter wants a **form tool**, with permissions
on who can see the results, email when a form is submitted, a choice between anonymous and
signed-in, and the option to open a form to people outside the chapter. Anonymous feedback to
officers is then one form among many rather than a feature of its own.

The form tool is the second release (LEG-F-106). **In the first release a form is a link to an
external one**, such as a Google Form, and that route stays available afterwards for anyone who
prefers it.

*This differs from our recommendation*, which was to drop anonymous feedback and use an outside
tool. The chapter agreed about the outside tool for now, and wants the general capability
later.
**Decided by:** Kingsley Ramos, project owner.   **Date:** 4 September 2026

### D-08: Which position is responsible for approving new members? **Decided**

**The question.** Today the notification goes to whichever positions hold every permission,
which on this chapter is five of them (F-07). Seven people were waiting at the time of the
review, and nothing shows how long they had waited.

**Our recommendation:** name one position (the Membership Vice President would be the
obvious choice on this chapter) and send the notification there, with a second position as a
backup.

**Decision:** There is no queue, because there is nothing to approve. The system is
**invite-only**. There is no public registration link. Somebody joins because an officer invites
them or imports a roster; the invitation is the decision. LEG-F-002 and LEG-F-003 both leave the
plan, and section 5.3 shrinks to two steps.

*This differs from our recommendation*, which was to name one position as owner of the queue.
Removing the queue removes the problem instead.
**Decided by:** Kingsley Ramos, project owner.   **Date:** 4 September 2026

### D-09: Who has to use a second sign-in step? **Decided**

**The question.** The current system has no second step of any kind (F-13). Who should be
required to use one in the new product?

**The options.** (a) Everyone. (b) Anyone who can change permissions or record money.
(c) Nobody, but offer it.

**Our recommendation:** (b). It protects the accounts that matter without making sign-in
harder for a member checking their hours.

**Decision:** Nobody, in the first release. The second sign-in step goes to the backlog. The
limit on password length still goes.

*This differs from our recommendation*, which was to require it for anyone who can change
permissions or record money. Until it is built, every account including those is protected by a
password alone. That is the same position as today, so the new product is no worse, and finding
F-13 stays open rather than being closed by this decision.
**Decided by:** Kingsley Ramos, project owner.   **Date:** 4 September 2026

### D-10: Does the new product replace the current one at once, or run alongside it? **Decided**

**The question.** For the first semester, is the new product the only system, or does the
chapter keep using the current one as well?

**Why it matters.** Running both means entering everything twice, which nobody sustains for
long. Switching at once means the first term has no fallback.

**Our recommendation:** switch at the start of a term, keep read-only access to the current
system for one term, and agree in advance what would count as a reason to switch back.

**Decision:** Deferred. The question depends on migration, and there is none in this project
(D-06). It is answered when the platform exists and a migration is being planned.
**Decided by:** Kingsley Ramos, project owner.   **Date:** 4 September 2026

### D-11: What happens to the 523 alumni records? **Decided**

**The question.** Alumni are 89% of the records and there is no evidence any of them use the
system.

**Our recommendation:** export them, keep the export, and do not build alumni features until
someone asks. Revisit if the chapter says alumni engagement matters, in which case the
directory (LEG-F-021) is the first thing to build.

**Decision:** Nothing, for now. They stay in the current system. This follows from D-06.
**Decided by:** Kingsley Ramos, project owner.   **Date:** 4 September 2026

### D-12: Do we build a public shop? **Decided**

**The question.** Students asked for a public shop for chapter gear (ASK-19, FB-21). The
current product has one, but it is not switched on for this chapter, which is why it is
reported as missing.

**Why it matters.** Selling online means stock, orders, postage and taking card payments
from the public. This plan otherwise avoids taking card payments at all (LEG-F-081). Putting
a shop inside the membership system means the membership system starts handling money from
people who are not members, which changes what has to be protected.

**The options.** (a) Not in this product. Use an existing shop tool and link to it from the
site. (b) A separate project later, with its own decisions. (c) Build it into this product.

**Our recommendation:** (a) to start, moving to (b) if gear sales matter enough to justify
the work. Not (c).

**Decision:** A separate project later, with its own decisions about taking payments. Not part
of this build.
**Decided by:** Kingsley Ramos, project owner.   **Date:** 4 September 2026

### D-13: How far does calendar integration go? **Decided**

**The question.** There are three levels, and they are very different in size. (1) The
product publishes a calendar that a member subscribes to once, so chapter events appear in
their own calendar. (2) The product also reads the member's own calendar, so it can show
conflicts or suggest events that fit their free time. (3) Full two-way synchronisation.

**Why it matters.** Level 1 is small and it solves most of what was asked for (FB-16,
FB-17). Level 2 means the product holds a member's personal schedule, which is information
about their classes, their job and their private life. Level 3 adds handling for changes made
in both places at once, which is where this kind of feature usually goes wrong.

**Our recommendation:** level 1 in the second release. Ask members whether they would give
the product access to their own calendar before planning level 2; many will not. Do not plan
level 3.

**If the answer is level 2 or 3,** ASK-12 (suggesting events that fit free time) becomes
possible, and a privacy decision about storing personal schedules has to be made with it.

**Decision:** Publish a calendar that members subscribe to once, so chapter events appear in
their own calendar. Two-way synchronisation goes to the backlog. Reading a member's own calendar
is not planned.
**Decided by:** Kingsley Ramos, project owner.   **Date:** 4 September 2026

### D-14: Do we store photographs as evidence of attendance? **Decided**

**The question.** Attendance is verified today with a photograph (FB-19). Should the product
store those photographs?

**Why it matters.** It means holding images of members, deciding who can see them, and
deciding when they are deleted. It also needs file storage, which nothing else in the first
release needed at the time this question was asked.

**The options.** (a) No photographs. A submission carries a written note. (b) Photographs
stored, visible only to the officer approving, deleted at the end of the term. (c)
Photographs kept indefinitely.

**Our recommendation:** (a) in the first release, (b) in the second. Before building either,
find out what the photograph is actually checking. If it is checking that the member was
really at the event, checking members in at the event (LEG-F-061) removes the need for it.

**Decision:** Photographs are visible to whoever approves the attendance and to the member who
submitted them, and are deleted at the end of the term. Because proof of attendance is in the
first release, so is file storage.
**Decided by:** Kingsley Ramos, project owner.   **Date:** 4 September 2026

### D-15: How much of the structure does a chapter see on day one? **Decided**

**The question, as it was asked.** The model in section 4.6 has groups holding positions. How
visible is that on the first day, for a chapter that may have two committees or twelve?

**The question was built on a wrong assumption**, and the answer says so. How many committees
and chairs there are is not a design input. There may be one committee or many, one chair or
twenty, and the same is true of any other chapter that ever uses this software.

**Decision:** the group layer is always fully present, and no screen assumes a number. The
first release ships with all 19 of this chapter's existing positions in a single group,
because that is the truth today, and creating committees is the chapter's own first piece of
work rather than a condition of starting. The option of making the layer something an
administrator switches on and off is rejected, because optional means every screen has to work
both ways.
**Decided by:** Kingsley Ramos, project owner.   **Date:** 4 September 2026

### D-16: Which permissions can require somebody's approval? **Decided**

**The question.** Which actions can be granted as "may propose it, somebody approves" as well
as "may do it"?

**What we recommended first, and why it was wrong.** We recommended a named few: submitting
your own credit, joining the chapter, creating an event, and spending against a budget. That
was based on assuming each one would be designed and built separately, so four of them is a
feature and seventy-nine is a different product. Built once as a general mechanism instead, a
proposal is recorded, it waits, and it is carried out on approval, and then the number of
actions it covers barely affects the cost.

**Decision, in five parts:**

| Part | What was decided |
|---|---|
| **Which permissions** | Any of them. Approval is a setting on each grant, chosen separately for every permission a person is given. Anything an officer can do, a chair can be given either directly or with approval |
| **Which kinds of action, in the first release** | Creating things. Changing and deleting move to the backlog, and until then a person either may change a record or may not, with no middle setting |
| **Who approves** | Named when the role is granted. The approver can be a person, a position or a group. The software warns when the named approver cannot perform the action themselves, and nobody approves their own proposal |
| **Whether a waiting item is visible** | A setting. A proposed event can appear on the calendar marked as not yet confirmed, or stay hidden until approved. Chapter-wide default, changeable per event |
| **Whether members can sign up while it waits** | No, for now. A visible proposed event shows what is coming but does not accept sign-ups until it is approved |

**Decided by:** Kingsley Ramos, project owner.   **Date:** 4 September 2026

**What this commits the build to.** Every action that writes something has to be recordable as
a proposal that can be carried out later. That is a decision about how the whole product is
built, and it cannot be added afterwards without revisiting every write.

**The risk to watch.** An approval queue that nobody works recreates the problem it was built
to solve. The complaint today is that credit waits two days because an officer has not got to
it (F-18). If a chair's proposal now waits for the same officer, the delay has moved rather
than gone. Rule R-24 exists because of this: waiting items are visible, with their age, to the
people who can approve them.

**The one part marked "for now".** Sign-ups being closed on a waiting event is a decision to
revisit, not a rule. What would reopen it is evidence that approvals arrive late enough to
cost real sign-ups. If that happens, the answer is more likely to be making the queue harder
to ignore (rule R-24) than opening sign-ups on events that might be rejected.

---

## 9. Where every existing feature ends up

Every one of the 131 features in the review appears exactly once below. This is the check
that nothing was quietly dropped.

| Destination | Count | Feature identifiers |
|---|---|---|
| **First release** | 60 | LEG-F-001, 004, 006, 007, 008, 009, 010, 012, 013, 014, 016, 026, 027, 028, 029, 030, 033, 034, 036, 037, 038, 039, 040, 041, 042, 043, 044, 046, 047, 051, 052, 054, 055, 056, 058, 063, 064, 065, 066, 067, 069, 070, 071, 073, 075, 076, 077, 088, 089, 110, 112, 114, 116, 117, 118, 119, 120, 121, 123, 131 |
| **Second release** | 26 | LEG-F-011, 018, 022, 031, 048, 050, 059, 061, 062, 078, 079, 085, 090, 092, 094, 095, 096, 099, 101, 104, 106, 109, 111, 115, 122, 130 |
| **Worth building, not scheduled** | 6 | LEG-F-019, 021, 023, 080, 086, 098 |
| **Not planned** | 28 | LEG-F-002, 003, 015, 020, 024, 025, 032, 035, 045, 049, 053, 057, 060, 068, 074, 081, 082, 083, 087, 093, 097, 100, 102, 103, 105, 107, 108, 113 |
| **Out of scope (exists only for many chapters)** | 11 | LEG-F-005, 017, 072, 084, 091, 124, 125, 126, 127, 128, 129 |

60 + 26 + 6 + 28 + 11 = 131.

**What the feedback and the decisions changed.** Recorded here because a plan that changes
without saying so cannot be trusted. Two features were added that the screen review had not
recorded, and one moved twice.

| Feature | Was | Now | Why |
|---|---|---|---|
| LEG-F-035 (members record their own credit) | Second release, then First release, now **Not planned** | Not planned | The feedback moved it in, because the chapter already does this outside the system on Google Forms. Decision D-01 then took it out: a member reports **attendance**, and credit comes from the event or from somebody with the permission. The distinction is the point, not a reversal |
| LEG-F-088 (announcements) | Second release | First release | The feature exists and is believed not to. Announcements have moved to Discord and get lost (F-17) |
| LEG-F-014 (chapter-defined profile fields) | Not scheduled | First release | A separate directory form is filled in by everyone twice a year because of this (FB-14) |
| LEG-F-104 (chapter file store) | Not scheduled | Second release | People constantly ask where the bylaws are (FB-11) |
| LEG-F-061 (checking members in at events) | Not scheduled | Second release | It removes the step that is failing today (F-18) |
| LEG-F-130 (calendar link on an event) | Not recorded at all | Second release | The screen review had missed it. The feedback named it (FB-16) |
| LEG-F-131 (the member home page itself) | Not recorded at all | First release | The review had described the things on the page but never the page, so it never asked whether the chapter can change it. It cannot (F-23) |
| LEG-F-026 (the free-text chair title) | Not planned, purpose unknown | First release, as a replacement | The chapter explained it on 4 September 2026. It is the current system's stand-in for a chair who holds no officer position, and the groups model replaces it properly (F-24) |

Features that move between destinations depending on a decision in section 8:

| Feature | Moves if |
|---|---|
| LEG-F-035 (members record their own hours) | D-01 answers (a): leaves the plan entirely |
| LEG-F-071, 073, 075, 076, 077 (dues) | D-03 answers (b): move to the second release |
| LEG-F-092 (anonymous feedback) | D-07 answers "keep": moves to the second release |
| LEG-F-021 (alumni directory) | D-11 says alumni engagement matters: moves to the second release |
| LEG-F-083 (a shop) | D-12 answers (b) or (c): becomes a separate project, or joins this one |
| LEG-F-130 (the calendar) | D-13 answers level 2: grows from publishing a feed to reading a member's own calendar |

The 30 requests in section 7 are tracked separately, because they are not features of the
current system. Section 7 says, for each one, whether it lands in a release, is split across
two, is a decision, is a technical or delivery matter, or belongs to a separate project.

---

## 10. What to check with real people before building

All sixteen decisions in section 8 are made. What is still missing is anyone being watched
doing the work, and any count of how often things happen. Most of the list below shrank when
the decisions were taken, because a decision about what to build removes the need to research
what to build.

**Nothing here blocks starting.** These are checks that make the first release better, not
prerequisites for it.

### Three conversations, thirty minutes each

| Who | What to ask them to do | What it would improve |
|---|---|---|
| An officer who runs events | Walk through running one event end to end, from creating it to writing everybody's credit today | Whether the flow in section 5.1 matches the real one, and what the photograph is actually being checked for |
| The Treasurer | Show how they record a payment today, including anything kept outside the system | Whether the money screens in section 4.5 match how they work |
| Two members, separately | Show how they check whether they are behind, and what they would want on the page they land on | The blocks on the landing page (section 4.8), and whether the progress screen answers their question |

### Two counts, if they are easy to get

| Count | What it would improve |
|---|---|
| Members who signed in at least once last term | Whether the current product is used by members or only by officers. It sets expectations for the new one |
| How common events that count towards nothing are today | How much rule R-23 changes officers' habits. Nothing depends on the answer |

### One review to run

Show the review's finding F-07 (five of nineteen positions can do everything, one can do
nothing, two permissions held only by members in bad standing) to the president and the
advisor, and ask which of it was intended. With no migration this no longer decides what gets
carried across, but it is the clearest example of what goes wrong without a screen that shows
who can do what, which section 4.6 puts in the first release.

### What the decisions removed from this list

| Was going to be checked | Why it no longer matters |
|---|---|
| Which of the 18 requirements are still in use | None of them move across. The chapter builds its list fresh (D-04) |
| How much history to bring over | None, in this project (D-06) |
| Whether officers want member self-entry of hours | Decided: they do not (D-01) |
| Who should own the approval queue | There is no queue (D-08) |
| Whether members can sign up to an event awaiting approval | Decided: no, for now (D-16) |

---

## 11. Keeping these two documents honest

- **The review describes what exists. This document says what to do.** New evidence about
  the current system goes in the review. New decisions go here.
- **Three sets of identifiers, and they do not mix.** `LEG-F-` is a feature of the current
  system (review, section 6). `FB-` is an item of feedback from someone who uses it (review,
  section 5.1). `ASK-` is a request for the new product (section 7 here). A request is not a
  feature until it is in section 9.
- **Identifiers never change or get reused.** If a feature is split, the original identifier
  stays with the larger half and the new part gets the next free number.
- **When a decision in section 8 is made, write it in the decision line and change section
  8 in the same edit.** A decision recorded in one place and not the other is worse than no
  record at all.
- **Neither document should ever state as fact something that was not seen.** The review
  labels every statement. If something here starts to sound certain and has no support in
  the review, it should be marked as a recommendation or removed.
- **Feedback is evidence about experience, not about frequency.** It tells you that
  something is a problem, not how often or for how many. When a count becomes available,
  record it next to the feedback item rather than replacing it.
- **When a plan changes because of new evidence, say so where the change is.** Section 9
  carries the list of what the feedback moved, and D-01 says why our recommendation
  reversed. Keep doing that.
