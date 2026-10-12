# Account types, officer positions, and who can do what

> Summary: The real permission model has two grids, not one. An account type decides what
> an ordinary member may do; an officer position decides what an officer may manage. This
> explains both, and what to build.
> Status: OBSERVED (the model, from the site's own settings pages) with DESIGN
> recommendations marked as such.
> Read this if: you are building login, or any screen that some people should not see.
> Depends on: docs/02-data-model/00-domain-model.md, docs/04-system-design/02a-privilege-lists.md

## How someone signs in

`[observed]` Three ways, not one. The account page at `?action=changepassword` shows an
e-mail and password form (`email`, `oldpass`, `newpass1`, `newpass2`) and, beneath it, a
section headed "Log in with:" offering Connect and Disconnect controls for **Facebook and
Google** (`raw/pages/whatsNew-full-read.md`). The release notes add "Support for Sign in
with Google and ability to import your Google profile picture."

So an account can have a password, a linked Google identity, a linked Facebook identity, or
several at once, and the member manages the links themselves.

**No multi-factor authentication exists.** The account security page
(`?action=changepassword`) offers only the password change and the Google/Facebook links,
with no two-factor setup, no authenticator or one-time-code enrollment, and no SMS-code step
(`raw/pages/award-and-password-flows.md`) `[observed]`. The chapter operator confirmed there
is no MFA on the site (2026-08-30). Social login delegates any second factor to Google or
Facebook, not to APOonline. `[design]` A modern rebuild should offer real MFA (an
authenticator app at least), because this product has none.

**An officer can reset another member's password.** Each member's Account Manager carries a
"Reset Password" control, `?action=resetPassword` (`raw/pages/managebrother-all-panels.md`,
`raw/pages/award-and-password-flows.md`) `[observed]`. The control was not opened. The
operator's understanding, which we adopt, is that it e-mails the member a password-reset
link (2026-08-30); this is taken as the intended behavior, not screen-verified.

`[design]` Copy the shape, not the providers. One `user_account` row, plus a separate table
of linked identities (provider, provider's id for that user), so a person can sign in more
than one way and lose one without losing the account. Auth.js, recommended in the stack
document, models it exactly this way. What matters is that **login identity is separate
from the member record**, which the proposed schema already does.

### One thing to notice, and not copy

`[observed]` The public registration form caps the password at 15 characters:
`password1` and `password2` both carry `maxlength="15"`
(`raw/pages/register-and-remaining.md`).

`[design]` Never put a maximum length on a password. A cap limits how strong a password can
be, and it usually exists because the value is being stored in a fixed-width column. A
hashed password is the same length whatever the input, so hashing removes the reason for the
cap. The students' build should accept a long passphrase and hash it.

This is an observation about the form field. It is not proof of how the value is stored, and
nothing here tested that.

## Three ideas, kept separate

**Membership status** is the national organisation's category for a person: Active,
Alumni, Deceased, Inactive, PNM, Prospect. Six values, fixed.
`[observed]` `raw/pages/memberhome_action-editstatus_statusid-111.md`

**Account type** is the chapter's own category for a person: Active, Officer, Associate,
Alum, and whatever else the chapter invents. This chapter added Bad Standing, Leave of
Absence, Half-Active and System. Each account type maps to exactly one membership status.
`[observed]` `raw/pages/memberhome_action-managestatuses.md`

**Officer position** is the job a person holds: President, Treasurer, Service Vice
President. Chapters define their own.
`[observed]` `raw/pages/memberhome_action-editofficerpositions.md`

Account type decides two different things: what a member **owes** (their requirement
targets are looked up by account type) and what a member **may do** in the software.
Officer position decides what a member may **manage**.

## The two grids

Both grids look the same on screen: a list of privileges down the left, and an "Allow"
and a "Disallow" radio button in two columns. Each grid is saved as a whole.

### Grid 1, per account type

`?action=editprivileges&statusid=<id>`, 40 privileges in three groups.

- **Event privileges** (7): view events, create an event, sign up, view the attendee list,
  edit an event as its coordinator, complete an event as its coordinator, text attendees.
- **Access privileges** (16): view the roster, post on the blog, upload and manage photos,
  view and manage meeting minutes, view the budget, view anyone's progress, view and edit
  family lineage, use the comment form, send bulk e-mail and SMS, view and upload files,
  view the alumni directory.
- **Record privileges** (17), headed on screen with the warning "(not recommended)": one
  per requirement, "Log their own: Internal Service Hours" and so on.

`[observed]` `raw/pages/memberhome_action-editprivileges_statusid-2.md`

### Grid 2, per officer position

`?action=editofficerprivileges&officerid=<id>`, 39 privileges in two groups.

- **Access privileges** (20): configure the site, invite and approve users, manage external
  webpages, approve photos and blog posts, edit member profiles, manage fundraising, post
  announcements, send bulk e-mail and SMS, manage families, achievements, minutes and
  awards, upload files, create forms, complete national forms, manage courses, manage
  external sales tools, manage calls for applications.
- **Requirement privileges** (19): one per requirement, "Manage Service Hour Requirement",
  plus "Manage Other (Non-Associated) Events".

`[observed]` `raw/pages/memberhome_action-editofficerprivileges_officerid-2892.md`

The full lists with their internal field names are in
`docs/04-system-design/02a-privilege-lists.md`. For the same information turned around, so
that you start from a feature and see the actions on it, the privilege gating each one, and
who holds it on this chapter, see `docs/04-system-design/02b-feature-actions-and-permissions.md`.

## Two things a student would otherwise get wrong

**The requirement privileges are generated, not written by hand.** When a chapter creates
a new requirement, a new privilege appears in both grids for it. The field names show it
directly: the privilege for requirement 865 is `priv[req865]` in both grids, and 865 is the
same id used in `?action=viewrecords&reqid=865`. `[observed]`, from the two privilege files
and `raw/pages/memberhome_action-managerequirements.md`.

So the privilege list is not entirely fixed. Part of it is one row per requirement.
`[design]` **Recommend building this the same way**: store a privilege per requirement
rather than one big "manage all credits" privilege. It is what lets a Service VP manage
service hours without also being able to change dues.

One trap when you seed the table: the field name `req3` appears in both grids and means
two different things, "Manage Service Hour Requirement" for a position and "Log their own:
Internal Service Hours" for an account type. Give them two different codes.

**Some privileges are stored inverted.** The privilege for "View roster and profiles of
other members" is named `priv[hideMembers]`, and choosing "Allow" sends the value `false`.
Eight privileges work this way: `hideChapterEvents`, `disallowviewrsvp`, `hideMembers`,
`hideChapterMinutes`, `hideprogress`, `hidefamily`, `hideChapterFiles`,
`hideAlumniDirectory`. `[observed]`, read directly from which radio sits in which column
(`raw/pages/memberhome_action-editprivileges_statusid-2.md`).

`[design]` **Do not copy the inversion.** Store every privilege as "may do X". Inverted
flags are how permission bugs happen.

## How a person's permissions are worked out

`[inferred]`, confidence high, from the two grids and the officer assignment page:

1. Find the person's account type this term. Collect its privileges.
2. Find every officer position they hold this term. Collect those privileges.
3. The union is what they may do.

The schema in `docs/02-data-model/proposed-schema.sql` builds exactly this as the
`member_privilege` view.

## Where account type and office are tangled together

`[observed]` The real product changes a person's account type when they take or leave an
office. The officer assignment page says, verbatim: "Any member removed from their officer
position will be returned to the 'Active' account type, removed advisors will be returned
to the 'Alumni' account type." The account-type dropdown on that same page offers 12 of the
14 types and deliberately omits "Officer" and "Advisor", because the system sets those
itself. `raw/pages/memberhome_action-defineofficers.md`

`[design]` **Do not copy this.** It means a chapter cannot say "this member is on Leave of
Absence and is also the Historian", because holding the office overwrites the type.
Keep account type and officer assignment independent. A member is Active *and* Treasurer.

`[observed]` Confirmed by the chapter operator (a Chapter Advisor of Alpha Delta, 2026-08-29):
assigning a member an officer position sets their account type to "Officer", and an advisor
position sets it to "Advisor"; removing the position returns them to "Active" (officers) or
"Alumni" (advisors), as the assignment page states. This was previously inferred from the
page text and the omitted dropdown options; it is now a confirmed fact, not an inference.

Still open, and different: what happens to a member's already-earned credits and their
requirement targets at the moment their account type flips mid-term. Targets are looked up
by account type, so the flip changes the denominator; whether existing credits are
recalculated, re-filed, or left as-is is unobserved. Recorded in docs/GAPS.md.

## What an admin is

`[observed]` "Admin" is not a separate kind of account. It is the privilege
`priv[config]`, labelled "Configure Site Settings (Site Admin)", attached to a position.
On this chapter the President position has it, along with every other privilege.
`raw/pages/memberhome_action-editofficerprivileges_officerid-2892.md`

That matches the earlier hypothesis, and it is worth keeping: whoever holds the privilege
that edits the grid can grant themselves anything, so log every change to it.

## What the real grids actually contain

Every one of the 33 grids was read: all 19 officer positions and all 14 account types
(`raw/pages/permission-matrix-complete.md`). Reading one grid, as the first pass did, hides
the things that matter.

**Five positions hold all 39 privileges**, not two. President and Chapter Advisor are marked
"(Primary)" and would be expected to. But Membership Vice President, Equity & Inclusion
Chair and Historian also hold everything, including `config` (site admin) and
`approveusers`. That is permission creep, and a chapter would probably want to know.

**One position holds none.** Conference Chair, which is why the site prints "Missing
Privileges" on its row.

**`req944` (Committee Credit) is held by 14 of 19 positions**, far more than any other. It
appears to be used as a general "may grant credit" permission rather than for its named
purpose.

**`req1` (Dues Requirement & Chapter Finances) is held only by the Treasurer** and the five
all-privilege positions. The money gate works.

On the account-type side:

**Only the "Officer" account type may create an event** (`createevent`) **or complete one**
(`coorcomplete`). An Active member can be a coordinator and edit an event but cannot
complete it, so cannot cause credit to be awarded. That split is worth copying.

**Five account types are byte-identical**: Advisor, Alum, Honorary, Half-Active and System
all hold the same nine privileges. `[design]` That is an argument for naming a permission
set and pointing several account types at it, rather than copying a grid five times.

**Only the Officer account type may self-log any requirement.** On this chapter an ordinary
Active member cannot log their own service hours.

## The honest limit of all of this

Everything above says what the site's settings pages **say** each role may do. It does not
prove the server enforces any of it.

The account used for this walkthrough is an admin. An admin is almost never blocked, so
few pages returned "not allowed" and the chapter-level permissions could not be tested by
being refused. Testing them properly would need a second account with fewer privileges,
and it would need someone to try actions that change data.

One real refusal was seen, and it is worth recording. The "All Member Awards Report"
(`?action=awardReport`) returned "Unauthorized — Only staff sites can manage awards" to
this chapter-admin session (`raw/pages/self-flows-observed.md`). So the server does enforce
at least one boundary: there is a **national-staff** level above chapter admin, and a
chapter admin is refused the staff-only report. This does not show that the chapter-level
grids are enforced (they were not tested), but it is a concrete counterexample to the flat
claim that an admin is never blocked. The enforcement that exists here is between chapter
admin and national staff, not between a member and their own chapter's admin.

Treat "the server enforces these rules" as unverified. But note this does not matter for
the rebuild, and it is not a gap to chase. Whether APOonline enforces its own rules is a
fact about the vendor's code, not about the model. The system the students build will
enforce every privilege on the server regardless, because that is the correct way to do it
(see the next section). We record the vendor's enforcement as unverified only so nobody
reads "the settings page grants this" as "the software stops that".

## The rule that makes any of this safe, in your build

Check every privilege on the server, every time, before the action runs. Hiding a button
from someone who lacks a privilege makes for a clean screen, but it is not what stops
them. The server check is what stops them. See `docs/04-system-design/01-architecture.md`.

## Officer-position notes confirmed with the operator (2026-08-29)

- **Assigning an officer position sets the "Officer" account type; an advisor position sets
  "Advisor".** Removal returns the member to "Active" or "Alumni". Confirmed by the operator.
- **A position's officer / advisor / both kind is set when the position is created and cannot
  be changed afterward.** The create form offers the choice; the edit form
  (`?action=editofficerposition`) offers only a rename. The operator confirms they see no way
  to change the kind after creation either, so this is the complete observable behavior.
- **Open:** what a "Chair Position" / `chairTitle` is. The member status panel offers "set a
  Chair Position" with a free-text `chairTitle` field, separate from the officer-position
  checkboxes; its purpose is not yet documented.
