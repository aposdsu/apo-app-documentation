# Run status

> Summary: What the unattended walkthrough of APOonline did on 2026-08-28, what it found,
> what needs a person, and how much of it to trust.
> Status: REFERENCE

## Summary for a returning person

The walkthrough finished. It logged in (the session was already signed in), read 45+ pages
of the Alpha Delta chapter's APOonline site, wrote them to `raw/`, and rewrote the
documentation from that evidence. The read-only walkthrough changed nothing.

Later, with the operator's explicit per-flow permission, a small number of write
operations were run once to see their real effect, then reversed, on throwaway data only:
a test event and a test blog post (created then deleted), and seven "self-only" flows on
the operator's own member record (manual credit, award, profile edit, file upload, work
experience; invoices and lineage were documented but not run). Every one was cleaned up and
the record verified back to its starting state. No other member's data was ever touched.
These runs are what turned the write-operations catalogue from prediction to
partly-verified. See the dated passes below and `raw/pages/*-observed.md`.

**The three findings that matter most:**

1. **We had the permission model wrong.** The site has two permission grids, not one.
   Officer positions carry 39 privileges about what an officer may manage. Account types
   carry 40 privileges about what an ordinary member may do: sign up for events, see the
   roster, log their own hours. Our documentation said permissions came only from
   positions. That is now corrected in `docs/04-system-design/02-auth-and-permissions.md`,
   with the complete lists in `docs/04-system-design/02a-privilege-lists.md`.

2. **Requirements do not belong to a term.** A requirement is written once and carries a
   target for each of the 14 account types. What a term does is set the window of dates
   whose credits are counted. Our schema had a `term_id` on `requirement`, which would
   have forced a chapter to re-enter every rule twice a year. Fixed in
   `docs/02-data-model/proposed-schema.sql`.

3. **Credit is created by an officer completing an event.** Not by signing up, and not by
   attending. There is a queue of "Events Ready to be Completed", and pressing complete
   awards every attendee the credits the event defines. This is the centre of the whole
   product, and it is the workflow to build first.

**Verified on 2026-09-03.** All eight `/verify` checks were run as scripts against the
final documentation, the findings fixed, and the checks run again (`docs/VERIFICATION.md`).
The schema applied cleanly to a fresh PostgreSQL 16.15 and its 21-constraint validation
passed. The defects found were wording drift, not fabrication: three misquotes, one stale
fact that later evidence had contradicted, one imprecise count, and one truncated capture.
All are fixed.

**What to trust:** the permission model (both grids read field by field, all 33 grids
swept, and the per-feature view cross-checked cell by cell against that sweep), the
requirement and credit model, the nine workflows, the data model and schema, and the write
operations, eleven of which were run once with permission and reversed, so their effect is
observed rather than predicted.

**What to be careful with, specifically:** whether the server enforces chapter-level
privileges (only settings were read; one national-level refusal was seen; the rebuild
enforces everything server-side regardless); six facts that are the operator's word rather
than a screen (Graduate Members assigns Alum, the admin reset e-mails a link, there is no
MFA, the late fee and online payment have never been used); five actions with no privilege
row, marked `[inferred]`; and four low-value routes never read.

**Nothing is genuinely blocked and nothing is waiting on a person.** The one open capture,
the forgot-password form's field list, needs a signed-out session and is a standard
enter-your-e-mail form; it is worth knowing, not owed. The section below lists what is
worth knowing, not what is owed.

## Progress

All phases complete.

| Phase | Status |
|---|---|
| Recon (is it a PHP app or a JS app?) | done. It is a server-rendered PHP app, one controller, `memberhome.php?action=<verb>`. No JSON API, no XHR worth reading, no source maps. The plan in CLAUDE.md was correct. |
| Login | done. No login was needed; the browser session was already signed in. Navigating to `login.php` redirected straight to the chapter home. |
| Admin sweep | done. Officer positions, account types, both privilege grids, requirements, system settings, term dates, chapter profile, budgets, ledger, access log, reports. |
| Crawl and capture | done. 45 pages captured to `raw/pages/`. |
| Schema inference | done. `docs/02-data-model/` rewritten and the SQL revised. |
| Page write-ups | done. 15 detailed pages plus an index covering the rest, in `docs/01-pages/`. |
| System design | done. Permissions rewritten, workflows written, glossary, scope and milestones corrected. |
| Write operations | done. Every form found has a prediction in `docs/03-api/write-operations.md`. |
| Gap check and verification | done. `docs/GAPS.md` and `docs/VERIFICATION.md`. |

