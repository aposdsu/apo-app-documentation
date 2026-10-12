# Self-only write flows, observed end to end

> Capture pass. Every write below was performed on the operator's OWN member record
> (Kingsley Ramos, userid 34805), then reverted, with the operator's explicit
> authorization to test self-only flows. Neutral test names were used ("System Test
> - ignore"). No other member's data was touched.

Data-guard note: the browser tool blocks output containing query-string / id patterns,
so record ids below are given as `<redacted-id>`. Action verbs (letters only) are shown
verbatim because they are the schema-relevant part.

## Flow A: manual credit ("Add Record") on a requirement

- Requirement used: Service Hours (reqid=3), filter=all, on my own record.
- Baseline: Total Service Hours = 48.5 (internal).
- Add form (`action=addrecord`, reqid=3, userid hidden): fields Service Project (text),
  Date (date), Service Hours (number, fractional allowed), Category (select), and an
  Internal/External radio.
- Submitted with: Service Project "System Test - ignore", Date 08/29/2026, Hours 1,
  Category "Service to the Campus", Internal.
- Result: green "Success — Service Hours logged! Kingsley Ramos has been credited with
  1 service hours." Total moved 48.5 -> 49.5. A new row appeared with recordid
  `<redacted-id>`.
- Revert: opened `action=deleterecord&recordid=<redacted-id>` (GET). Total returned to
  48.5 and the test row disappeared.
- Predicted write target: one credit/record row keyed by (userid, reqid). Deletion of a
  single credit row cleanly reverses the total. [observed]

Contrast with the earlier event flow: deleting an *event* did NOT remove already-awarded
credit; here deleting the *credit row directly* does remove it. So credit rows are
independently addressable and deletable by recordid, separate from the event that created
them. [observed] (see raw/pages/event-lifecycle-observed.md for the event side)

## Flow B: give an award to a member, then remove it

- Give form is on `action=manageUserAwardRecords` (also embedded as the "Awards" tab of
  the member panel, `action=managebrother&userid=<id>&panel=awards`).
- Fields: awardid (select), subtitle (free text), brother (name typeahead), userid
  (hidden), dateawarded (date). The awardid select offered exactly five national
  Distinguished Service Keys: Alumni (2), Chapter (5), National (1), Regional (3),
  Sectional (4).
- Submitted: awardid 5 (Chapter Distinguished Service Key), subtitle "System Test -
  ignore", me, 08/29/2026.
- Result: green "Congratulations! You were awarded the Chapter Distinguished Service Key
  award!" The write endpoint the form posts to is `action=addUserAwardRecord`.
- Where it shows: the award appears under "Award Recipients" on the member panel's Awards
  tab (`managebrother ... panel=awards`), rendered as
  "Kingsley Ramos [System Test - Ignore Chapter]  8/29/2026" under the heading "Chapter
  Distinguished Service Key". It did NOT appear on the standalone
  `manageUserAwardRecords` "Award Recipients" panel (that panel lists chapter-created
  custom awards only, and showed "No awards have been given by Alpha Delta"), and it did
  NOT appear on `action=viewmember`. So national DSK awards and chapter-custom awards are
  two separate lists. [observed]
- Note on the subtitle: entered "System Test - ignore", displayed as "[System Test -
  Ignore Chapter]" (title-cased, with " Chapter" appended). The appended word looks like
  a scope label the display adds, not stored text. [inferred, low confidence]
- Revert: the recipient row has a red trash control linking to
  `action=deleteUserAwardRecord` (GET). Clicking it triggers a native JS confirm()
  dialog. After confirming, "Award Recipients" showed "No awards have been given to this
  member." [observed]
- Predicted write target: one award-record row keyed by (userid, awardid) with a subtitle
  and date. Delete removes that one row. [observed for add + remove; the exact key is
  inferred, medium]

### Tooling note (how the delete was performed safely)
The trash control fires `confirm()`, and a native confirm dialog freezes the browser
automation (CDP input times out). To complete the *authorized* deletion, window.confirm
was set to return true (a benign property write that sends no request), then the trash
control was clicked with a real mouse click. The state change was caused by the genuine
click on the site's own delete control, not by any scripted request. Recorded here for
transparency.

## Permission finding surfaced during Flow B

`action=awardReport` ("All Member Awards Report", linked from `manageUserAwards`) returns
a red "Unauthorized — Only staff sites can manage awards." even for this chapter-admin
session. This is a genuine server-side authorization refusal: there is a level above
chapter admin ("staff sites", i.e. national staff) that gates this report, and the server
enforces it rather than merely hiding the link. This is direct evidence that at least
some authorization IS enforced server-side, contradicting the assumption that an admin is
never refused anything. [observed] It is one page, not proof the whole app enforces every
privilege, but it is a concrete counterexample worth recording.

## Flow C: edit own profile, then revert

