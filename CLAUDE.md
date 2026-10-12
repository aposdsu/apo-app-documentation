# Site analysis project

We are reverse-documenting a web platform used by an Alpha Phi Omega chapter, so that
students can study its architecture and build their own implementation as a learning
exercise. We are documenting, not building. No application code gets written in this
repo except throwaway analysis scripts under `scripts/`.

Access is through an already-authenticated Chrome session driven by the Claude in Chrome
extension. There is no standalone API token, so every observation comes from the browser.

## Rule 1: never change anything on the site

This session has admin access. That means almost every button on the site can change
real data for real people. You are here to read and describe the site. You never change
it.

**Never do any of these:**

- Click a button that saves, submits, deletes, removes, archives, approves, denies,
  sends, emails, publishes, cancels, imports, syncs, resets, revokes, merges, or
  confirms anything.
- Submit a form. Not even a search form you think is safe. Not even to see what happens.
- Submit a form with its existing values unchanged. "Saving without changes" still
  writes to the database, still updates timestamps, and still shows up in their audit log.
- Use `javascript_tool` to call `fetch`, `XMLHttpRequest`, `form.submit()`, `.click()`,
  or `.dispatchEvent()`. You may only use it to read: `document.documentElement.outerHTML`,
  `querySelector`, and reading properties. If a line of JavaScript could send a request,
  do not run it.
- Visit a URL that performs an action. Some sites do work on a GET request, for example
  `delete.php?id=5` or `approve.php?credit=9`. If a link looks like it performs an
  action, do not open it. Write down the URL instead.
- Test whether something is safe by trying it.

**There is no undo.** You cannot check whether a change was permanent by making it.
If you are unsure whether a control is safe, it is not safe. Skip it and write it down.

**The one exception: logging in.** You may submit the site's login form, and its
verification-code step, because logging in identifies you to the site. It does not change
any chapter data. This exception covers the login form and nothing else. Once you are in,
Rule 1 applies to everything without exception. See the login runbook below.

## How to document a write operation without performing it

You still need to know what the site's write operations do, because that is where the
data model shows itself. You work this out by reading, not by clicking.

For each form, record:

1. **The target.** The form's `action` URL and its `method` (GET or POST).
2. **Every field.** Its `name`, input type, whether it is required, its `maxlength`, and
   for dropdowns, every option value and label.
3. **Hidden fields.** These usually carry the record's ID and sometimes the name of the
   operation, for example `action=update`. Record the field names. Replace any value
   that looks like a token or session key with `<redacted>`.
4. **The button text.** "Save Changes" and "Delete Member" tell you what the form does.
5. **Any confirmation text.** A warning like "This cannot be undone" tells you the
   operation is destructive and what it affects.
6. **The starting values.** What is already filled in tells you what the record holds now.

Then write your prediction in `docs/03-api/write-operations.md`, using this shape:

```markdown
### Update a member's profile

- Where: member_edit.php
- Sends: POST to member_save.php
- Fields sent: member_id (hidden), first_name, last_name, email, phone,
  pledge_class, status_id, notes
- Predicted effect: updates one existing member record. member_id identifies which one.
- Probably writes to: the member record, and possibly the membership record for the
  current term, because status_id looks term-specific.
- Confidence: high. The field names map directly onto the profile page's display.
- Not verified: we did not submit this form, and we will not.
```

Every entry in that file is a prediction. Label it that way. Never write it as a
confirmed fact, and never write "tested" or "verified" about a write operation, because
you did not test it and will not.

Where two predictions conflict, or where you cannot tell whether a form creates a new
record or updates an existing one, say so and add it to `docs/GAPS.md`. An honest
"unclear" is worth more than a confident guess, because a student will build from this.

## Running without a human: decisions already made

This walkthrough runs unattended. Nobody will answer questions while it runs. Every
decision you might otherwise stop to ask about is already made below. Do not stop to ask.