## Done

- **45 page captures** in `raw/pages/`, plus one corrections note.
- **About 30 forms read** in full: target, method, every field name, type, maximum length,
  required flag, and every option value. None submitted.
- **Both privilege grids read field by field**, including which value each radio sends,
  which is how the eight inverted privileges were found.
- **The eight open questions** from the original data model: six answered with evidence,
  one partly answered, one recorded as unanswerable without a person.
- **9 admin surfaces found empty** on this chapter (lines, awards, achievements, minutes,
  forms, courses, announcements, point trackers, fundraising funds). Their structure was
  read from their create forms where one existed.
- **0 changes made to the site.**

## Second pass, 2026-08-29: the Diamond upgrade

The chapter upgraded from the $3 tier to the $5 tier, which unlocks nine features that were
previously blocked behind an advertisement. All nine were swept and captured to
`raw/pages/diamond-tier-sweep.md`.

**The finding worth reading: the upgrade unlocked page access, not software.** No navigation
entry appeared and no form gained a field. The event form has the same 58 field names as
before, including `eventinfo[requireCheckIn]`; the only difference is that the words
"Diamond Subscription Required" are no longer printed next to it. That is a second, cheaper
illustration of the same lesson as the permission model: a control hidden in the interface
is not a control that is switched off.

What the sweep added that the data model did not already have:

- **Files carry an audience**, one of "Officers & Advisors Only", "Initiated Members",
  "Non-Initiated and Initiated Members", and a "file" may be a link to something hosted
  elsewhere rather than an upload.
- **Photo albums have an approval step**, matching the officer privilege that already
  existed for it.
- **SMS is capped at 128 characters**, one message segment.
- **E-mail and SMS share one audience model**: everyone or one event's attendees,
  intersected with account types.
- **Fundraising is funds and campaigns**, with offline donations loggable.

None of it changes the schema. All of it went into
`docs/04-system-design/05-feature-infrastructure.md`, and every one of the nine features
keeps its SKIP or LATER tag.

**A third pass then opened the forms behind those pages**, because the first Diamond pass
had only read the management landing pages, which is not the same as seeing how a feature
works (`raw/pages/diamond-features-how-they-work.md`). What that added:

- **A blog post has a publish date and a public-or-members-only visibility.** The public
  page at `/alphadelta/blog.php` shows "No blog posts to date" while the admin list shows a
  stored 2015 entry. Those two fields are why.
- **Event attachments are deleted after six months**, stated on the page. That is a
  recurring cleanup job, and the first retention rule found anywhere on the site.
- **A sign-up carries a free-text comment**, from the attendee table's columns. This is a
  small correction to the data model, which had the sign-up carrying only driver
  information.
- **A fundraising fund can double-write a donation into the transaction ledger**, decided
  by one switch per fund.
- **Public header tabs are exactly four slots** chosen from six fixed types.
- **An unknown `action` value renders the home page instead of a 404.** Two wrong guesses
  both returned the dashboard. Anyone mapping this site cannot tell a bad route from a good
  one by the response.

**And one thing worth telling the chapter:** the photo album upload page,
`?action=addpictures`, is switched off by the vendor and reads "Check back Summer 2025 to
see the latest updates." It was still offline in August 2026, more than a year later, while
Photo Albums remains a listed feature of both paid tiers. You are now on the tier that
includes it.

## Completeness pass, 2026-08-29

Earlier summaries said features were "partially" captured. That was not good enough, so the
gap was measured rather than estimated: every `action=` verb mentioned anywhere in `raw/`
was extracted (109 of them) and checked against the captures. **Twenty-two routes had never
been opened.** All twenty-two are now captured.

