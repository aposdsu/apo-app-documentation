# Officer position privileges

> Summary: The grid that decides what an officer holding a position may manage. Thirty
> nine privileges, of which nineteen are generated from the requirement list.
> Status: OBSERVED
> Read this if: you are building permissions. This is the single most valuable page on the
> whole site.
> Depends on: raw/pages/memberhome_action-editofficerprivileges_officerid-2892.md,
> docs/04-system-design/02a-privilege-lists.md

**Route:** `memberhome.php?action=editofficerprivileges&officerid=<position id>`

## Why this page matters most

Every privilege names a feature. Reading this page tells you everything the application
can do, in the vendor's own words, without guessing. It is a feature list you can trust
because the software has to check each row somewhere in its code.

## The two groups

**Access privileges** (20). Configure site settings (the site-admin privilege), invite and
approve users, manage external webpages, approve photo album images and blog posts, edit
member profile information, manage fundraising campaigns, post announcements, send bulk
e-mail, send bulk SMS, manage families, achievements, meeting minutes and awards, upload
files, create forms, complete forms requested by national staff, manage courses and
quizzes, manage external sales tools, manage calls for applications.

**Requirement privileges** (19). One per requirement, of the form "Manage Service Hour
Requirement", plus "Manage Other (Non-Associated) Events". The first of them is worded
"Manage Dues Requirement **& Chapter Finances**", so that one privilege gates the whole
money section.

## The structural insight

The requirement privileges are not written by hand. The field name for the privilege on
requirement 865 is `priv[req865]`, and 865 is the requirement's own id. Create a
requirement and a matching privilege appears here.

That is worth copying. It is what lets a chapter say "the Service VP manages service hours
and nothing else" without a developer touching code.