Two standing rules for the whole run:

1. **Never stop the entire run because of a problem on one page.** Skip that page, write
   why in `docs/RUN-STATUS.md`, and continue with everything else.
2. **When something is genuinely undecidable or unsafe, do the safe part, write the open
   question into `docs/RUN-STATUS.md` under "Needs a human", and move on.** A returning
   human reads that file. It is how you "ask" without stopping.

### The decisions

| Situation | What to do |
|---|---|
| Not sure whether a form creates a new record or edits an existing one | Record both possibilities as a prediction in `docs/03-api/write-operations.md`, add a line to GAPS, move on. Do not submit it to find out. |
| A control might be destructive and you cannot tell | Treat it as destructive. Do not touch it. Record it. |
| A link looks like it performs an action (`delete.php?id=`, `approve.php?`) | Do not open it. Write the URL into `docs/03-api/write-operations.md` as a predicted action. |
| A page will not load or times out | Retry once. If it still fails, skip it, record it, continue. Do not loop. |
| A browser tool errors two or three times in a row | Stop that one page, record it, continue elsewhere. Do not keep retrying the same failing action. |
| A list has many pages | Capture the first two pages and the last page. That shows the pagination pattern. Do not crawl all of them. |
| A route has an id in it (`/member/:id`) | Capture two or three real examples that look different from each other, for instance a full record and a sparse one. Not all of them. |
| A response or page shows real member data (names, emails, phones, addresses, student ids) | Keep the structure, replace the values with placeholders, as the capture rules require. Never let real personal data reach `raw/` or `docs/`. |
| Two captures disagree | Record both, cite both files, do not resolve by guessing. Add to GAPS. |
| The site is not the PHP app we assumed (it is a JavaScript app with an API, or it changed) | Follow the evidence using the signal priority rules. Note the difference in `docs/RUN-STATUS.md`. Do not stop. |
| You found a JSON API | Capture its responses, they are richer than HTML. Note it prominently in RUN-STATUS. Keep going. |
| A "view as" or impersonation feature exists | Do not use it. Record that it exists and what it could establish. |
| You think you are done | Check against the "Done when" list at the end of this section before stopping. |
| Anything else you would want to ask a human | Do the safe, reversible part now. Write the question into RUN-STATUS under "Needs a human". Continue. |

### Login runbook

Do this once at the start, and again if the session drops mid-run.

1. **Check if you are already logged in first.** Open an authenticated page (the
   dashboard or roster). If it loads, you are in. Skip the rest of this runbook.
2. **If it sends you to a login page, get the credentials from the credential source**
   (the 1Password connector, or a credential autofill tool, whichever this session has).
   Search it for "apoonline" or the site domain. Choose the item whose website matches
   `www.apoonline.org`. If more than one matches, prefer the one labeled admin.
3. **Fill and submit the login form** using the browser extension. This form submission
   is the one Rule 1 allows. Type credentials only into the site's own login form, never
   anywhere else.
4. **If a second factor is requested:**
   - If the credential source can supply a one-time code (a TOTP stored alongside the
     login), retrieve it and enter it.
   - If it needs a code texted to a phone, or a push you cannot reach, you cannot finish
     login unattended. Write this into `docs/RUN-STATUS.md` under "Needs a human" and
     stop. Do not guess codes.
5. **If login fails, try at most twice more, then stop and record it.** Repeated failures
   can lock the account. Do not keep trying.

**Never write a password, one-time code, session cookie, or token into any file**, in
`raw/`, in `docs/`, or anywhere else. If one appears in captured output, replace it with
`<redacted>`.

### The run log

Keep `docs/RUN-STATUS.md` current as you go. It is the first thing the returning human
reads. It has four parts:

- **Progress:** which phases are done, which page you are on.
- **Done:** a short count of what was captured (pages, forms, admin surfaces).
- **Needs a human:** every question or blocker you hit, each with enough detail to act on.
- **Confidence:** which documents you would trust, and which are thin.