Coverage is now 93 of 109 verbs. The other 16 are the write verbs that must never be
opened, and each has a predicted effect in `docs/03-api/write-operations.md`.

Five surfaces genuinely cannot be reached without writing, and are now listed as such
instead of being left ambiguous: the e-mail wizard's last three steps, the award ballot
setup screen, mobile check-in at run time, any invoice detail (this chapter has none), and
photo album image handling (the vendor has switched it off).

**Corrections this pass forced:**

- There are **five** per-field visibility levels, not three. The earlier reading came from
  the officer's view of another member; the member's own editor shows all five.
- **Profile fields are versioned.** The editor says so outright, which explains the
  audit-log line "Cleared profile history" that had been unexplained since the first pass.
- **A member has affiliations, one marked primary** — direct evidence, previously inferred.
- **An event can carry no requirement at all** ("Other Events").
- **A form question can write back into a member profile field.**
- **`docs/03-api/write-operations.md` was incomplete.** Fourteen operations found in the
  later passes had no entry, including a delete link. All added.

## Full reading pass, 2026-08-29

I had been reading extracts, not pages, and had let "never record personal data" turn into
"do not read the page". Those are different things. Every page was then re-read end to end,
checking each page's character count so the end was known to have been reached.

**Honest coverage number: 99 of 105 routes are verified as read end to end** against their
own character count. The remaining 6 are captured in structure but not verified as fully read; they are almost
all id-parameterised variants of templates already read in full, and they are listed
individually in `docs/GAPS.md`. The running checklist is in
`raw/pages/full-read-pass-2.md`.

**A correctness bug this pass found in our own schema.** The progress report's footnote says
"the first value is the total external hours up to the personal cap and the value in
parenthesis is the total uncapped value recorded". Our `requirement_progress` view summed
external credit **without applying the cap**, so it would report a number the vendor's own
report disagrees with. Fixed: the view now returns capped and uncapped separately, and the
validator proves a member with 11 external hours against a cap of 5 counts 5 toward the
total while keeping the 11 on record.

**The correction that matters most: "Line" is not the product's word.** A settings page
reachable only from a sentence buried inside another page,
`?action=editfamilysettings`, lets a chapter rename "Family" to "Group" or anything custom,
and "Big/Little" to "Parent / Child" or anything custom. Alpha Delta set theirs to
"line/lines". Every document that said "the site calls a family a Line" was describing this
chapter's own configuration rather than the software. Fixed, and the data-model documents
now warn that **no on-screen noun should be assumed to be the product's own term** — that
includes Line, Big, Little, and every requirement name.

Other things only a full read caught:

- **Registration approval is Skip, Reject, or assign a type**, not a single Approve button,
  and each applicant states what they are asking to become.
- **A member-award record stores who granted it**, visible only as a report column.
- **Chapter awards are a separate entity** from member awards, with Trophies and In The News
  alongside them.
- **Leaderboards are requirement x internal/external x term/lifetime.**
- **The family listing hides alumni and inactive members by default.**
- **Two more routes** referenced only in mid-page prose: award CSV import and the award
  report.

## Gap resolution, 2026-08-29

Asked whether the gaps were resolved, the honest answer was no: seven were open. Three are
now closed by looking, and one is sharpened
(`raw/pages/gap-resolution.md`).

**The one worth reading: the product does not keep attendance separately from sign-ups.**
This had been a medium-confidence guess resting on never having opened a *completed* event.
One was opened. The attendee table is the same single list before and after completion, with
no present/absent column; the only change is that "Complete event" becomes "Update
attendees". So the vendor genuinely cannot record "signed up and did not come", and our
recommendation to keep two tables is a real improvement.

Also closed: `?action=editstatus` uses one endpoint for create and update, decided by whether
`statusid` is posted; and the officer page's 26 rows are one row per *assignment*, not per
position (three positions are co-held, the advisor position has five slots).

**Four gaps remain, all genuinely unreachable from a read-only admin session**, each with the
reason stated: the effect of a mid-term account-type change, whether progress is cached,
whether the server enforces its privilege model, and which account type "Graduate Members"
assigns.

