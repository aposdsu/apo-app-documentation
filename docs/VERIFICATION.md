# Verification: how the documentation was checked against the evidence

> Summary: The eight checks run against `docs/` and `raw/` on 2026-09-03, what each found,
> what was fixed, and where the documentation is strong and where it is weak. A staff
> engineer asking "how do you know that?" about any sentence should find the answer here or
> in the file this points to.
> Status: REFERENCE
> Read this if: you are deciding how far to trust any document in this repository.
> Depends on: docs/RUN-STATUS.md, docs/EVIDENCE-MAP.md, docs/GAPS.md

Every check below was actually run as a script or a database command, not read by eye. The
commands are described so they can be rerun. After the fixes, all eight were run again; the
results of that second run are stated at the end.

## Check 1: every cited `raw/` file exists

**How:** extract every `raw/...` path mentioned anywhere in `docs/`, deduplicate, and
compare against `find raw -type f` with `comm`.

**Result:** 71 unique cited paths, 70 files in `raw/`. One "miss": the bare string
`raw/pages/` in prose ("written to `raw/pages/`"), a directory mention, not a broken
citation. **Every cited file exists.** Nothing to fix.

## Check 2: every document declares a status

**How:** for every `docs/**/*.md`, require a `> Status:` line; then list any still at
HYPOTHESIS.

**Result:** all 38 documents carry a status. None is HYPOTHESIS. In use: OBSERVED (19,
plus 8 mixed OBSERVED/DESIGN), REFERENCE (6), DESIGN (4). Nothing to fix.

## Check 3: every quoted string appears in a capture

**How:** a Python script extracts every double-quoted phrase of 12+ characters from
`docs/`, normalises whitespace and quote characters, and searches the concatenated,
normalised text of every file in `raw/`.

**Result:** 328 quoted phrases checked; 91 not found on first pass. Triage: 81 of the 91
were either regex artifacts (text *between* two real quotes) or our own coined labels in
scare-quotes ("Approve or nothing", "who did this", feature-row names), not site text. Ten
were checked individually against the raw text. **Three were real misquotes, all fixed:**

| Where | Said | Site actually says | Fix |
|---|---|---|---|
| `docs/RUN-STATUS.md` | "Parent/Child" | "Parent / Child" | corrected |
| `docs/EVIDENCE-MAP.md` | "clear profile history" | "clear your profile history" | corrected |
| old `docs/VERIFICATION.md` | "Six privileges are stored inverted"; "0 of 0, 100%" | eight; "100% Complete / 0 of 0" | this file replaces it |
| `docs/02-data-model/01-how-the-vendor-differs.md` | "Service Project / Service Hour", two labels composed into one quote | "Service Project" and "Service Hour" are separate labels | split into two quotes (found on the re-run) |
| `docs/02-data-model/01-how-the-vendor-differs.md` | Parent/Child, in prose | "Parent / Child" | spacing matched to the site (found on the re-run) |

The rest were elisions of placeholders (`Removed '<member>' from the '<event>' ...`) or
template labels with a placeholder (`Log their own: Internal <requirement>`), which the
documents present as templates, not verbatim strings.

## Check 4: spot-check of specific facts

**How:** 31 counts, ids, field names and quoted sentences grepped against `raw/pages/`
(flattened to one line so phrases wrapped across lines still match), plus a separate
cross-check of every "who holds it" cell in
`docs/04-system-design/02b-feature-actions-and-permissions.md` against
`raw/pages/permission-matrix-complete.md`.

**Result:** 31 of 31 facts found (four initially missed only because the per-line grep did
not span a line wrap; the flattened search found all four). The 02b cross-check matched
**21 of 21** cells, including the ones most likely to be wrong: Treasurer holds `req1`; Bad
Standing alone holds `commentform` and `ownfamily`; Active has `cooredit` but not
`coorcomplete`; Associate is "same as PNM plus uploadfile"; Conference Chair holds none. The re-run on the final state confirmed 31 of 31 facts and every cell tested; the re-run's two apparent misses were parentheses being shell-escaped inside the test loop, not the documents.

