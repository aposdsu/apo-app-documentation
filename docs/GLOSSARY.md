# Glossary

> Summary: Plain definitions of the terms used across this documentation. When a
> document uses a word from this list, this is what it means.
> Status: REFERENCE
> Read this if: a term in another document is unfamiliar.

## About the system

**Chapter.** One local group of Alpha Phi Omega. This system serves one chapter.

**Member.** A person in the chapter. Stays in the system across many terms.

**Term.** One semester, such as Fall 2026. Most information belongs to a term.

**Officer or position.** A job in the chapter, such as President or VP of Service.
Chapters define their own.

**Privilege.** One thing a person is allowed to do in the system, such as creating events
or managing a requirement. On the real APOonline site, privileges come from two places:
the member's account type and the officer positions they hold. See
docs/04-system-design/02-auth-and-permissions.md.

**Account type.** The chapter's own category for a member, such as Active, Associate or
Leave of Absence. It sets both what the member owes and what the member may do.

**Membership status.** The national organisation's category for a member: Active, Alumni,
Deceased, Inactive, PNM or Prospect. Every account type maps to exactly one of these.

**Requirement.** A rule a member must meet, such as 20 service hours. The rule itself is
written once and does not belong to a term; what a term does is set the window of dates
whose credits are counted.

**Credit.** Progress a member earns toward a requirement, such as 3 service hours from an
event.

**Attendance.** A record of whether a member showed up to an event. Different from credit.

**Dues.** Money a member owes the chapter for a term.

## About data

**Entity.** A kind of thing the system stores, such as a member or an event. Usually
becomes one database table.

**Field.** One piece of information about an entity, such as a member's email. Usually
becomes one column.

**Table.** A grid in the database. Each row is one entity, each column is one field.

**Row.** One record in a table, such as one member.

**Column.** One field across every row, such as every member's email.

**Relationship.** How two entities connect, such as a member attending many events.

**Join table.** A table that exists to connect two other tables. To record which members
attend which events, you need a third table with one row per member per event.

**Foreign key.** A field in one table that points at a row in another table. The credit
table has a member foreign key saying which member earned the credit.

**Primary key.** The field that uniquely identifies a row, usually called id.

**Schema.** The full design of the database: every table, field, and rule. Ours is in
`docs/02-data-model/proposed-schema.sql`.

**Constraint.** A rule the database itself enforces, such as "an email cannot be blank"
or "a payment amount cannot be zero." Constraints catch bad data early.

**Enum.** A field that can only be one of a fixed set of values, such as attendance being
present, absent, excused, or late.

**Nullable.** A field that is allowed to be empty. A member's phone number is nullable; a
member's name is not.

## About building

**Migration.** A recorded change to the database structure. You keep every migration and
never edit one after it has run, so the database's history is always clear.

**Server.** The computer running the application, which the user does not control. Rules
enforced here cannot be bypassed.

**Client or browser.** The user's side. Anything here can be inspected or bypassed, so it
is never trusted for security.

**Server action.** In Next.js, a function that runs on the server when a user submits a
form or clicks a button. This is where data gets written and where rules get checked.

**Authentication.** Confirming who a user is, usually by logging in.

**Authorization.** Deciding what a user is allowed to do, based on their positions and
privileges. Different from authentication.

## About the existing site

**APOonline.** The existing platform we are documenting, made by a company called
GreekTrack. We are not copying it. We are learning from it.

**Server-rendered.** A website where each page is built on the server and sent to the
browser as finished HTML. APOonline works this way. Its page addresses end in `.php`.

**PHP.** The programming language APOonline is built in. We are not using it. We only need
to read its pages.

**Multi-tenant.** A system that serves many separate organizations at once from one
installation. APOonline is multi-tenant across many chapters. Ours is not; it serves one
chapter, which makes it much simpler.
