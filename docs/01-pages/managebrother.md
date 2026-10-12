# Account Manager: one member

> Summary: The officer's view of a single member, with tabs for their account, records,
> awards, line and events. It holds the whole member profile form.
> Status: OBSERVED
> Read this if: you are designing the member table.
> Depends on: raw/pages/memberhome_action-managebrother_panel-account.md

**Route:** `memberhome.php?action=managebrother&userid=<id>&chapterid=<id>&panel=<name>`

Panels: `account`, `records`, and (from the tabs) awards, family and events. Above those
sit Profile, Attachments, LEADS and Engagement.

## What the profile form holds

Names (first, middle, last, suffix, preferred, maiden), a national id number, a login
e-mail and a separate contact e-mail with a preference for which one receives mail, a
phone number, a campus address and a home address each with country, an undergraduate
major, gender, a pledge class as a term word plus a year, a graduation class the same way,
a birthday, and a short "about me".

There is also an education history form and a work experience form, and a profile picture
upload.

## Two structural details

**Fields are numbered.** Alongside named fields like `profile[firstname]` sits one called
`profile[473]`, and every field has a matching `profile[visibility][<number>]`. The
profile page carries a link reading "Add a new field to all profiles". So the product
stores attributes as numbered rows, which is what lets a chapter invent its own field.

**The member number is per chapter.** The field is `chapternumber[311]`, keyed by the
chapter's id. A person can belong to more than one chapter and hold a different number in
each.

## Per-field visibility

Every field carries an audience. There are five, seen on the member's own editor
(`raw/pages/completeness-pass.md`): "Anyone", "Anyone + Staff", "Alpha Delta Only + Staff",
"Officers", "Hidden (Staff Only)". "Staff" is the vendor's staff, not the chapter's
officers, which is why two of the five exist at all.

For one chapter this is more machinery than it is worth, and three of the five levels have
no meaning once there is no vendor. One setting for contact details as a whole is enough
until members ask for more.

## Profile history

The editor states that updated values are kept: "To maintain profile history, any updated
values are saved. To delete past information you may clear your profile history." So a
profile field is versioned. That is what the audit log's "Cleared profile history" line
refers to.