A separate sweep covered the category that had been weakest, **buttons and dropdown values**.
It recovered the server's own member field names from the report builder's checkbox values,
including two fields on no edit form (`dateRegistered`, `dateLastLogin`), and the literal
values `dues` and `new` that sit alongside numeric ids in two filters.

## Exhaustive pass, 2026-08-29

Every earlier pass found the same kind of miss one layer deeper. This one went after the
layer beneath: routes that appear in no menu, and settings grids read once when there were
33.

**Method:** read the network traffic (42 requests, no XHR, no JSON API, confirming the recon
assumption); read the DOM for client-side state (none, no app globals, no data attributes);
harvested every `action=` value from the anchors of twelve hub pages instead of from the
visible menus; and opened all 33 permission grids.

**Nine routes exist that no menu reaches.** The most important is
`?action=editchapterlinks`, which is **how the navigation-menu links are edited**. The
dashboard's "External Links" panel is wired to the wrong route, so following the interface
never gets you there. Also found: the custom profile field builder, the award-granting form,
a roster verification tool, album creation, the LEADS editor, the password and social-login
page, and two write verbs recorded but not opened.

**The permission matrix is now complete**, all 19 positions and all 14 account types
(`raw/pages/permission-matrix-complete.md`). Reading one grid had hidden that five positions
hold every privilege rather than the two marked "(Primary)", that Conference Chair holds
none, and that five account types are identical to each other.

**Three corrections to work already published:**

- **Big/little is many-to-many.** The site says so in its own words. The schema's single
  `big_member_id` column was wrong; it is now a `lineage` join table, and the validator
  asserts a member can have two bigs.
- **The product does keep account-type history**, as a typed "Membership Status Change"
  entry on the profile Timeline. GAPS had recorded the opposite reading. Now closed.
- **A blank goal and a zero goal behave differently.** Our schema collapses them; that is
  now a knowing decision rather than an accident.

**One security observation:** the public registration form caps passwords at 15 characters.
Recorded, with the recommendation never to do that.

**Coverage: 119 verbs seen, 104 captured, 19 write-only with predictions, zero unaccounted.**

## Reading pass, 2026-08-29

Two more passes after the route-coverage one, both prompted by the same fair criticism.

**The What's New page had been sampled, not read.** Its own capture said so: about 13,000
of 27,700 characters. On a release-notes page that is nothing but a feature list, sampling
loses features. Reading it in full turned up a **Conference Manager** (ticket options,
per-ticket question sets, group registration in one payment, free tickets), **social login
with Google and Facebook** (verified on the live site, and a real gap in the authentication
document, which had described login as e-mail and password only), **scheduled bulk e-mail**,
**anonymous forms that also enforce one submission per person**, and a **seventh membership
status, "Guest"**, that the live dropdown does not offer.

**Then every capture that described itself as incomplete was finished.** A grep for
"sampled", "truncated", "partial" and "not read" found seven. All are now closed. That
turned up a **waitlist on capacity-limited events**, which no event screen shows and which
is visible only as a notification switch; the accounting rule **"Fees are not included in
balance totals"**; **employers as records rather than free text**; the complete officer
position id map; and one real disagreement between the vendor's data and our schema, now
recorded in GAPS.

## Authorized write-flow verification, 2026-08-29

Up to here the documentation described write operations by reading their forms. The
operator then gave explicit, per-flow permission to run a few of them once, reversibly, so
the predictions could be checked against reality. Everything was on throwaway data and
cleaned up afterward; no other member's data was touched. Full detail is in
`raw/pages/event-lifecycle-observed.md`, `raw/pages/blog-lifecycle-observed.md`, and
`raw/pages/self-flows-observed.md`.

**Event and blog lifecycles** (earlier in the day): a test event was created, completed
(awarding credit), and deleted; a test blog post was created and deleted. Key finding:
**deleting an event does not remove the credit or the notification it already awarded** —
both are orphaned — whereas deleting a blog post is clean. So credit is not owned by its
event once awarded.

**Seven self-only flows on the operator's own record**, each run then reverted:

- **Manual credit** (`addrecord`): added 1 service hour (total 48.5 -> 49.5), then
  `deleterecord` removed it (-> 48.5). A credit row is addressable and reversible by
  `recordid`, unlike the event case above.
- **Award** (`addUserAwardRecord`): gave self a Distinguished Service Key, then removed it
  (`deleteUserAwardRecord`). Surfaced a real server refusal: `awardReport` returns
  "Unauthorized — Only staff sites can manage awards" even to a chapter admin. That is the
  first observed counterexample to "an admin is never blocked", now noted in the auth doc.
- **Profile edit** (`updateprofile`): changed and restored the "About Me" field. Confirmed
  per-field visibility scopes and profile versioning by seeing the live form.
- **File upload**: AJAX `file[]` auto-upload to the member's Attachments store, then
  deleted. Confirmed the file/attachment record shape (name, uploader, timestamp, size,
  download count, folder, sharing scope) and that an attachment is either an upload or an
  external link.
- **Work experience** (`addUserJob`): added a job (employer optional), then deleted it via
  its `removeHistory` control. Also captured the education-history schema
  (`addEducationHistory`) by reading, without touching the real education entry.
- **Invoices** and **Line & Family**: documented from their forms but **not run** — invoice
  creation is a chapter-level (multi-member) finance action, and adding a big/little or a
  line links another member. Reading them still confirmed the invoice status set (Open,
  Pending, Paid, Void) and the many-to-many lineage / separate personal-family model.

Net effect on the docs: `docs/03-api/write-operations.md` now marks the run operations
**[verified]** with their real `action` verbs; the auth doc records the one server refusal;
the data model gained the invoice status set. The operator's record was verified back to
its exact starting state (service hours 48.5, no test award, About Me empty, no test file,
no test job).

## Unread-routes sweep, 2026-08-29

Read in full the routes that had been captured in structure but never read end to end
(`raw/pages/unread-routes-sweep.md`). New or corrected findings:

- **The Dues requirement (reqid 1) is a special requirement type**, not a generic one: it
  splits each dues amount into Chapter / Region / National, has a due date and time, an
  automatic late fee toggle, and an accept-online-payments toggle. Dues unify the
  requirement/progress model with the finance model.
- **The custom-field builder exposes a richer per-field permission model** than the built-in
  editor's five levels: each field has a type, a unique flag, an importance
  (optional/recommended/required, the last two also placing it on registration), a
  membership-status scope, a merge code, and TWO separate ACLs (view and edit).
- **Forms** are a Google-Forms-style builder: a 13-type question enum including "Member
  Field to Update" (a form answer can write into a profile field) and Single/Multiple
  Members, plus sections and an anonymous option.
- **Courses** are an LMS feature (modules with ordering, completion frequency, audience,
  downloadable certificate).
- **Correction:** big/little lineage IS populated (the public `familytree.php` draws it),
  even though the chapter has no named "lines". The two were previously conflated.
- **Store manager is plan-gated** and not enabled on this chapter, so unreadable.
- Minor: Job Board, member-to-member messaging, bulk-email drafts, and donation types
  (cash / non-cash / soft credit) all confirmed as real but out-of-scope for one chapter.

All folded into the data model, GAPS, and write-operations docs. Nothing on the site was
changed during this sweep (reading only).

## Previously blocked, now resolved

The session expired partway through a follow-up check on 2026-08-29, and re-authentication
through the password manager failed (`request_credentials` returned a connector-side schema
error four times; `autofill_credential` reported `no_grants`). Per the login runbook in
`CLAUDE.md`, no further attempts were made and no password was typed by hand or requested
in chat.

The account owner signed in directly, and both outstanding pages were captured. Nothing is
blocked.

## Worth knowing

Nothing else here blocks anyone. None of it is a question waiting on an answer.

1. **The two pages that were missing are now captured.** The product's "What's New"
   release notes (September 2018 to June 2026) and the full subscription tier matrix. They
   produced a new document, `docs/04-system-design/05-feature-infrastructure.md`, on what
   each feature actually takes to build. Neither affects the data model.