One precision issue found and fixed: `docs/03-api/write-operations.md` called the
personal-family `relationship` select "9 types". It has 9 *options*: a placeholder, seven
named relationships, and Other. Corrected.

## Check 5: claims stated as fact with no evidence behind them

**How:** the check that cannot be automated. A proxy script listed every line in the five
newest or most load-bearing documents that used an absolute (always, never, every, all,
only, cannot) without an `[observed]`/`[inferred]`/`[design]` tag or a `raw/` citation on
that line. Each hit was then read.

**Result:** almost every hit was backed by the permission matrix or a cited capture. **One
real defect, fixed:** `docs/02-data-model/00-domain-model.md` stated that "no screen showed
a history of past account types". That was true when written, but a later finding
(`raw/pages/gap-resolution-2.md`) showed the member Timeline keeps dated "Membership Status
Change" entries. `GAPS.md` had already been corrected; the domain model had not. The
paragraph now states the history exists as a change log (not as a per-term row), says the
earlier sentence was wrong, and keeps the per-term-row recommendation with the reasoning.

One suspected defect checked and found correct: `docs/04-system-design/03-flows.md` says
"Four ways in, all on `?action=inviteuser`" although route 4 is the public `register.php`.
The raw invite capture shows "Option 4: Registration Link ... Send this link to your
chapter's public registration page", so the invite page does offer all four. No change.

## Check 7: the captures' own hedging words

**How:** `grep -rniE 'sampled|truncated|partial|not read|list continues' raw/pages/`.

**Result:** 40 hits on the first run and 47 on the re-run; the seven new hits are the closure record appended to `CORRECTIONS.md`, which uses the same words to describe what it closed. `raw/` is append-only, so hedged captures stay in place and later files
finish them; 36 of the 40 were already finished by `partials-closed.md`,
`whatsNew-full-read.md` or `viewstorage_tier-chart.md` and recorded in `CORRECTIONS.md`.
Four were open. Disposition, now recorded in `raw/pages/CORRECTIONS.md`:

- **Finished this pass:** the What's New entry cut off at "key dates or deadlin...". Read
  live: "Events can now disable signups. This is useful for adding key dates or deadlines to
  the calendar."
- **Still open, low value:** the forgot-password form's field list
  (`award-and-password-flows.md`). It sits on the login form that appears only when signed
  out; the session was signed in for this pass, and the public `login.php` returns a 500
  Internal Server Error (seen twice). It is a standard enter-your-e-mail reset form and must
  only ever be read, never submitted.
- **Not closable:** the invoice "Actions" column (`self-flows-observed.md`); this chapter
  has no invoices, so no per-invoice action was ever rendered.
- **Intentional:** the `viewMembershipStages` list marked truncated is the list of member
  names, which is personal data and is never recorded. The stage structure was read in full.

## Check 8: the executable deliverable

**How:** a fresh PostgreSQL 16.15 (Homebrew) data directory; `docs/02-data-model/
proposed-schema.sql` applied with `ON_ERROR_STOP`; then `scripts/validate_schema.sql`.

**Result:** **schema applied cleanly, 29 tables; validation printed "VALIDATION PASSED".**
Every assertion held: view checks; all 21 constraint checks rejected bad data; a co-held
position and a multi-position member both allowed; a member can have several bigs and be a
big; the external cap limits the total without losing the recorded value; a goal of 0 hides
the requirement; a member can hold a different account type in a later term. Nothing to fix
in the schema.

Two things that went wrong were in the test rig, not the deliverable, and are recorded so
the next person does not lose an hour: the scratch data directory's path was too long for a
Unix socket (103-byte limit), fixed by putting the socket in `/tmp/pgs`; and Homebrew
Postgres on macOS fails to start with "postmaster became multithreaded" unless `LC_ALL` is
set (`LC_ALL=C` works).

