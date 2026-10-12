# Capture: the nine features unlocked by the Diamond subscription

- Captured: 2026-08-29, after the chapter upgraded from BLUE to DIAMOND.
- Confirmation the upgrade is live: `?action=billingoverview` now reads "Your current per
  term rate is $5.00 per qualifying account billed on the following cycle: Biannual."
  Before the upgrade the same line read $3.00
  (`raw/pages/memberhome_action-billingoverview.md`).
- Nothing was submitted. No file was uploaded, no message composed or sent.

## The headline finding

**The upgrade unlocked page access. It did not add fields, forms or navigation entries.**

- The officer dashboard (`?action=managemenu`) has exactly the same panels and the same
  links as before the upgrade.
- The event form (`?action=eventcreate`) has the same 58 distinct field names as the
  pre-upgrade capture in `raw/pages/memberhome_action-eventcreate.md`, including
  `eventinfo[requireCheckIn]` and `eventinfo[attachFiles]`. Those fields were present and
  named while the feature was gated; only the "Diamond Subscription Required learn more"
  label next to Mobile Check-in has gone.

So the vendor ships one codebase to every chapter and gates by plan at the page level, not
by shipping different software. For the students, this means the tier chart is a price
list, not a feature list.

## `?action=viewstorage` — File Manager, previously blocked

Before the upgrade this page showed only an upgrade advertisement. It now shows the
feature.

Page text, verbatim: "Files", "Create Folder", "Upload files and share with:",
"Create Folder", "Share External Link", "Upload", "Drag & Drop Files",
"This folder is empty. Upload new files using the space above."

**File visibility options, verbatim** (this is the important part):
- "Officers & Advisors Only"
- "Initiated Members"
- "Non-Initiated and Initiated Members"

Forms (neither submitted):
- upload: post, single field `file[]` of type file
- external link: get, fields `cloudFileTitle` (text), `cloudFileUrl` (url),
  `visibility` (select-one)

The second form confirms that a "file" in this product may be a link to a file stored
somewhere else, not only an upload. Both carry the same three-level visibility.

## `?action=manageSms` — SMS

Page text, verbatim: "Recent SMS Messages", "Compose SMS".
Table headers, verbatim: "Message | Date | Sent By".
Body: "You haven't sent any SMS messages yet. Compose SMS"

## `?action=smsform` — compose an SMS (form read, never submitted)

Page text, verbatim: "Send SMS", "Choose who you want to send a SMS message to, enter the
message, and Send SMS!", "Core Filter", "All members of the Alpha Delta site",
"Only Members attending the following event:".

Form (post):

| name | type | max | notes |
|---|---|---|---|
| __csrf_magic | hidden | | <redacted> |
| type | hidden | | |
| filter | radio (2) | | all members, or attendees of one event |
| filter_eventid | select-one | | every event, as `<id>=<Mon Dth h:mma -- title>`; 0 = none |
| accountTypeId[] | checkbox (14) | | one per account type |
| message | text | **128** | |
| (unnamed) | submit | | |

**The 128 character limit on `message` is the detail worth keeping.** It is the length of a
single SMS segment, which tells you the product does not split long messages.

The audience model here is the same one the e-mail wizard uses: a core filter (everyone, or
one event's attendees) intersected with a set of account types.

## `?action=managealbums` — Photo Albums

Page text, verbatim: "New Photo Album", "Manage Photo Albums", "Here you can update
existing albums and create new photo albums. If you are an admin you may approve photo
albums by clicking the edit icon and reviewing the pictures, then clicking 'Update and
Approve'.", "Album Name", "Create your first photo album".

"Admin Actions Key", verbatim:
- "View this photo album"
- "Edit/Approve this photo album"
- "Add photos to this photo album"
- "Delete this photo album"
- "This photo album needs approval"

**Albums have an approval workflow**, which matches the officer privilege
"Post and Approve Photo Album Images" (`priv[approveimages]`). A member with the
account-type privilege `priv[postimage]` can upload; approval is a separate, officer-level
act.

## `?action=manageblog` — Chapter Blog

Page text, verbatim: "Post New Blog Entry", "Alpha Delta's Blog", "To display a link to
your blog on your external website you'll need to either: add the Blog tab to your header
tabs from the Manage Header Tabs page, or add Blog homepage column from the Manage Webpages
page.", "View your chapter's blog".

Table headers, verbatim: "Title | Last Modified".
One existing entry, from March 2015, showing a title, a modified date and a "by <author>"
line. The author's name is real and is not recorded here.

"Admin Actions Key": "View this blog entry", "Edit this blog entry",
"Delete this blog entry".

## `?action=managewebsite` — External Website (now fully readable)

Page text, verbatim: "External Website  preview homepage", "Homepage Enabled",
"Customize Homepage Columns / Define the content on your external homepage.",
"Update Header Tabs / Define the set header tabs which appear across the top of all of your
external webpages.",
"Manage Custom Webpages / Create custom HTML webpages for your external website.",
"Update Homepage Image / Upload a new image to be used on your external homepage.",
"Manage Website Colors / Define a set of colors to theme your external webpages.",
"External Website Modules",
"Manage Blog / Post a new blog entry and manage your existing posts.",
"Manage Photo Album / Upload new photos and organize them into public albums."

## `?action=manageFunds` — Fundraising (now fully readable)

Text captured in full this time. In addition to what
`raw/pages/memberhome_misc-surfaces.md` already recorded:

"What are campaigns? Campaigns represent the channels in which you raise money for your
funds. Campaigns in APOonline may have a publicly accessible donation webpage to collect
donations and/or you may log offline donations as well."

So the model is fund (a destination, optionally its own bank account) and campaign (a
channel, optionally with a public donation page), with donations able to be logged offline
as well as taken online.

Global reports listed: "SYBUNT", "LYBUNT", "Donors", "Donations". SYBUNT and LYBUNT are
standard fundraising reports meaning "some year but not this" and "last year but not this",
that is, lapsed donors.

## Event File Attachments and Event Mobile Check-In

Both are now ungated, and both were already present as fields on the event form before the
upgrade: `eventinfo[attachFiles]` and `eventinfo[requireCheckIn]`. The pre-upgrade capture
records the label "Mobile Check-in / Require attendees to check-in on their mobile phones
to receive credit / Diamond Subscription Required learn more"
(`raw/pages/memberhome_action-eventcreate.md`); the upgrade removes that last phrase.