Commit after each phase with git, so the human can see the run's history.

### Done when

Stop only when all of these are true. Then write a final summary into RUN-STATUS.

- Every route in `docs/INVENTORY.md` is captured, or recorded as unreachable with a
  reason.
- Every admin surface in the admin-sweep list is captured or recorded as absent.
- The eight open questions in `docs/02-data-model/00-domain-model.md` are each answered
  or recorded as unanswerable, with evidence.
- The data-model and feature documents have been updated from HYPOTHESIS to OBSERVED
  where evidence confirms them, with corrections where it does not.
- `docs/03-api/write-operations.md` has a prediction for every form found.
- `/verify` has run to completion, `docs/VERIFICATION.md` exists, and its final pass
  found no fabricated or unsupported claim.
- `docs/EVIDENCE-MAP.md` has a row for every entity and every non-obvious claim.
- RUN-STATUS lists what a human should look at, honestly, with nothing softened.

## The one rule that matters: collection never analyzes

Work happens in two separate passes, and mixing them ruins the result.

**Pass 1 (collection)** writes only to `raw/`. It captures page text, network traffic,
screenshots, and JS bundles verbatim. It draws no conclusions, names no entities, and
writes nothing to `docs/`. If it starts theorizing about the data model, it will stop
capturing the evidence that contradicts the theory.

**Pass 2 (analysis)** reads only from `raw/` and writes only to `docs/`. It never opens
a browser. If it wants a fact that isn't in `raw/`, it records the gap in
`docs/GAPS.md` and moves on. A later collection pass fills the gap.

`raw/` is append-only. Never edit, clean, summarize, or delete a captured file.
If a capture is wrong, capture again to a new filename and note it.

## Directory layout

```
raw/pages/<slug>.md          page text, headings, forms, links, verbatim
raw/network/<slug>/*.json    one file per observed request/response pair
raw/screenshots/<slug>.png   full-page screenshot
raw/bundles/                 JS bundles, source maps, sitemap.xml, robots.txt
docs/INVENTORY.md         the URL frontier and crawl status table
docs/01-pages/<slug>.md      one write-up per page
docs/02-data-model/          entities, relationships, ERD
docs/03-api/                 endpoint catalog and inferred contracts
docs/04-system-design/       architecture, auth model, permissions, integrations
docs/05-rebuild-plan/        what a clean-room reimplementation would need
docs/GAPS.md                 open questions and unreached pages
scripts/                     analysis helpers
```

Slugs are the URL path with `/` replaced by `_`, query string dropped, leading and
trailing underscores stripped. `/events/123/attendance` becomes `events_123_attendance`.
Root is `home`.

## The target is a server-rendered PHP app

APOonline (powered by GreekTrack) serves `.php` URLs and appears to be a classic
server-rendered application, not a single-page app. Confirm this in `/recon` before
trusting it, but plan for it: there is likely **no JSON API, no XHR traffic worth
reading, and no source maps**. The usual reverse-engineering playbook of watching the
network tab does not apply.

That inverts the signal ranking. Evidence, best first:

1. **Forms.** Field `name` attributes are close to literal column names in a PHP app,
   often exactly. Required flags, `maxlength`, input types, and `<select>` options give
   you types, lengths, and enums. Capture every form's full markup. This is now the
   single best source of schema.
2. **Query strings.** `?id=`, `?term=`, `?status=`, `?sort=` name the filter and sort
   vocabulary, and often the columns behind them.
3. **Form action targets and hidden inputs.** The `action` URL plus hidden fields reveal
   the write operations and how records are addressed.
4. **HTML table structure.** Column headers on list pages are usually a direct projection
   of a query. Header text plus cell formatting gives you fields and types.
5. **Page-to-page links.** The URL patterns are the entity graph. `member.php?id=`
   linking to `credits.php?member_id=` tells you the relationship.
