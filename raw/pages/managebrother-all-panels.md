# Capture: every Account Manager panel

- Captured: 2026-08-29. The panel list was read from the anchors on the Account Manager
  page: `apoleads, awards, engagement, events, family, files, notifications, profile,
  records, status`. Ten panels; earlier captures covered two.
- URL pattern: `?action=managebrother&userid=<id>&chapterid=311&panel=<name>`
- Nothing was submitted. Member names and personal values are not recorded.

## panel=status — "Member Account Type & Membership Status"

Text, verbatim:
"Change a member's account type, set a Chair Position, or remove someone from this chapter.
If you remove someone and they have an account with another APOonline website, only this
chapter's data will be removed but their account will still be active on their other sites."
"Looking to update <name>'s status? Use the Members > Transition Members tool instead.
Only use the form below for manual status overrides."

Controls: an "Account Type" select with all 14 types, a "Revoke Access" option, and a
checkbox per officer position (19).

Form (post): `__csrf_magic`, `chapterid`, `userid[N]`, `status[N]`, `positions[N][]` x19,
`chairTitle[N]`, `notify[N]` x2, `reasons[N]`, submit.

Three fields worth noting:
- **`reasons[N]`** — the change carries a reason. Nothing else on the site asks for one.
- **`notify[N]`** — a pair of radios, so the officer chooses whether the member is told.
- **`chairTitle[N]`** — a free-text chair title separate from the position checkboxes.

**The sentence about removal is the clearest statement anywhere on the site that a person
and a chapter membership are different records.** Removing someone from this chapter deletes
this chapter's data only; the person's account survives on their other chapters' sites.

## panel=family — lines and personal family

Text, verbatim:
"Edit Line Tree » <name>"
"Edit <name>'s line tree here. **If they have more than one big member or little member
select each individually from the boxes on the right.** To remove a member from their line
tree simply click the red x after their name."
"Alpha Phi Omega Line", "Join a line", "- No line listed -",
"Or, create a new line by entering the name below:",
"Big Members:", "Little Members:", "No members listed", "Personal Family",
"Select a relationship".

Four separate forms (all post, none submitted):

| # | fields | what it does |
|---|---|---|
| F1 | `__csrf_magic`, `userid`, `chapterid`, `familyid`, `name` | join an existing line by id, or create one by name |
| F2 | `__csrf_magic`, `userid`, `chapterid`, `bigid`, `bigname` | add **one** big |
| F3 | `__csrf_magic`, `userid`, `chapterid`, `littleid`, `littlename` | add **one** little |
| F4 | `__csrf_magic`, `userIdA`, `chapterId`, `relationship`, `otherRelationship`, `firstname`, `lastname`, `email`, `phone`, `submit` | add a personal family member |

**This corrects the data model.** The starting schema stored a single `member.big_member_id`
and said "If a member can have more than one big, this would instead need its own table."
The page states in its own words that a member can have more than one big **and** more than
one little, and the forms add them one at a time, which is the shape of a many-to-many
relationship. The observed member has one big and no littles.

"Personal Family" is a separate idea from a Line: it records a member's real relatives, who
need not be members. `relationship` options, verbatim: Mother / Father / Guardian, Spouse,
Sibling, Child, Cousin, Aunt / Uncle, Niece / Nephew, Other... with `otherRelationship` for
free text. It carries a name, e-mail and phone, so the relative is stored as a person
record in their own right.

## panel=engagement — the per-member message log

Text, verbatim: "Modify Contact Preferences", "Email and SMS Engagement".
Table headers: "Sent On | Subject / Message".
Body: "No emails or SMS messages have been sent to this member."

So every bulk e-mail and SMS is recorded against each recipient, not only against the send.
That is what makes "Email OK" preferences auditable, and it is the delivery-tracking half of
the e-mail system.

## panel=events — events attended

Heading: "Alpha Delta's events attended by <name>:".
A reverse-chronological list of event dates and titles. On the observed member it runs from
September 2026 back through the previous academic year.

Note the wording is "events attended", and the list includes events in the future that the
member has signed up for. So the same list serves both, which is more evidence for the
observation in `docs/02-data-model/01-how-the-vendor-differs.md` that sign-up and
attendance are not distinguished.

## panel=files — a per-member file store

"Upload files and share with: <name>'s Officers, Advisors & APO Staff", then the same
"Create Folder", "Share External Link", "Upload", "Drag & Drop Files" controls as the
chapter file manager. Empty on this member.

So there are at least two file scopes: chapter files (three audiences, recorded in
`raw/pages/diamond-tier-sweep.md`) and per-member files with a single fixed audience.

## panel=awards — give an award to this member

The same form as `?action=manageUserAwardRecords`, with the member pre-filled. Five
built-in Distinguished Service Key awards. Body: "No awards have been given to this member."

## panel=notifications — the member's notification settings

Identical to `?action=contactPreferences`, but shown to an officer for another member. So an
officer can change a member's notification preferences on their behalf.

## panel=apoleads and panel=profile

`apoleads` is the LEADS record (`raw/pages/custom-fields-and-leads.md`).
`profile` is the profile form; `panel=account` reaches the same screen, so `account` is an
alias.

## A write verb found on this page and NOT opened

`?action=resetPassword` appears as a link in the Account Manager. It would send or force a
password reset for the member. Recorded, not opened.

## Follow-up: what "Chair Position" / chairTitle is (investigated 2026-08-29)

On the status panel (`panel=status`), the intro says "Change a member's account type, **set a
Chair Position**, or remove someone from this chapter." The mechanism:

- There is a hidden row labeled **"Chair Position:"** containing an optional free-text input
  `chairTitle[N]`, placeholder **"Optional"**.
- It is **hidden on load and revealed when the Account Type dropdown (`status[N]`) is
  changed** to any value. Ticking a position checkbox does NOT reveal it; changing the
  account type does. (Determined by cycling the select's options and watching the row's
  visibility, read-only, no submit.)
- It is submitted with the "Update Account Type" action, together with `status[N]`,
  `positions[N][]`, `notify[N]`, and `reasons[N]`.
- It is **independent of the 19 defined officer positions**, which are the checkboxes
  directly above it. So it is a per-member custom title, a lightweight way to label someone
  as a chair of something without creating a chapter-wide officer position.
- `[unverified]` Where the title displays was not confirmed, because confirming it needs a
  write (setting a title, then checking the profile/roster). Inference: member profiles
  render the account type as "AccountType: Title" (e.g., the operator's own profile shows
  "Advisor: Chapter Advisor"), so a set chair title would most likely appear as that
  trailing label. Not tested.
- The "+ add a new officer position" link on this same panel is NOT related: it navigates to
  `?action=editofficerpositions` (the chapter-wide Define Officer Positions page), whose
  "Add an officer position" form is Title + "Applies To: Officers Only / Advisors Only /
  Both Officers and Advisors".
