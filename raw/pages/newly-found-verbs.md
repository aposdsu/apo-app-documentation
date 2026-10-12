# Capture: four routes found by reading the page's own anchor list

- Captured: 2026-08-29. Found by extracting every `action=` value from the anchors on
  `?action=managemenu` rather than from the visible navigation. Four had never appeared in
  any earlier capture.
- Nothing was submitted. CSRF values are `<redacted>`.

## `?action=editchapterlinks` — how the menu bar links are managed

**This is the answer to "how do I update the links in the menu bar".** The Website panel on
the officer dashboard shows an "External Links" entry whose description reads "Add external
links to your menu for easy access to external resources for your members", **but its href
points at `?action=managemenu`**, which is the officer dashboard itself. The link is
mis-wired. The working route is `?action=editchapterlinks`.

Page text, verbatim:
"Alpha Delta's Links"
"Use this form to manage your chapter's links that are displayed on your chapter's profile
page and the links that show up in the navigation bar (above) under the More... tab.
Keeping your chapter profile up to date is a great way to increase your chapter's followers
as well as keep your membership informed of up to date news."

Table headers: "Link Text | URL | Visibility", with a "preview" control per row.

### Form (post, never submitted), submit "Update Links"

| name | type | max |
|---|---|---|
| __csrf_magic | hidden | |
| chapterid | hidden | |
| links[facebook][title] | text | 50 |
| links[facebook][url] | text | 255 |
| links[facebook][visibility] | select-one | |
| links[instagram][title] | text | 50 |
| links[instagram][url] | text | 255 |
| links[instagram][visibility] | select-one | |
| links[homepage][url] | text | 255 |
| links[other][N][title] | text | 50 |
| links[other][N][url] | text | 255 |
| links[other][N][visibility] | select-one | |

Nine `links[other][N]` slots are rendered. Facebook, Instagram and homepage are named
slots; everything else goes in the numbered ones. The homepage row has a URL but no title
and no visibility select; the page labels it "Homepage" and "Shown on chapter profile".

### Visibility options, verbatim (value=label)

- 50 = Show only on chapter profile
- 60 = Show on chapter profile and in nav menu
- 20 = Show only in nav menu

All six links on this chapter are set to 60.

**Note the numbers.** 20, 50 and 60 are from the same ordered visibility scale used for
events, where 60 is "Public to the Internet", 20 is chapter-scope and 5 is officers-only
(`raw/pages/memberhome_action-eventcreate.md`). The product reuses one numeric scale for
unrelated visibility decisions, and the labels differ per screen. For a rebuild that is a
warning: do not reuse one enum across two features whose meanings diverge.

## `?action=manageUserAwardRecords` — how a member is given an award

This closes an open question in `docs/GAPS.md`.

Page text, verbatim: "Give Award", "Use this form to add awards to member's profiles. If
you need to create chapter specific awards use the Edit Chapter Awards page.",
"Award", "+ Create award", "Award Recipients",
"No awards have been given by Alpha Delta."

Table headers: "Member | Date Awarded".

### Form (post, never submitted)

`__csrf_magic`, `chapterid` (hidden), `awardid` (select), `subtitle` (text),
`brother` (typed name), `userid` (hidden, resolved), `dateawarded` (text), submit.

### `awardid` options, verbatim (value=label)

- 1 = National Distinguished Service Key
- 2 = Alumni Distinguished Service Key
- 3 = Regional Distinguished Service Key
- 4 = Sectional Distinguished Service Key
- 5 = Chapter Distinguished Service Key

**These five are built into the product**, with low ids, and are the "APO Awards (DSKs)"
listed as a Basic Feature on the subscription chart
(`raw/pages/memberhome_action-viewstorage_tier-chart.md`). Chapter-defined awards created
through `?action=manageUserAwards` are additional to these.

The `subtitle` field means one award can be given more than once with different wording,
for example a year or a citation.

## `?action=verifyRoster` — the roster audit tool

Page text, verbatim:
"Verify Membership Roster"
"Use this tool to make changes to anyone that does not have the correct status assigned."
"DO NOT USE THIS FOR MEMBERSHIP TRANSITIONS (e.g., Induction, Initiation, or Graduation).
To report transitions, use the Transition Tool."
"Member / Ordered by Account Type", "Approve each member's account type.",
"Select 'Change' to make updates."

Each row is a member with their account type and two controls, "Approve" and "Change".

### Form (post, never submitted)

`__csrf_magic`, `chapterId` (hidden), `redirect`, and per member:
`previousMemberStatusIds[N]` x66, `change[N]` x132 (two per member, the Approve/Change
radio pair), `userid[N]` x66, `status[N]` x66, `positions[N][]` x1254.

66 members, and 1254 position checkboxes, which is 66 x 19 positions.

**This is a separate concept from the Transition tool**, and the page says so in capital
letters. Verifying a roster corrects a mistake in someone's current account type;
transitioning moves them through a membership stage. Both write the same field. A rebuilt
system would be better off with one operation plus a reason, but the distinction the vendor
is drawing is real: a correction is not an event in the member's history, a transition is.

`previousMemberStatusIds[N]` being submitted alongside the new value is how the server
detects what actually changed, and is the usual guard against two officers overwriting each
other.

## `?action=createAlbum` — create a photo album

Note the capital A. `?action=createalbum` (lowercase) is not a route and falls through to
the dashboard, as recorded in `raw/pages/diamond-features-how-they-work.md`. The verbs are
case-sensitive.

Page text, verbatim: "Create Photo Album", "Name and add a description of your photo album
here, then we'll upload photos on the next page!", "Album Name:", "Album Description:",
"or cancel".

Form (post): `__csrf_magic`, `album[name]` (text), `album[desc]` (text), submit.

Creating an album and adding photos are two steps. The second step is
`?action=addpictures`, which the vendor has switched off.
