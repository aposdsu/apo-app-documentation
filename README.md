# APO platform analysis

Documentation-only reverse-engineering of a chapter web platform, for students to study
and reimplement.

## What's already here, before you crawl anything

Built from the vendor's **public** features page, no authenticated access involved:

- `docs/05-rebuild-plan/00-feature-inventory.md`, every feature, tagged CORE / LATER / SKIP for a single-chapter build
- `docs/02-data-model/00-domain-model.md`, entity hypothesis, an ERD, and 8 open questions to take into the walkthrough
- `docs/02-data-model/proposed-schema.sql`, a Postgres schema. Revised after the
  walkthrough and re-tested on PostgreSQL 16.15: it applies clean, and
  `scripts/validate_schema.sql` checks both views and twenty constraints against seeded
  data.
- `docs/05-rebuild-plan/02-stack.md`, Next.js stack and the decisions that matter more than the stack

The authenticated walkthrough exists to **confirm and correct** that hypothesis. It was
run on 2026-08-28; start at `docs/RUN-STATUS.md` for what it found and
`docs/VERIFICATION.md` for how far to trust it.

## Scripts

- `scripts/extract_structure.py raw/pages`, form fields, enums, table headers, query params from saved HTML. Primary tool for this target.
- `scripts/infer_schema.py raw/network`, field types from JSON payloads. Only useful if a JSON API turns up. (The walkthrough found no JSON API, so this one has nothing to chew on.)
- `scripts/validate_schema.sql`, applies the proposed schema to a scratch database and asserts that its views and constraints behave.

Both are stdlib-only and take `--out` and `--format json`.

## Setup

1. Put this folder somewhere local and `git init` it. The git history is how you'll see
   what a re-crawl changed.
2. Open Chrome, sign in to the platform manually, and leave that tab open. The agent
   works inside your authenticated session; do not hand it credentials.
3. Install the Claude in Chrome extension and grant it access to the platform's domain.
4. Run `claude` from this folder.

## Note on the commands below

The slash commands listed here are a description of the phases, not files that exist in
this repository. There is no `.claude/commands/` directory. The authenticated walkthrough
of 2026-08-28 followed these phases by hand. Either write the command files or rewrite
this section; see item 5 under "Needs a human" in `docs/RUN-STATUS.md`.

## Order of operations

```
/recon            once. Finds source maps, sitemap, router config, auth mechanism.
/admin-sweep      once, early. The admin-only surfaces. Highest yield per page.
/crawl            once, then re-run to extend. Builds the URL frontier.
/capture <slug>   many times. One page per invocation. Sonnet.
/infer-schema     after capture is broadly done. Opus.
/document-pages   after capture. Sonnet, fan out.
/system-design    after infer-schema. Opus.
/gap-check        last, and again after filling gaps. Opus.
```

`/recon` first is not optional. If the platform ships source maps, it changes the
entire plan and saves you most of the crawl.

`/admin-sweep` second, before the bulk crawl. The account is an admin, and the
admin-only surfaces (role grid, import templates, exports, audit log, settings) define
the schema and the business rules. What you find there tells the rest of the crawl what
to look for.

## The account is an admin. Read CLAUDE.md before running anything.

Two things follow from that.

**Nothing on the site gets changed.** The AI reads and describes. It never submits a
form, clicks a save or delete button, or runs JavaScript that could send a request. It
cannot test whether a change would be permanent, so it does not try. Instead it reads
each form and writes down what that form would do, as a prediction, in
`docs/03-api/write-operations.md`. Rule 1 in CLAUDE.md spells this out.

**Permissions have to be read, not tested.** An admin is never blocked, so reaching a
page proves nothing about who else can reach it. The permission model comes from the
site's own officer and privilege settings page instead.

## No application code lives here

This repo holds documentation, plus two small scripts that read your saved pages and
turn them into documentation tables. The students' Next.js application belongs in its own
separate repo. The only file that crosses over is `proposed-schema.sql`.

## Commit after every phase

`git add -A && git commit -m "capture: events pages"`. When you re-crawl in a month,
the diff tells you what the platform changed.
