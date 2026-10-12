# What to build, and what not to

> Summary: The features version one includes, the features left for later, and the
> features to skip entirely. Version one is a system the chapter can use for a full
> semester.
> Status: DESIGN
> Read this if: you are deciding how much to build.
> Depends on: docs/05-rebuild-plan/00-feature-inventory.md

## The rule for deciding

Build the smallest system that a real officer would actually use to run a semester. Every
feature past that point waits until the core works and real people are using it.

The reason is that unfinished projects help nobody. A small system that officers use
beats a large system that never launches. Students consistently overestimate how much
they can finish, so version one should feel almost too small.

## Version one: build this

This is the core. The system does not work without all of it.

- Members, with contact details.
- Terms, with the current term marked.
- Membership by term: each member's status in each term.
- Account types and their privileges: what an ordinary member of each kind may do.
  (Added after the walkthrough; the real site has this grid and we had missed it.)
- Officer positions and privileges: the chapter defines its own, and assigns members to
  positions each term.
- Login, using the positions to decide what each person can do.
- Events, with a kind and a time.
- Attendance: recording who came to each event.
- Requirements: the chapter sets its own. A requirement is written once and does not
  belong to a term; the term sets the window of dates whose credits count toward it.
  (Corrected after the walkthrough; see docs/02-data-model/02-questions-answered.md.)
- Credits: members earn progress toward requirements, from events or by an officer adding
  them by hand.
- One progress page: for each member, how far along they are on each requirement.

When this works and officers are using it, version one is done. Stop and let it settle
before adding anything.

## Version two: build later

Add these once version one is running and used, roughly in this order.

- Alumni view: members whose latest status is alumni.
- Signups: members saying in advance they will attend an event.
- Dues tracking: what each member owes and what they have paid.
- Meeting minutes: notes attached to a meeting.
- Reminder emails: the first feature that needs the scheduler and email service.
- Mass email to a filtered group of members.
- Family tree: big and little relationships.
- Awards on member profiles.
- A record of money in and out, and budgets per position.

None of these block the core. Each is useful on its own and can be added when someone
wants it.

## Skip entirely

These exist in APOonline. For one chapter they cost far more than they return.

- Collecting dues online by card. Record who paid instead, and collect the money the way
  the chapter already does. Card payments bring security requirements that are not a
  student project.
- Photo albums. Needs file storage, image resizing, and moderation.
- Chapter blog and activity feed. Other tools do this better.
- Custom colors and themes.
- The national reporting formats (CoE and PPoE), unless your chapter actually files them.
  Build the general progress page first.
- Anything to do with sections, regions, or a national office. The system serves one
  chapter.

## The single most important thing to get right

Two design choices, if gotten wrong, are expensive to fix later. Get them right in
version one:

1. Store membership status per term, not as a single field on the member.
2. Keep attendance and credit in separate tables.

Both are explained in `docs/02-data-model/00-domain-model.md`. They are the reason to
document the data model before writing code.
