# Build order

> Summary: The order to build version one in, as a series of steps that each produce
> something you can see working. Each step depends on the ones before it.
> Status: DESIGN
> Read this if: you are planning the work or dividing it among students.
> Depends on: docs/05-rebuild-plan/01-scope.md

## How to use this

Each milestone below produces something a person can look at and use, however small. Do
not move to the next one until the current one works end to end. This keeps the project
always in a working state, which is the best protection against running out of time with
nothing to show.

Do not build all the tables first and all the pages later. Build one slice at a time,
from database to screen.

## Milestone 1: members you can see

Set up the project, the database, and login. Build the member list and the ability to add
and edit a member.

When this works: you can log in, see a list of members, and add one. Done first because
everything else attaches to members.

## Milestone 2: terms and membership

Add terms, and mark one as current. Give each member a status in the current term.

When this works: the roster shows each member's status for the current term, and you can
change it. This proves the per-term design before anything depends on it.

## Milestone 3: positions and permissions

Add account types with their privileges, then officer positions with theirs. Assign
members to positions for the current term. A member's permissions are the union of the two.
(The account-type grid was added to this milestone after the walkthrough.)
Make the login use these: a member sees and can do only what their positions allow.

When this works: an officer and a regular member see different things. This is the
security core, and everything after it relies on the permission check being real.

## Milestone 4: events and attendance

Add events. On an event, record who attended.

When this works: you can create an event and mark attendance. No credit yet, just the
record of who showed up.

## Milestone 5: requirements and credits

Add requirements, each with a target per account type. Make completing an event award
credit to its attendees. Add the ability
for an officer to grant credit by hand.

When this works: attending an event moves a member's numbers. This connects events to
requirements, which is the point of the whole system.

## Milestone 6: the progress page

Build the page that shows, for each member, how far along they are on each requirement.

When this works: version one is complete. An officer can see at a glance who has met their
requirements and who has not. Stop here and have real officers use it for a while.

## After version one

Only after officers have used version one for real should you start on the version two
features in `docs/05-rebuild-plan/01-scope.md`. Add them one at a time, the same way:
database to screen, finished before the next.

## Two things that look harder than they seem

Warn the team about these before they hit them:

1. **The permission check in milestone 3.** It is tempting to just hide buttons. That is
   not security. The check must run on the server for every action. See
   `docs/04-system-design/01-architecture.md`.

2. **Credit when attendance changes in milestone 5.** If an officer marks someone present
   and then corrects it to absent, the credit that attendance earned has to go away too.
   Decide how this works when you build it, not after.
