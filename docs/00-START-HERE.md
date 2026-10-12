# Start here

> Summary: This repository is the full documentation of the APOonline chapter management
> platform, written so a student team (with AI help) can build their own version for one
> chapter. This file explains what every document is, what order to read them in, and
> which parts are confirmed versus still a guess.
> Status: REFERENCE
> Read this first, always.

## What this project is

The students in our Alpha Phi Omega chapter are building their own chapter tracking
system. Before building, we are documenting an existing platform, APOonline, to learn
what a system like this has to do and how its data should be organized.

This repository is documentation only. There is no application code here. The students'
application lives in a separate repository. The one file that crosses over is the
database design, `docs/02-data-model/proposed-schema.sql`.

## The walkthrough has been run

The authenticated walkthrough of the real site was carried out on 2026-08-28 against the
Alpha Delta chapter. It read 45 pages, changed nothing, and rewrote the documentation from
what it saw.

Read `docs/RUN-STATUS.md` first, then `docs/VERIFICATION.md`. RUN-STATUS says what was
found and what still needs a person; VERIFICATION says how the documentation was checked
against the evidence and where it is weak.

Note that `/walkthrough` is described in `README.md` as a command, but no command files
exist in this repository. The run followed the phases by hand. See item 5 under "Needs a
human" in RUN-STATUS.

## How to read these documents with AI

The students will use AI assistants to read this documentation and help them build. If
you are an AI assistant reading this repository, follow these rules:

1. **Check the status line at the top of each document before trusting it.** Every
   document starts with a `Status:` line. It is one of:
   - `HYPOTHESIS`: an educated guess about the existing site, made before anyone logged
     in. It may be wrong. Do not present it as fact.
   - `OBSERVED`: confirmed from captured evidence, with the source cited. Reliable.
   - `DESIGN`: a recommendation for the system the students are building. It is an
     opinion, argued from the evidence, not a fact about any existing site.
   - `REFERENCE`: navigation and definitions, like this file and the glossary.
2. **Prefer OBSERVED over HYPOTHESIS.** Where a hypothesis document and an observed
   document disagree, the observed one is correct and the hypothesis was not yet updated.
3. **Read the Summary line at the top of a document to decide if you need the whole
   thing.** Each document opens with a one or two sentence summary.
4. **Follow the Depends on line** when a document points to others it builds on.
5. **Never treat a DESIGN recommendation as the only option.** These are starting points
   for the students to accept, change, or reject.

## Read in this order

For a person or an AI new to the project:

1. `docs/00-START-HERE.md` (this file)
2. `docs/GLOSSARY.md`: the terms used everywhere else, defined plainly.
3. `docs/05-rebuild-plan/00-feature-inventory.md`: everything the platform does, and
   which parts are worth building for one chapter.
4. `docs/02-data-model/00-domain-model.md`: what the system stores and how it connects.
5. `docs/02-data-model/01-how-the-vendor-differs.md`: the seven places the real site is not
   what we first guessed, and whether to copy it. Read this straight after the domain model.
6. `docs/02-data-model/02-questions-answered.md`: the short version of what the walkthrough
   settled.
7. `docs/04-system-design/01-architecture.md`: how the rebuilt system fits together.
8. `docs/04-system-design/02-auth-and-permissions.md`: account types, positions, who can do
   what, and how an admin changes permissions. The most important system-design document.
   Its companion `02a-privilege-lists.md` holds the complete privilege lists, which are
   also the best feature list of the platform. A second companion,
   `02b-feature-actions-and-permissions.md`, turns the grids around: for each feature, the
   actions on it, the privilege that gates each one, and who holds it on this chapter.
9. `docs/04-system-design/03-flows.md`: the main workflows end to end.
10. `docs/04-system-design/04-infrastructure.md`: where to run it and what it costs.
11. `docs/04-system-design/05-feature-infrastructure.md`: what each feature actually takes
    to build, and which few need machinery beyond a table and a page.
12. `docs/05-rebuild-plan/02-stack.md`: what tools to build it with.
13. `docs/05-rebuild-plan/01-scope.md` and `03-milestones.md`: what to build, in what order.

If you want to know what a particular screen of the existing site does, start at
`docs/01-pages/00-index.md`.

The database design, `docs/02-data-model/proposed-schema.sql`, is the reference the
students build the real database from.

## What is in each folder

| Folder | What it holds | Typical status |
|---|---|---|
| `docs/01-pages/` | One document per page of the existing site, describing what it does. | OBSERVED, filled during the site walkthrough |
| `docs/02-data-model/` | What the system stores: entities, relationships, and a Postgres schema. | OBSERVED |
| `docs/03-api/` | What each form and page request does on the existing site. | OBSERVED |
| `docs/04-system-design/` | How the rebuilt system fits together and where to run it. | DESIGN |
| `docs/05-rebuild-plan/` | What to build, what to build it with, and in what order. | DESIGN |
| `docs/INVENTORY.md` | The list of every page found on the site and its status. | OBSERVED |
| `docs/RUN-STATUS.md` | Live status of the walkthrough. Read this first when checking on a run. | REFERENCE |
| `docs/EVIDENCE-MAP.md` | Each claim next to the raw file that proves it. | REFERENCE |
| `docs/VERIFICATION.md` | The self-audit report: what is backed by evidence, what is not. | REFERENCE |
| `docs/GAPS.md` | Open questions and things still unknown. | REFERENCE |
| `scripts/` | Two small programs that turn saved pages into documentation tables. | tooling |
| `fixtures/` | Fake example data for trying the scripts. Safe to delete later. | tooling |

## The current state of the documentation

The documentation started as a reading of APOonline's public features page. It has since
been checked against the real site with an admin account, and the data model, feature list
and permission model have all been corrected from what was actually seen. Those documents
now say OBSERVED, and every claim in them either cites a file in `raw/` or is labelled
`[inferred]` with the reasoning and a confidence.

Three things are still worth knowing before you rely on any of it:

- **Nothing here proves the real site enforces its own permission rules.** The account used
  was an admin, and an admin is never refused, so this could not be tested.
- **A few claims rest on not having seen something**, which is the weakest kind of
  evidence. They are marked medium confidence and listed in `docs/GAPS.md`.
- **The revised database schema has not been run against a real PostgreSQL.** Do that
  before building on it.

## The two rules that never change

1. **The walkthrough never changes anything on the real site.** The account used has
   admin access, so it could change or delete real data. It does not. It reads and
   describes only. See Rule 1 in `CLAUDE.md`.
2. **No student application code goes in this repository.** This is documentation. The
   application is built elsewhere.