6. **Prose and labels.** Lowest signal, but the terminology matters: use the chapter's
   own words for entities in the final docs.

If `/recon` finds this is actually a JS app with an API after all, tell the user
immediately and switch to reading response payloads instead; that would be a much
richer source and worth reworking the plan for.

## Goal: a base to build on, not a clone

The students are building their own single-chapter system in React/Next.js with a
Postgres database. They do not want the vendor's UI, its markup, its styling, or its
feature set wholesale. They want to understand what a chapter management system has to
model and why.

So the output is a **specification and data model**, not a reproduction. Concretely:
- Capture *structure*: entities, fields, types, relationships, rules, workflows.
- Do not capture *presentation*: no CSS, no page layout, no copy, no markup for its
  own sake, no screenshots used as design reference.
- When a feature exists in the vendor's product but a single chapter wouldn't need it,
  say so and recommend dropping it. Scope reduction is a deliverable here.
- Where the vendor's design looks like a workaround for multi-tenancy or for PHP-era
  constraints, note that a modern single-tenant build can do it more simply.

`docs/02-data-model/00-domain-model.md` and `docs/05-rebuild-plan/00-feature-inventory.md`
already contain a hypothesis built from public marketing copy. Your job in the
authenticated walkthrough is to **confirm, correct, and fill in** that hypothesis, not
to start from scratch. The open questions at the end of both files are the agenda.

## The session is an admin account

Beyond the safety rules above, admin access changes what you can learn.

**What it gains.** Every page is reachable, admin-only pages are in scope, and admin
pages usually show fields that ordinary members never see, such as internal notes,
timestamps, and who created a record. These give you the fullest picture of the data.

**What it costs.** You cannot learn who is allowed to do what by being blocked, because
you never will be. An admin sees everything, so "I could reach this page" tells you
nothing about whether a regular member could.

So work out permissions by reading the site's own settings, not by testing access:

- The officer positions and privileges settings page usually lists every position and
  every privilege, with checkboxes showing which position gets which. That page is the
  permission model. It is the most valuable page on the whole site.
- Any page that lists what a role can do, in words.

Never assume a regular member can do something just because you could. Every claim about
permissions is `[inferred]` unless a settings page states it, and the write-up says which.

If the site has a "view as" or "log in as" feature, do not use it. It is a good way to
map roles, but it acts as another person and appears in the audit log under their name.
Note that it exists, explain what it could establish, and let the user decide.

## Capture conventions

- Every network capture file records: method, full URL, status, request headers
  (redact `Authorization` and `Cookie` to `<redacted>`), request body, response body,
  and the page slug it was observed on.
- Never write credentials, session cookies, bearer tokens, or personal data of real
  members into `raw/` or `docs/`. When a response contains real member records, keep
  the field structure and replace values with type-appropriate placeholders. We want
  the schema, not the roster.
- Record HTTP status codes for pages that 403 or 404 under the current role. Role-gating
  is part of the system design and the absence is data.

## Analysis conventions

- Mark every claim `[observed]` (you saw it, and you cite the raw file) or `[inferred]`
  (you worked it out, and you say how). Never let a guess turn into a stated fact.
- A field's type comes from every page you saw it on, not from one page.
- Describe what something does, not how you think it is built. "Records how many service
  hours a member earned at an event" is useful. "Uses a database trigger" is a guess.

## Evidence discipline: you must be able to defend every claim

The person reading this is going to interrogate it like a staff engineer reviewing a
reverse-engineering effort. Assume they will point at any sentence and ask "how do you
know that?" You must have an answer that is either a file they can open or a chain of
reasoning they can follow. Nothing is asserted because it sounds right.

Concretely:

- **Every `[observed]` claim cites at least one raw file, by path.** Not "the roster page
  shows this" but "`raw/pages/roster.html`, the status column". If you cannot point to
  the file, the claim is not observed. Downgrade it to `[inferred]` or delete it.
