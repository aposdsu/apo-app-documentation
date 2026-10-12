# Capture: what reading the pages in full turned up

- Captured: 2026-08-29. Earlier passes read structured extracts (forms, tables, short text
  slices). This pass reads each page's complete text, checking the total length so the end
  is known to have been reached.
- Only new material is recorded here; everything already captured is not repeated.
- Nothing was submitted.

## The biggest correction: "Line" is not the product's word

`?action=editfamilysettings` (reached only from a sentence inside `?action=managefamilies`:
"Do you call your lines something else? Check out the line options page for advanced
settings") is a label-configuration screen.

On-screen, verbatim:
- "Advanced Settings"
- "Top Lines Feature / Select whether or not to show the Top Lines feature within your
  APOonline website." with Enable / Disable
- "'Big / Little Member' Label / Set what your chapter calls your Big and Little members."
  with choices "Big / Little Member", "Parent / Child", "Custom:" plus BIG LABEL and
  LITTLE LABEL text fields
- "'Family' Label / Set what your chapter calls your families/groups/tribes." with choices
  "Family / Families", "Group / Groups", "Custom:" plus SINGULAR and PLURAL text fields

Form (post), submit "Update Settings":
`__csrf_magic`, `config[disabletopfamilies]` (radio 0/1, currently **1 = disabled**),
`bigLittleLabel` (radio: `bigLittle` **selected**, `parentChild`, `custom`),
`langBig`, `langLittle`, `familylabel` (radio: `family`, `group`, `custom` **selected**),
`langfamilysingular` = **"line"**, `langfamilyplural` = **"lines"`.

**So every earlier capture and document that says "the site calls a family a Line" was
describing this chapter's own configured label, not the product.** The product's own default
is "Family / Families", with "Group / Groups" as the alternative and a custom option that
Alpha Delta used to set "line/lines". Big and Little are likewise renameable, to
"Parent / Child" or anything else.

That also explains the "Top Lines" feature name on `?action=topbrothers`, and why the
navigation reads "View Lines".

## `?action=userspending` — approval is a three-way choice, not a button

Reading the whole page rather than the form field names shows each pending person's row
carries their name, e-mail, and a stated intent, verbatim: **"Requesting to be a PNM."**

The controls per row are **"Skip", "Reject"**, and the 14-item account type list. The
earlier capture recorded only the field names and the "Approve" submit, and so missed that
an officer can skip a row or reject an applicant outright, and that the applicant declares
what they are asking to become.

## `?action=managestatuses` — the intro sentence states the two-axis model

Verbatim: "Account Types represent a member's relationship with your chapter/group.
**You can set unique requirements and privileges per account type.**"

One sentence from the vendor confirming both halves of what
`docs/04-system-design/02-auth-and-permissions.md` argues: an account type carries
requirements *and* privileges.

Also an "Admin Actions Key" not previously captured: "Delete this account type",
"Manage this account type", "Edit privileges for this account type".

## `?action=pendingevents` — two events pending, not one

The earlier capture recorded one row. Reading the whole table shows two: "Fall '26
Flyering!" with 12 attendees and "Spontaneous Fellowships" with **0 attendees**.

An event with zero attendees is still offered for completion, which means completing an
empty event is possible and awards nothing.

## `?action=inviteuser` — the page is headed "Add Prospect"

Verbatim heading and lead: "Add Prospect / Choose one of the four options available to add
contacts to your chapter." The earlier capture began at "Option 1" and missed that the whole
screen is framed as adding a prospect, which is why Prospect is the natural default account
type.

## `?action=managebudget` — an admin actions key

Verbatim: "View individual transactions for this budget", "Delete this budget".
So a budget line drills through to its own filtered transaction list.

## `?action=managefamilies` — an admin actions key

Verbatim: "Edit this line", "Delete this line".

## `?action=manageUserAwards` — three controls not previously captured

"Give Member Award" -> `?action=manageUserAwardRecords`
"Import Member Awards" -> `?action=awardUpload`
"All Member Awards Report" -> `?action=awardReport&entity=userAward`

Also the page's own lead, verbatim: "Alpha Delta Member Awards / Use this page to add or
remove chapter member awards for display on member's profiles. Use the Member Awards page to
add awards to member's profiles."

### `?action=awardUpload` — CSV import of award history

Verbatim: "Award History / Use this tool to import award history for your members using your
existing awards." Then a two-step flow, "1 Create CSV Import File" with an example, and
"2 Upload CSV Import File".

Example CSV columns, verbatim:
`Member ID | Member Name | Award Name | Award Subtitle | Date Awarded`
with the sample row `123456 | Alex Anderson | Example Award | 1st Place | 1/1/2026`.

### `?action=awardReport&entity=userAward` — the award report

Columns, verbatim: `Member ID | Member | Award Title | Award Subtitle | **Awarded By** |
Date Awarded`. Export controls "Copy CSV Excel PDF Print", paging "Show 10/25/50/100
entries", a search box.

**`Awarded By` is a field the give-award form does not ask for**, so the system records the
acting officer itself. That is a fifth column on the member-award record:
member, award, subtitle, date, granted-by.

The `entity=userAward` parameter suggests `awardReport` is a generic report route that takes
an entity name, in the same family as `image.php?entity=userProfilePhoto&id=...` observed in
the network capture.

## `?action=viewchapter&panel=awards&id=311` — chapter awards are a separate entity

Never opened before. The chapter's Awards tab has **five sections**, verbatim:

- "Official Awards / These awards are official Alpha Phi Omega awards given out by staff on
  the national, Region, and Section levels. / Alpha Delta has yet to receive any official
  awards."
- "Chapter Distinguished Service Keys / No recorded Chapter Distinguished Service Keys"
- "Other Awards / No recorded awards."
- "Trophies / No recorded trophies."
- "In The News / No recorded news articles."

**Awards given to the chapter are a different thing from awards given to a member.** The
member awards captured in `raw/pages/newly-found-verbs.md` are five Distinguished Service
Keys with a recipient and a date. These are awards, trophies and press mentions belonging to
the chapter itself, and "Official Awards" are granted by staff above the chapter, not by the
chapter.

## `?action=viewchapter&panel=leaderboard&id=311` — leaderboard scopes

An "Event Type:" selector listing all 18 requirements, then a ranked table headed
**"Internal Lifetime Meetings"** with columns "Rank | Member | Total" and real totals in the
50 to 70 range.

Two scope words in that heading that no other screen showed together: **Internal** (as
opposed to external credit) and **Lifetime** (as opposed to the current term). So a
leaderboard is (requirement) x (internal or external) x (term or lifetime), which matches
the "view all-time" links on `?action=topbrothers`.

## `?action=viewchapter` tab routes

`?action=viewchapter&panel=<name>&id=311` with panels `files` (labelled "Attachments"),
`leaderboard`, `awards`, plus Overview, Events and Members.

## `?action=families` — a default filter, previously missed

The page ends, verbatim: **"Not showing alumni and inactive members. show all"**.

So the family/line listing hides alumni and inactive members by default. The 72-member "No
line listed" group is therefore 72 *current* members, not 72 of the 589 records.

## `familytree.php` — a separate top-level page

10,346 characters, almost all of it layout whitespace. Heading "Alpha Delta's Family Tree".
It is a rendered tree rather than a table, and it is its own PHP file rather than an
`action` on `memberhome.php`, like `blog.php`, `register.php`, `campaign.php` and
`index.php`.

## `?action=viewAlumni` — the industry list, read in full

The "most popular industries" list is: Education, Healthcare, Accounting, Hospitality,
Non-Profit, Sales/Marketing, Software/Technology, Arts, Law, Environmental,
Military/Defense, Engineering, Financial Services, Sports, Manufacturing,
Transportation/Logistics, Religious Organizations, **Engineering** (again), Automotive,
Agriculture.

"Engineering" appears twice here as well as on the job board, so the duplicate is in the
shared industry list, not a rendering accident on one page.

## Pages confirmed fully read with nothing new

`?action=manageminutes` (314 characters), `?action=viewforms` (224),
`?action=manageAnnouncements` (353), `?action=viewnotifications` (378),
`?action=viewcomments` (507), `?action=managefamilies` (451), `?action=manageUserAwards`
(514), `?action=managestatuses` (923), `?action=pendingevents` (751),
`?action=eventcreate` (2,084), `?action=managebudget` (1,714), `?action=managedues` (1,931),
`?action=inviteuser` (1,314), `?action=editfamilysettings` (571), `?action=awardUpload`
(419), `?action=awardReport` (418), `?action=viewAlumni` (604).

Each was read end to end against its own character count, so "fully read" here means the
whole rendered text, not a sample.
