# Capture: the custom profile field builder, and the LEADS panel

- Captured: 2026-08-29. Both found by extracting `action=` values from the anchors on
  `?action=profile`, not from the visible navigation.
- Nothing was submitted.

## `?action=createuserfield` — "Add a New Field"

Reached from the link at the foot of a member's profile reading "Add a new field to all
profiles". **This is the admin surface of the numbered-field system** inferred earlier from
`profile[473]` (`raw/pages/memberhome_action-managebrother_panel-account.md`). It confirms
that inference completely: a chapter really can add fields to every member profile, and the
new field gets an id.

### On-screen labels, verbatim

"Add a New Field", "Title", "Subtitle (optional)", "Merge Code  {{member:}}",
"Use merge tags in your email templates to dynamically place data from this field into your
emails.", "Is Unique?", "Type", "Membership Statuses", "Field Usage", "Importance",
"Who can view?", "Who can edit?", "All staff may also view", "All staff may also edit",
"or cancel".

### Form (post, never submitted)

| name | type | max | values |
|---|---|---|---|
| __csrf_magic | hidden | | |
| title | text | 50 | |
| subtitle | text | 255 | |
| mergeCode | text | 35 | the `{{member:___}}` tag used in e-mail templates |
| isUnique | radio | | 0 = "No, allow members to enter any value in this field (recommended)", 1 = "Yes, require a unique value for this field across all member profiles" |
| type | radio | | see the nine types below |
| options[] | text | 100 | repeating, for the two selection types |
| filterByStatus | radio | | 0 = "Show for all members of all membership statuses.", 1 = "Only show for some membership statuses..." |
| filterByStatusIds[] | checkbox | | 7 checkboxes |
| isStaffOnly | radio | | 0 = "Public, Profile Field — Shown on member profile pages", 1 = "Private, Officer Only Notes Field — Hidden from active members, only shown to staff" |
| importance | radio | | optional, recommended, required |
| visibility | radio | | 8 levels, see below |
| priv | radio | | 0 and 20, the "Who can edit?" choice |
| (unnamed) | submit | | |

### The nine field types, verbatim (value = label)

- string = General Text
- email = E-mail
- phone = Phone
- url = Website
- bool = Yes/No
- date = Date
- unix = Date & Time
- enum = Selection Drop-Down...
- check = Multi-Selection...

Note `unix` for date-and-time, which suggests those values are stored as Unix timestamps
while `date` values are not. That matches the `startdate=1781938800` timestamps seen in the
progress links (`raw/pages/memberhome_action-managerecords_reqid-3.md`).

### "Who can view?", the eight visibility values

| value | label |
|---|---|
| 50 | Any logged in member of Alpha Phi Omega |
| 45 | Only initiated member of Alpha Phi Omega |
| 40 | Only Region B members |
| 30 | Only members |
| 20 | Only Alpha Delta members |
| 10 | Only Alpha Delta members excluding Potential New Members |
| 5 | Only the member and their officers/advisors |
| 0 | Only the member |

with the standing note "All staff may also view".

**This is the same descending numeric scale as event visibility and chapter links**, and it
finally explains the five visibility words seen on the profile editor
(`raw/pages/completeness-pass.md`): those words are labels for points on this scale, and
"+ Staff" reflects the "All staff may also view" rule that applies at every level.

### "Who can edit?", `priv`

- 0 = The Member him/herself and officers/advisors
- 20 = Only officers/advisors

with the note "All staff may also edit".

### Importance, and what it implies

- optional = "Only shown on Profile pages"
- recommended = "Shown on Registration and Profile pages"
- required = "Required on Registration and Profile pages"

So a custom field can be injected into the public registration form and made mandatory
there. This matches the June 2026 release note "Chapter record fields may now be set to
required" (`raw/pages/memberhome_action-whatsNew.md`).

### Why this matters for a rebuild

Everything a student would want to know about the EAV design is on this one page: fields
have a type, a uniqueness rule, an audience, an editor rule, an importance, and an optional
restriction to certain membership statuses. That is six columns on a `custom_field` table
plus a values table.

`[design note for the analysis pass]` A single chapter almost certainly does not need this.
It is listed SKIP in the feature inventory. But if the students ever do add it, this page is
the specification, and the one part worth copying is `isUnique`, because a "student ID"
field that is not unique is worse than no field at all.

## `?action=editapoleads` — the LEADS panel

Page text, verbatim:
"Edit APO Leads"
"Edit your APO Leads progress here. Simply fill out the form with the designated
information. If you don't know when you attended a session make a best guess. Learn more
about APO LEADS"
Fields: "Date Attended: (MM/DD/YYYY)", "Session Location:", "or cancel".

The account sub-tabs are the same seven seen elsewhere: "Profile Information | Line & Family
| LEADS | Contact Preferences | Change Password | Attachments | Donations".

LEADS is a national Alpha Phi Omega leadership programme. The record is one row per session
with a date and a location. It is national programme tracking, not chapter tracking, and
belongs with CoE and PPoE in the SKIP column.