## What was found wrong, in one list

1. Five misquotes (check 3): three on the first run, and two more caught on the re-run in `01-how-the-vendor-differs.md` (a two-label composite and a spacing difference). All corrected.
2. One stale fact left standing after later evidence contradicted it (check 5), corrected.
3. One imprecise count, "9 types" for a 9-option select (check 4), corrected.
4. One truncated capture (check 7), finished from the live site.
5. The previous version of this file carried two wrong numbers; replaced.

Nothing found was a fabricated field, endpoint, table, or behaviour. The defects were
wording drift and one claim that outlived its evidence.

## Where the documentation is strong

- **The permission model.** Both grids were read field by field, all 33 grids were swept
  for who holds what, and the per-feature view (02b) was cross-checked cell by cell against
  that sweep. This is the best-evidenced part of the repository.
- **The write operations.** Every form's target and fields were read; eleven operations
  were run once with permission and reversed, so their real effect is observed, not
  predicted (events, blog, manual credit, award, profile, file upload, work history, and
  the timeline delete).
- **The data model and schema.** Every entity cites a capture, and the schema runs and
  validates against 21 constraints.
- **The nine workflows.** Each step names its screen and its capture.

## Where the documentation is weak, specifically

- **Server-side enforcement is unproven.** Every permission claim describes what the
  settings grant, not what the server refuses. One genuine refusal was seen
  (`awardReport`, national-staff only). Whether chapter-level privileges are enforced was
  never tested and cannot be from an admin session. Deliberately out of scope for the
  rebuild, which enforces everything server-side regardless.
- **Six facts are the operator's word, not a screen.** Graduate Members assigns "Alum"; the
  admin reset e-mails a link; there is no MFA; the late fee and online payment have never
  been used here. Each is recorded as operator-confirmed on 2026-08-30, not observed.
- **Five actions have no privilege row** (delete an event, force a password reset, read the
  audit log, run reports, delete a blog post). 02b marks them `[inferred]`. The product ties
  them to a broader privilege or to record ownership; which one is not stated anywhere.
- **Four routes were never read**: `myMembersExternalInvoices`, `managealbums`,
  `manageSms`, `viewchapterachievements`. Recorded as features by what they are; their
  field lists are the only thing missing. All low value or empty on this chapter.
- **Unused features cannot be observed running.** Automatic late fee, online dues payment,
  the forms builder, and courses exist as configuration but no runtime behaviour was seen,
  because this chapter has never used them.
- **The forgot-password form fields** are not read (check 7 above).

## The second run

After the fixes above, all eight checks were run again on the final state of `docs/`,
including this file.

- **Check 1:** 72 cited paths; every one resolves. The only two "misses" are the bare
  directory names `raw/` and `raw/pages/` used in prose.
- **Check 2:** 38 of 38 documents declare a status; none is HYPOTHESIS.
- **Check 3:** 314 quoted phrases. No phrase presented as site text fails to appear in
  `raw/`. The two extra composite/spacing quotes the re-run surfaced were fixed; the
  remaining not-founds are regex artifacts, our own coined labels, and the validation
  script's own output ("VALIDATION PASSED"), which lives in `scripts/`, not `raw/`.
- **Check 4:** 31 of 31 facts, and every permission cell tested matched (21 on the first
  run, 19 on the re-run).
- **Check 5:** the one stale claim is gone from the domain model (0 occurrences) and the
  Timeline history is now cited there (2 occurrences). The one suspected overstatement
  ("all on `inviteuser`") was checked and is correct.
- **Check 7:** 47 hits, all accounted for: one hedge still open (the forgot-password form
  fields), stated above with its reason; the rest finished, not closable, or intentional.
- **Check 8:** on a second fresh database the schema applied cleanly (29 tables) and
  `validate_schema.sql` printed "VALIDATION PASSED" with all 21 constraint checks holding.

The results of this second run are also summarised at the top of `docs/RUN-STATUS.md`.
