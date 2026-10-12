# Capture: how the unlocked features actually work

- Captured: 2026-08-29, second Diamond pass. This one opens the forms behind the
  management pages, which the first Diamond pass did not.
- Nothing was submitted. No file uploaded, no post published, no message sent.

## Routing behaviour worth knowing first

An unknown `action` value does not produce a 404 or an error. It silently renders the
member home page. Confirmed twice, with `?action=createalbum` and `?action=editFund`,
both of which returned the dashboard.

Consequence for anyone mapping this site: **you cannot tell a wrong guess from a real page
by the status code.** Check the page content, not the response.

## Blog

`?action=manageblog` row links: view goes to `https://www.apoonline.org/blog#entry_<id>`,
edit to `?action=editblog&blogid=<id>`, delete to `?action=deleteblog&blogid=<id>`.

### `?action=createblog` — New Blog Post (form read, never submitted)

On-screen: "New Blog Post", "Title:", a rich-text toolbar showing "Formats", "Verdana",
"11pt", the hint "To write HTML code click the icon to edit the HTML then click it again to
accept changes.", "Visibility:", "Publish Date:", "or cancel".

Form (post), submit button "Post Entry":

| name | type | max | value on load |
|---|---|---|---|
| __csrf_magic | hidden | | <redacted> |
| newId | hidden | | pre-set to an id before anything is saved |
| ptitle | text | 255 | |
| pcontent | textarea | | wrapped by a WYSIWYG editor with 27 toolbar buttons |
| pvisibility | radio | | `public` (selected) and `private`, labelled "Public" and "Private (Alpha Delta Member Only)" |
| publishDate | text | 10 | today's date, 08/29/2026 |
| (unnamed) | submit | | "Post Entry" |

Three things this form establishes:
- **A post has a publish date separate from its creation**, so publishing can be scheduled.
- **A post has two audiences**, public or members-only, which is why the same blog has a
  public and an internal face.
- **`newId` is issued before the post is saved.** That is the usual way a system lets you
  attach images to a draft: the id exists first so uploads have something to belong to.

### The public blog, `https://www.apoonline.org/alphadelta/blog.php`

Renders the chapter's public site: a header with tabs "MEMBERS ABOUT CALENDAR BLOG", the
line "Welcome <name>! Not <name>? Click here to sign in as a different user", the heading
"Alpha Delta's Blog", and the body **"No blog posts to date"**.

Note the contradiction, which is not a contradiction: `?action=manageblog` lists one entry
from March 2015, but the public page shows none. The stored entry is therefore not publicly
visible, which is `pvisibility` doing its job.

Note also that the public page knows who is logged in. The public site and the member site
share one session.

## Photo albums

`?action=managealbums` lists albums and describes an approval flow, but the page that adds
images, `?action=addpictures`, is **switched off by the vendor**. Its full text, verbatim:

"We're making improvements! The Photo Album Images feature is offline for the moment as we
apply the latest update. Check back Summer 2025 to see the latest updates. If this is an
urgent issue please contact APOonline support at support@greektrack.com"

The capture date is August 2026, so the feature has been offline for more than a year while
still being listed as a paid feature of the GOLD and DIAMOND tiers.

## External website builder

| Link on `?action=managewebsite` | Route |
|---|---|
| Customize Homepage Columns | ?action=managepages |
| Update Header Tabs | ?action=managetabs |
| Manage Custom Webpages | ?action=managepages |
| Update Homepage Image | ?action=edithomepageimage |
| Manage Website Colors | ?action=managethemes |

### `?action=managepages` — webpages and homepage columns

Text, verbatim: "Customize your external homepage or create new custom webpages. For each
homepage column you can choose from plain text, recent blog posts, a static image, a Google
Calendar, or any other RSS feed such as WordPress."

Table headers: "Page | Date Modified | Last Modified by".
Rows seen: "History Tab", "Home Page Left Column", "Home Page Center Column",
"Home Page Right Column", "Calendar Tab", "About". Dates range from June 2009 to
February 2015; two rows read "Not yet updated!" in the author column.

So a homepage column and a custom page are the same record type, distinguished by name,
and each carries a modified date and a last-modified-by member.

### `?action=managetabs` — header tabs

Text, verbatim: "Here you will be able to customize which tabs appear at the top of every
page. Simply select the tab from each column in the table below and click 'Update' and your
webpage will be updated with the correct tabs."

The layout is **exactly four tab slots**, each a radio column offering the same six fixed
choices: BLOG, CALENDAR, PHOTOS, HISTORY, MEMBERS, ABOUT.

### `?action=managethemes` — website colours

Table headers: "Theme | Active | Actions". Two rows: "Alpha Phi Omega" and "Default Theme".
Links: "Create New Theme"; per row "Edit this theme", "Delete this theme".
So a theme is a named record and exactly one is active.

## Events, the parts only visible now

### The attendee table has a Comment column

Headers on `?action=eventsignup&eventid=<id>`, verbatim: "Member | Phone | Comment".
A sign-up therefore carries a free-text comment from the member, alongside the driver and
open-seats data already seen in the access log. (Comment values are real member text and
are not recorded here.)

### `?action=manageeventattachments&eventid=<id>`

Text, verbatim: "Back to event page", "<event title> Attachments", "Upload",
"Drag & Drop Files", "Private - Any Initiated Member",
**"Event attachments are only kept for 6 months"**,
"This event has no attachments. Upload new documents using the space above."

Form (post): a single `file[]` file input.

The six-month retention line is the important one: something deletes these on a schedule.

### Mobile check-in

Not observable. The event form's `eventinfo[requireCheckIn]` is now ungated, but the
feature only appears on an event that has it switched on, and switching it on would be a
write. The event page for an event without it shows no check-in control. What check-in
looks like at run time is therefore unobserved.

## Fundraising

### `?action=createFund` (form read, never submitted)

Text, verbatim: "Create a Fund", "Use funds to categorize your fundraising campaigns and
gifts for different purposes. Each fund may route money to unique bank accounts.",
"Payment Options", "Define the checkout page to use for this fund's campaigns.",
"+ add new checkout pages", "Track as Income?".

| name | type | max | notes |
|---|---|---|---|
| __csrf_magic | hidden | | <redacted> |
| title | text | 255 | |
| description | textarea | | |
| paymentOptionGroupId | select-one | | empty on this chapter; the "checkout page" to use |
| trackAsIncome | radio | | see the two labels below |
| (unnamed) | submit | | |

`trackAsIncome` labels, verbatim:
- "No, keep donations recorded separately."
- "Yes, donations made directly to this fund benefit my chapter. Track as both a donation
  and a transaction."

That second label is the interesting one: one fund setting decides whether a donation is
written to the donation records only, or to the donation records **and** the chapter's
transaction ledger. It is a deliberate double-write, controlled per fund.

## File manager, remaining detail

The folder listing offers "Create Folder", "Share External Link" and "Upload", with the
three audiences already recorded in `raw/pages/diamond-tier-sweep.md`
("Officers & Advisors Only", "Initiated Members",
"Non-Initiated and Initiated Members"). The upload form is `file[]`; the external-link form
carries `cloudFileTitle`, `cloudFileUrl` and `visibility`.
