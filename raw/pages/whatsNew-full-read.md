# Capture: What's New, the parts the first read skipped

- URL: https://www.apoonline.org/alphadelta/memberhome.php?action=whatsNew
- Captured: 2026-08-29.
- Why this file exists: `raw/pages/memberhome_action-whatsNew.md` says outright that its
  entries were "sampled below rather than transcribed in full". The page is about 27,700
  characters and roughly 13,000 were read. This file covers the remaining stretch, mostly
  2019 to 2021, which the sample skipped. The page is now read end to end.

## The largest thing the sample missed: a Conference Manager

Entries from July 2020 describe a whole subsystem that no navigation entry on this chapter
exposes. Verbatim:

- "Added support for assigning a unique set of form questions per ticket option in the
  Conference Manager. When someone registers for a conference, they will see all questions
  related to only their selected tickets merged into a single form."
- "Added support for a single user to register multiple conference attendees at once and
  pay with a single transaction."
- "Added support for free ticket options in the Conference Manager."
- "Ability to customize the confirmation message that shows after someone completes a
  conference registration."

Taken with the January 2025 entry already recorded ("Chapters and alumni chapters may now
create and manage their own ticket-based events & conferences"), this is: conferences,
ticket options, per-ticket question sets, group registration in one payment, free tickets,
and a custom confirmation message.

## Authentication: social login

- "Support for Sign in with Google and ability to import your Google profile picture."
- "You may now connect or disconnect your APOonline account from Facebook and/or Google
  from the Edit Profile > Change Password tab."

**Verified on the live site.** `?action=changepassword` shows, verbatim, "Log in with:"
followed by a "Connect" control and a "Disconnect" control. The DOM carries
`i.fa.fa-facebook` next to `a.connectSocialButton` and `i.fa.fa-google` next to
`a.disconnectSocialButton`, so on this account Google is linked and Facebook is not.

The same page's password form is: `__csrf_magic`, `email` (with a separate "change"
control), `oldpass`, `newpass1`, `newpass2`.

Account sub-tabs, verbatim: "Profile Information | Line & Family | LEADS |
Contact Preferences | Change Password | Attachments | Donations".

This is a real gap in the earlier documentation, which described login as e-mail and
password only.

## Membership

- "Added new 'Guest' membership status and migrated all 'Donors' as new members with the
  'Guest' membership status." (March 2020)

So there is a seventh national membership status, Guest, created to turn donors into member
records. It does not appear in the `memberStatusId` dropdown on this chapter
(`raw/pages/memberhome_action-editstatus_statusid-111.md` lists six), which suggests it is
either headquarters-only or was later retired. Recorded as a discrepancy, not resolved.

- "Users/Alum of inactive chapters may still log in and manage their profiles but all other
  features are disabled."
- "Members of inactive chapters may no longer view other member profiles or chapter
  profiles."
- "Chapter officers may no longer remove the chapter's affiliation from their non-prospect
  members."

## Forms: a workflow, not just a collector

- "Anonymous forms may now be created to allow your members to privately submit information
  or vote ensuring only a single submission per person but yet anonymous." (October 2020)
- "Form submissions can be assigned to officers while processing the submission. Once
  completed, the assigned officer may now mark the submission as 'complete'." (March 2020)
- "Added Forms for chapters and Headquarters to send surveys to all members in their
  organization." (September 2019)

The first is the interesting one: anonymous **and** one submission per person at the same
time. That is a real design problem, because the obvious way to enforce one-per-person is
to record who submitted.

## Requirements

- "You may now designate a chapter requirement as 'members must attend X% of events of this
  type this term' instead of tracking by hours." (January 2021)
- an entry describing the ability to "break your 'Service Hours' requirement into categories
  like 'Service to the Community', 'Service to the Campus', etc."

These date the two requirement features already documented: percentage mode and categories.

## Events

- "Events can now be set to 'All Day' to remove the time showing on the event calendar."
- "Events can now disable signups. This is useful for adding key dates or deadlin..."
  (truncated in capture)
- "The National Calendar will now only show events created by headquarters staff instead of
  all events from all chapters."
- "Ability to limit event sign-ups on events to only officers & advisors."

## E-mail

- "Ability to schedule bulk emails to be sent in the future." (November 2020)
- "Updated bulk email template! Emails you send will now be contained in a stylish new frame
  with accent colors to match your portal." (November 2020)

Scheduled sending is a second confirmed background job, alongside the reminder scheduler.

## Files and fundraising

- "You may now share external links within the File Manager. This is useful to link out to
  common resources or external cloud hosted files (e.g., Google Docs, etc.)." (July 2020)
  This dates the `cloudFileUrl` form observed in `raw/pages/diamond-tier-sweep.md`.
- "Added new LYBUNT report to show donors who donated last year but not yet this year.
  Click 'View LYBUNT Report' from any Fund or Campaign page." (March 2020)
- "New Alumni Directory to search by industry, company, or location." (June 2020)
- "You can now add your education history to your profile!" (June 2020)

## Other

- "Chapter sites have a new Manage Dashboard full of insights instead of a static menu of
  links." (December 2020) This is the officer dashboard documented in
  `raw/pages/memberhome_action-managemenu.md`.
- "New feature: Announcements! You may now post announcements that are pinned to the top of
  any group's home page." (December 2020)
- "Chapter invoices are now highlighted above the officer dashboard on chapter sites."
- "Inactive groups may now view the Alumni Directory."
- "Search box now shows members in your own site first, then searches and displayed members
  across the entire database." (October 2019)
- "Added new image carousel webpage component." (October 2019)
- "Added ability to setup unique invoice templates for groups on a semester or quarter
  system." (September 2019)
- "Added 'Country' field to all addresses to support international organizations."
  (September 2019)
- "Ability to customize the colors inside this APOonline portal (must contact support to
  change colors)." (September 2019)
- "Headquarters staff may now view membership totals per membership status from the Active
  Membership page."
- "Headquarters staff may now request APOonline to disable Point Trackers system-wide."

The page is now read in full. No further unread stretch remains.