- **Every `[inferred]` claim states the reasoning and a confidence.** "The `status_id`
  field is per-term `[inferred]`, confidence medium, because it appears on the membership
  edit form rather than the member profile form, and the profile form has no status
  field." A reader can agree or disagree with that reasoning. That is the point.
- **Never invent a field, a value, an endpoint, a table, or a behavior.** If the site
  did not show it and you did not reason your way to it from something the site showed,
  it does not go in the documentation. A missing field is fine. A made-up field is a
  defect that a student will build on.
- **Confidence is calibrated, not decorative.** High means the evidence is direct and you
  saw it more than once. Medium means one piece of evidence, or a solid inference. Low
  means a guess you are recording so it is not lost. Do not mark things high to look
  finished.
- **When you are not sure, say so in the document itself,** not just in your head. "It is
  unclear whether meetings are a separate entity or an event with a kind. See GAPS."
- **Build the evidence map as you go.** `docs/EVIDENCE-MAP.md` lists each entity and each
  non-obvious claim next to the raw file or files that back it. This is the index that
  lets the reader check any claim in seconds, and it is what makes a self-audit possible.
  If a claim has no row in the evidence map, it is not finished.

## Every document starts with a summary block

The students read these with AI assistants, so every document must open, right under its
title, with a block that lets a reader or an AI decide what it is without reading it all:

```
> Summary: one or two sentences on what this document contains.
> Status: HYPOTHESIS | OBSERVED | DESIGN | REFERENCE
> Read this if: who should read it and why.
> Depends on: other/paths.md (only if it builds on other documents)
```

The status word means:

- HYPOTHESIS: a guess about the existing site made before or without direct evidence.
  May be wrong. Anything built from the public features page is HYPOTHESIS until the
  walkthrough confirms it.
- OBSERVED: confirmed from a captured page, with the raw file cited. When a walkthrough
  confirms a hypothesis document, change its status to OBSERVED and cite the evidence.
- DESIGN: a recommendation for the system the students are building. An argued opinion,
  not a fact about any existing site.
- REFERENCE: navigation or definitions.

`docs/00-START-HERE.md` explains this to readers. Keep it accurate as documents change.


## How to write the documentation

Students read these documents, not senior engineers. Some are in their first
programming course. Write so they can follow it without looking things up.

**Rules:**

- Short sentences. One idea each.
- Plain words. Write "join table" once, then explain it in a sentence, then use it.
- No idioms, no figures of speech, no jokes. "The heart of the system", "falls out for
  free", "contact with reality", and "crown jewel" all mean nothing to a reader who is
  translating as they go. Write "the most important table" instead.
- No em dashes. Use a comma, a period, or parentheses.
- Define every technical term the first time it appears. Foreign key, join table,
  normalization, index, constraint, migration. One sentence each is enough.
- Say why, not just what. "Store the member's status per term, because a member can be
  active one semester and abroad the next" teaches. "status_id references
  membership_status" does not.
- Lead with the point. Put the conclusion in the first sentence of a section.
- Use tables for lists of fields, and short paragraphs for reasoning.
- Keep each document under roughly two pages. If it grows past that, split it.

**Check your work by asking:** could a second-year student read this section once and
explain it to someone else? If not, it is too dense or too clever.


## Model and effort

- Collection passes: Sonnet, low to medium effort. It's transcription.
- Per-page write-ups: Sonnet, medium.
- Schema inference, system design, rebuild plan: Opus, high.
- Gap check and contradiction review: Opus, high.

Fan out collection with subagents, one per branch of the site. Do not fan out synthesis;
the data model has to be reasoned about as a whole or the entities won't line up.

## Scope

Document architecture, schema, page purpose, permissions, and flows. Do not copy the
platform's content, page copy, branding, or member data into the docs or into any
future implementation. The deliverable is a specification someone could build from
independently.