- Edit endpoint: `action=editprofile` shows the form; it POSTs to `action=updateprofile`.
- The profile form is EAV-style: field names are `profile[<key>]` (e.g. profile[firstname],
  profile[nickname], profile[email], profile[phone], profile[campusaddress...],
  profile[homeaddress...], profile[major], profile[gender], profile[aboutme], etc.), plus a
  numbered chapter-custom field `chapternumber[<id>]`. 37 editable fields total. Address is
  split into line1 / line2 / city / state / zip / country(select, 247 options). Birthday is
  month/day/year selects. About Me is a textarea, maxlength 255. [observed]
- Live test: About Me (profile[aboutme]) was empty. Set it to "System Test - ignore",
  clicked "Update Profile". Result: green "Profile Updated! Your profile information has
  been successfully updated." The value then displayed in the profile sidebar. Reverted by
  setting About Me back to empty and submitting again; sidebar returned to its empty-state
  placeholder. [observed] Confirms `updateprofile` writes the whole profile row and that a
  single field round-trips cleanly.

### Data-model findings from this form (structure only; no member values recorded)

- **Per-field visibility.** Every profile field has its own visibility control shown to the
  right of it. Observed scope labels: "Anyone", "Anyone + Staff", "Alpha Delta Only +
  Staff", "Hidden (Staff Only)", "Officers". So each profile field value carries an access
  scope; it is not one visibility flag per member. [observed]
- **Profile history / versioning.** The form footer reads: "To maintain profile history,
  any updated values are saved. To delete past information you may clear your profile
  history." So profile edits are versioned (old values retained) and there is a "clear
  your profile history" action. [observed]
- **Custom fields.** A "+ Add a new field to all profiles" link and the numbered
  `chapternumber[<id>]` field confirm chapters can define custom EAV profile fields applied
  to all members. [observed]
- **Child records on a member profile:** Education History ("+ Add education history") and
  Work Experience ("+ add work experience") are one-to-many child lists, not single fields.
  [observed]
- **Profile picture** is a separate form, `action=updateprofilepicture` (POST). [observed]
- **Edit sub-tabs** on the profile editor: Profile Information, Line & Family, LEADS,
  Contact Preferences, Change Password, Attachments, Donations. Each is a distinct
  feature area of a member record. [observed]
- **Corroboration:** the editor shows Account Type "Advisor: Chapter Advisor" and, under
  OFFICIAL, Membership Status "Alumni". This confirms the Advisor account type maps to the
  Alumni national membership status. [observed]

## Flow D: upload a file attachment, then delete it

- Where: the "Attachments" tab of the member panel,
  `action=managebrother&userid=<id>&panel=files`.
- Upload form: POST, one field `file[]` (type=file, multiple). It is an AJAX/auto uploader:
  selecting a file uploads it immediately, no submit button click needed. [observed]
- A "Upload files and share with:" select sets the sharing scope for the upload; default
  "Your Officers, Advisors & APO Staff". [observed]
- Live test: uploaded a 78-byte text file "system-test-ignore.txt". It appeared instantly
  in the folder as: filename, "Added by you", "just now", "0.08 KB", "0 downloads", a
  "NEW" badge, and a trash (delete) control, under the header "Shared with your Officers,
  Advisors & APO Staff". [observed]
- Revert: clicked the trash control (native confirm() dialog, neutralized as in Flow B).
  The file was removed and the folder returned to empty. [observed]

### Data-model findings (file/attachment entity)

- A member attachment stores at least: file name, size, uploader ("Added by you" =>
  uploaded_by member), upload timestamp, download count, sharing scope, and folder. [observed]
- **Two kinds of attachment.** Uploaded files (field `file[]`) and external links
  ("Share External Link" form: cloudFileTitle text, cloudFileUrl url, visibility select).
  So an attachment row is either an uploaded blob or a link to an external cloud file.
  [observed]
- **Folders.** "Create Folder" groups attachments; files belong to a folder. [observed]
- **Sharing scope per file**, not just per member. Same pattern as the per-field profile
  visibility. [observed]
- **Cross-hierarchy sharing.** An expander "Show content shared by groups outside of my
  section and region" shows attachments can be shared up/down the national hierarchy
  (chapter -> section -> region). For a single-chapter rebuild this multi-tenant sharing is
  not needed. [observed]

## Flow E: dues / invoices — documented, NOT executed (deliberate)

- The member panel's "Invoices" tab (`panel=invoices`) is a read-only view titled
  "Member Invoices for <name>", with status filter tabs **All / Open / Pending / Paid /
  Void** and columns **Invoice, Due Date, Total, Actions**. My record shows "You have no
  all invoices." [observed]
- There is **no self-only "add a charge to me" form** on this view. Creating invoices is a
  chapter-level finance operation (tied to the Dues Requirement & Chapter Finances area,
  req1, which the permission matrix shows gated to the Treasurer). Generating dues would
  affect other members, so it is **not a self-only flow**, and it is money-adjacent.
- Decision: documented the invoice model, did **not** execute any financial write. This
  respects the "self-only" scope of the authorization and the standing caution around
  money. If a self-only dues test is wanted, it needs its own explicit go-ahead.

