# Capture: the full blog lifecycle, OBSERVED by performing it once

- Captured: 2026-08-29. This records WRITES actually performed, under the chapter owner's
  explicit authorization to observe the create -> view -> delete blog flow. Rule 1 remains
  in force otherwise.
- The test artifact was a **private** ("Alpha Delta Member Only"), neutrally-titled post
  "System Test - ignore", blogid 1326, authored by the operator. A neutral title was used
  deliberately so nothing referencing AI enters the permanent record.
- Only the operator's own data was involved.

## The endpoints in the flow (each observed)

| Step | URL | Method | Result |
|---|---|---|---|
| 1. Open form | `?action=createblog` | GET | the New Blog Post editor |
| 2. Submit | "Post Entry" button | POST -> redirect to `?action=insertblog` | "Success / Post Successfully Published!", lands on the blog admin list |
| 3. View (admin) | row icons -> `editblog&blogid=`, a public-view link, `deleteblog&blogid=` | - | the new post appears in `?action=manageblog` immediately |
| 4. Delete | `?action=deleteblog&blogid=` | GET, NO confirmation dialog | "Success / Post Successfully Deleted!", removed from the list |

## The create form (New Blog Post)

Fields: `__csrf_magic`, `newId` (hidden, issued before save), `ptitle` (text, max 255),
`pcontent` (a **TinyMCE** rich-text editor over a textarea; `window.tinymce` is present),
`pvisibility` (radio: **public** / **private** = "Private (Alpha Delta Member Only)"),
`publishDate` (text, prefilled with today). Submit button "Post Entry".

## Where a private post appears, and where it does not

- It appears **immediately** in the officer-facing blog admin list (`?action=manageblog`),
  showing the title, "Last Modified" = the creation timestamp (Aug 29 2026 10:51am), and
  the author.
- It does **NOT** appear on the public external blog page `/alphadelta/blog.php`, which
  still read "No blog posts to date" even though the operator was logged in as a member.
  So a "Private (Alpha Delta Member Only)" post is not surfaced by the public blog page.
  (The pre-existing 2015 post likewise does not appear on blog.php, consistent with
  blog.php rendering only public posts.)
- `[not tested]` Whether a private post displays on some internal members-only blog view,
  and whether a FUTURE `publishDate` hides a post until that date, were not tested (would
  need more posts / a future-dated post).

## Deletion is self-contained (contrast with the event flow)

After deleting the post, the only residue is **two access-log entries** (post + delete).
There was no orphaned record and no notification. This is cleaner than the event lifecycle
(`raw/pages/event-lifecycle-observed.md`), where deleting the event left an orphaned credit
and a permanent notification. So "delete does not fully reverse" is true for EVENTS
(because completion spawns separate credit/notification records) but NOT for a blog post,
which is a single self-contained record.

## Audit log (operator redacted, verbatim templates)

- `<operator [id]> Deleted Post from Chapter Blog: System Test - ignore [1326] 08-29-2026 10:52am`
- `<operator [id]> Posted on Chapter Blog: System Test - ignore [1326] 08-29-2026 10:51am`

Both entries are permanent; the neutral title means the log contains no AI reference.

## Note on submitting

As with the event create form, clicking the "Post Entry" submit via the element reference
did not fire; a direct coordinate click on the button submitted it. The form is a normal
POST; the non-firing first click appears to be an interaction quirk of the automation, not
a site behavior.

## Follow-up tests: scheduled publish date, and where a private post displays (2026-08-29)

Authorized continuation. Two more posts were created (both neutrally titled) and deleted:
- "System Test - ignore (scheduled)", **public**, publishDate **09/05/2026** (future), blogid 1327
- "System Test - ignore (today)", **public**, publishDate **08/29/2026** (today), blogid 1329

### Result: inconclusive on this chapter, because the public blog isn't displaying posts

`/alphadelta/blog.php` showed **"No blog posts to date"** in every case tried:
- the public today-dated post,
- the public future-dated post,
- the earlier private today-dated post,
- and the pre-existing 2015 post.

So `blog.php` is **not rendering the chapter's blog at all** on this chapter. The
`?action=manageblog` page states the reason: to show the blog externally you must "add the
Blog tab to your header tabs" or "add Blog homepage column from the Manage Webpages page,"
and Alpha Delta has not done that. Its external website blog module is effectively off.

Consequently, **neither follow-up question is observable here**:
- **Does a future publishDate hide a post until that date?** Cannot tell — a public
  today-dated post is equally invisible on `blog.php`, so "hidden because scheduled" is
  indistinguishable from "hidden because the blog display is off."
- **Where does a private post show to members?** Cannot tell — `blog.php` shows nothing to
  anyone here, member or not.

To observe either, the chapter's external-site blog would have to be enabled first (via
`?action=managetabs` / `?action=managepages`), which is beyond a minimal test.

### What IS observable

- The admin `manageblog` list shows **every** post regardless of visibility or date, each
  with its **creation** timestamp (not the publish date), and does **not** visibly flag a
  future-dated post as "scheduled."
- The **edit** form (`?action=editblog`) exposes only `ptitle` and `pcontent` — **not**
  `pvisibility` or `publishDate`. So a post's visibility and publish date are set once at
  creation and cannot be changed by editing it (confirmed by reading the edit form fields).
- Deleting both test posts left only audit-log entries (post + delete each), no orphaned
  records and no notifications — consistent with the blog being a self-contained record.

### Net

The blog scheduling feature exists (the `publishDate` field, plus the release note about
scheduling), but its runtime effect could not be observed on this chapter because the
external blog display is not configured. Recorded as a limitation, not a resolved behavior.
