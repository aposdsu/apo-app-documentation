# Corrections to earlier captures

`raw/` is append-only. When a capture turns out to be imprecise, the correction is written
here rather than by editing the original file.

## 2026-08-28

- `raw/pages/memberhome_action-viewevents.md` says "45 events were listed". That figure
  was counted by eye from the page text at capture time and was not re-checked against the
  DOM. Treat it as approximate. Nothing in `docs/` depends on it.

- `raw/pages/memberhome_action-managerecords_reqid-3.md` says the progress table had
  "39 rows". That is the DOM row count, which includes the header row, so it is 38 member
  rows. Nothing in `docs/` depends on it.

- `raw/pages/memberhome_action-defineofficers.md` records 26 officer rows on a chapter that
  has 18 officer positions and 1 advisor position. The reason for the extra rows was not
  established. It is recorded as an open question in `docs/GAPS.md`.

## 2026-08-29, completeness pass

- `raw/pages/memberhome_action-managebrother_panel-account.md` says "The three visibility
  words seen next to fields are 'Anyone', 'Officers' and 'Hidden (Staff Only)'." That was
  what the officer's view of another member showed. The member's own editor
  (`?action=editprofile`) shows **five**: "Anyone", "Anyone + Staff",
  "Alpha Delta Only + Staff", "Officers", "Hidden (Staff Only)". The full list and the
  per-field assignments are in `raw/pages/completeness-pass.md`. Documents in `docs/` have
  been corrected.

## 2026-08-29, partials closed

`raw/` is append-only, so the five captures below still contain the sentences that admit
they were incomplete. Each is now finished in `raw/pages/partials-closed.md`. Read that file
alongside the original.

| Original capture | What was incomplete | Where it is finished |
|---|---|---|
| memberhome_action-editofficerpositions.md | the officerid list ("this id list is partial") | partials-closed.md section 1, all 19 positions |
| memberhome_action-editrequirement_reqid-3.md | goals for statusid 339, 5, 6, 7 ("not read") | partials-closed.md section 2, all 14 account types |
| memberhome_action-eventcreate.md | the ridebonus/coorbonus requirement options ("list continues") | partials-closed.md section 3, all 19 options |
| memberhome_action-managebrother_panel-account.md | FORM4 ("was not read in detail") | partials-closed.md section 4, the work experience form |
| memberhome_action-viewtransactions.md | the footer line ("truncated") | partials-closed.md section 5 |
| memberhome_misc-surfaces.md | the notification list ("continued past the captured slice") | partials-closed.md section 6 |
| memberhome_action-whatsNew.md | the whole page ("sampled rather than transcribed in full") | whatsNew-full-read.md |

Also for the record: `?action=vieweventcalendar_nation` is captured in
`raw/pages/completeness-pass.md` under the shared heading
"`?action=vieweventcalendar_region` and `_nation`". A route-coverage script that matches on
`action=<verb>` will not see it there. It is not an uncaptured route.

## 2026-09-03, verification pass: hedges finished

A grep of `raw/pages/` for "sampled|truncated|partial|not read|list continues" (check 7
of `/verify`) found 40 hits. All but four were already finished by `partials-closed.md`,
`whatsNew-full-read.md` or `viewstorage_tier-chart.md`. Of the four:

- `whatsNew-full-read.md:92`, the entry "Events can now disable signups. This is useful
  for adding key dates or deadlin..." (truncated) — **finished**. Read live on the
  What's New page: "Events can now disable signups. This is useful for adding key dates
  or deadlines to the calendar." The cut-off word was "deadlines".
- `award-and-password-flows.md:51`, the forgot-password form fields "not read" —
  **still open**. Reading that form needs a logged-out session (it is on the login form
  memberhome.php shows when signed out); the session was signed in during this pass, and
  the public `login.php` returns a 500 Internal Server Error (seen twice). Low value: it
  is a standard enter-your-e-mail reset form. Submitting it would send a reset e-mail, so
  it must only ever be read, never submitted.
- `self-flows-observed.md:175`, the invoice "Actions" column marked partial — **not
  closable**: this chapter has no invoices, so no per-invoice action was ever rendered.
- `full-read-pass-2.md:68`, the `viewMembershipStages` list "truncated" — **intentional**:
  the truncated part is the list of member names, which is personal data and is
  deliberately never recorded. The stage structure itself was read in full
  (`gap-resolution-2.md`).