2. **The schema is tested.** It was applied to a throwaway PostgreSQL 16.15 database and
   checked with `scripts/validate_schema.sql`, which seeds fake data and asserts that both
   views return the right numbers and that twenty constraints reject what they claim to.
   Running it found one real defect, a trailing comma that made the file fail to parse
   from `CREATE TABLE requirement_credit` onward. Fixed. Details in
   `docs/VERIFICATION.md`.

3. **One open question a chapter officer could answer in a sentence.**
   What happens to a member's credits and targets when their account type changes mid-term
   is not shown on any page, and answering it by testing would mean changing a real
   person's record. Recorded in `docs/GAPS.md`. The documentation is complete with this gap
   in it; it is not waiting on it.

   Note on what is deliberately NOT here: whether APOonline's server enforces its own
   permissions, and whether it caches progress, are questions about the vendor's
   implementation, not about the model we are documenting. This is a clean-room rebuild, not
   a copy, so our system enforces server-side and computes live regardless of what the
   vendor does. Those are settled design stances, not open gaps. See the reframed entries in
   `docs/GAPS.md`.

4. **Decide whether to keep the eight-question answer to question 8.** What happens to a
   member's credits and targets when their account type changes mid-term is not visible
   anywhere on the site. Answering it needs an officer of the chapter, not another crawl.

5. **Read four form `action` attributes.** The browser extension used for this run blocks
   tool output that looks like query-string data, and on four pages it refused to return
   the form's target. Everything else about those forms was read. A person with View Source
   can fix this in about a minute. The four are listed in `docs/GAPS.md`.

6. **`/walkthrough` now exists.** It did not when this run started: there was no
   `.claude/commands/` directory, so none of the ten commands the README describes
   resolved to anything, and the run followed the phases by hand. The ten files have since
   been written, and they carry the lessons this run learned, including which browser tool
   to use for link hrefs and the rule for which links are safe to open.

7. **A judgment call, disclosed rather than asked.** Rule 1 forbids opening links that perform actions.
   Some pages can only be reached by a link whose verb sounds like a write, in particular
   `?action=eventsignup&eventid=` (the event detail page) and `?action=eventcreate` (the
   empty create form). The rule used was: **open a link only when it carries no value to
   store**, so a GET of it cannot write meaningful data, and when the site itself uses that
   link as its "open this record" link. On that basis the event detail page and the empty
   create forms were opened, and every delete, complete, send, approve and
   `&notify=1`-style link was not. If that line is drawn in the wrong place, the pages
   affected are listed in `docs/INVENTORY.md`.

8. **The chapter's real data was visible throughout.** 589 member records with names,
   e-mails, phone numbers, addresses, birthdays and national id numbers, and an access log
   naming individuals. None of it was written to `raw/` or `docs/`. If you re-run this
   walkthrough, keep that rule; several pages dump the entire roster into the page text
   without being asked.

## Confidence

| Document | Trust it? |
|---|---|
| `docs/04-system-design/02a-privilege-lists.md` | Yes. Read field by field from the site's own grids. The strongest evidence in the set. |
| `docs/04-system-design/02-auth-and-permissions.md` | Yes for the model. No for enforcement, which is explicitly unverified. |
| `docs/02-data-model/00-domain-model.md` | Yes. Every claim cites a capture or says it is inferred. |
| `docs/02-data-model/01-how-the-vendor-differs.md` | Yes for the differences. The recommendations are opinions, and are marked as such. |
| `docs/02-data-model/02-questions-answered.md` | Yes, except question 8, which is marked low confidence. |
| `docs/03-api/write-operations.md` | Yes for the form structure. Every effect is a prediction and says so. |
| `docs/02-data-model/proposed-schema.sql` | The design, yes. The SQL, not until it has been run. |
| `docs/04-system-design/03-flows.md` | Yes. Each step cites the screen it came from. |
| `docs/01-pages/` | Yes. Each write-up covers one page and names its capture. |
| `docs/05-rebuild-plan/00-feature-inventory.md` | Yes for what exists. The CORE/LATER/SKIP tags are judgement, not fact. |
| Anything about lines, awards, achievements, minutes, forms or courses | Thin. Those features are unused on this chapter, so only their create forms could be read. |
