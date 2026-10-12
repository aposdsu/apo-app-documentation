# Account type privileges

> Summary: The grid that decides what an ordinary member of a given account type may do.
> Forty privileges, in three groups.
> Status: OBSERVED
> Read this if: you are building permissions.
> Depends on: raw/pages/memberhome_action-editprivileges_statusid-2.md,
> docs/04-system-design/02a-privilege-lists.md

**Route:** `memberhome.php?action=editprivileges&statusid=<account type id>`

## What it does

For one account type, it shows every privilege with an Allow and a Disallow radio button.
Saving posts the whole grid at once, so a save is a full replacement rather than a change
to one row.

## The three groups

- **Event privileges** (7). View events, create an event, sign up, see who else is coming,
  edit or complete an event you coordinate, text the attendees.
- **Access privileges** (16). See the roster, the minutes, the budget, other people's
  progress, the family tree, the file manager, the alumni directory; post to the blog and
  photo albums; use the comment form; send bulk e-mail or SMS.
- **Record privileges** (17), headed "(not recommended)". One per requirement:
  "Log their own: Internal Service Hours" and so on.

## The trap in this page

Some privileges are stored backwards. "View roster and profiles of other members" is a
field called `hideMembers`, and choosing Allow sends `false`. Eight of the sixteen access
privileges are named this way.

For your own build, always store the positive form. A permission system where half the
flags mean the opposite of what they say is a permission system that will eventually leak.

## What this page proves

That the earlier guess was wrong. Permissions do not come only from officer positions.
An ordinary member's abilities come from their account type.