### Data-model findings (invoice entity)

- An **invoice** belongs to a member and has a **status** with four states: Open, Pending,
  Paid, Void. It has a due date and a total. [observed]
- Invoices are listed and filtered per member by status. The "Actions" column implies
  per-invoice operations (pay / void / etc.) that were not opened because there were no
  invoices to act on. [observed / partial]

## Flow F: add a Work Experience child record, then delete it

- Where: the profile editor (`action=editprofile`), "Work Experience" section, "Add work
  experience" opens a modal. Work Experience started empty.
- Modal fields (jQuery-UI dialog): Employer (company, autocomplete text), Job Title
  (title), Industry (industryId select, 20 options), Date Joined (month select + year),
  Date Ended (month select incl. "Current Employer" + year), Location (city, state,
  country select 247). Hidden: action=`addUserJob`, userId, __csrf_magic. [observed]
- Live test: set Job Title "System Test - ignore" (Employer left blank), submitted. A new
  entry appeared: "System Test - Ignore in Accounting since January 2026". So **Employer is
  optional** and Industry/Date default. The add endpoint is `addUserJob`. [observed]
- Revert: each entry has a trash control `a.removeHistory` carrying `data-userjobid`
  (jQuery AJAX delete, with a confirm() dialog; no plain GET URL). Clicking it removed the
  entry; Work Experience returned to empty and Education History was untouched. [observed]

### Education History child record (schema captured by reading, not executed)

- Same pattern, separate modal. Add endpoint hidden action=`addEducationHistory`.
- Fields: institution, degreeLevel (radio), degree, monthJoined (select), yearJoined,
  monthEnded (select), yearEnded, city, state, country (select). Hidden: action, userId,
  __csrf_magic. Delete is the same `a.removeHistory` / `data-userjobid`-style AJAX control
  (a real education entry already existed and was left untouched). [observed for schema;
  add/delete not executed on education to avoid touching the real entry]

### Data-model findings (profile child entities)

- A member profile has three kinds of one-to-many child records, each its own table:
  **education history**, **work experience**, and (separately) **awards** (Flow B). Plus
  the EAV `profile[...]` scalar fields on the member row itself. [observed]
- Work experience links to a normalized **company** (companyId hidden field + autocomplete)
  and an **industry** lookup (industryId), with free-text fallback when the employer is not
  in the list. Education links to an **institution** (free text) and a degree. [observed]

### Tooling note
The small trash icons are jQuery-delegated handlers on tiny targets; synthetic clicks a
few pixels off do not fire them. The reliable method was to zoom the icon region to read
its exact pixel, then click that pixel (with confirm() neutralized). Recorded so a later
run does not mistake "click did nothing" for "delete failed".

## Flow G: Line & Family (lineage) — documented, NOT executed

Not a self-only flow: adding a big/little links another member (the relationship shows on
their record too), and joining/creating a line touches a shared entity. So the forms were
read, not submitted. This page (`action=editfamilytree`, the "Line & Family" tab) directly
confirms the lineage model in proposed-schema.sql.

### Forms observed (all POST) [observed]

- **Join / create a line:** `updatemyfamily` with `familyid` (select of existing lines) OR
  `name` (text, to create a new line). A member belongs to a named **line** (aka family);
  they either join an existing one or create one.
- **Add a big:** `addbig` with `bigname` (name typeahead). "Big Members: No members
  listed" + "Add a big member". The page says: "If you have more than one big member or
  little member select each individually" -> **multiple bigs and multiple littles are
  supported.**
- **Add a little:** `addlittle` with `littlename` (name typeahead).
- **Remove:** "To remove a member from your line tree simply click the red x after their
  name" -> per-relationship delete control.
- **Personal Family (separate):** `addUserRelationship` with `relationship` (select, 9
  types), `otherRelationship` (text, for "Other"), `firstname`, `lastname`, `email`,
  `phone`. This adds a **non-member** family member / personal contact to the member's own
  record (name + email + phone + relationship type). It is distinct from APO lineage.

### Data-model findings (confirms the schema)

- **Big/little is many-to-many.** A member can have several bigs and several littles.
  Confirms the `lineage(big_id, little_id)` join table; a single `big_member_id` column
  would be wrong. [observed]
- **A "line" (family) is its own named entity** that members join; `updatemyfamily` sets or
  creates it. Confirms the `line` / `line_member` tables. [observed]
- **Personal Family is a separate table** from APO lineage: it holds non-members
  (relationship type from a fixed list of 9, plus name/email/phone). Do not conflate the
  two. A single-chapter rebuild still needs both: the APO line (members) and personal
  contacts (non-members). [observed]
- The `addUserRelationship` (personal family) form is the one family write that is actually
  self-only (it adds an external contact to one's own record, affecting no other member).
  It was not executed here to avoid entering placeholder PII; it can be tested on its own if
  wanted. [noted]
