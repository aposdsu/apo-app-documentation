# What to build it with

> Summary: The tools to build the rebuilt system with, and the four decisions that
> matter more than the tools.
> Status: DESIGN (a recommendation, not a fact about the existing site)
> Read this if: you are setting up the project or choosing libraries.
> Depends on: docs/04-system-design/01-architecture.md

The chapter chose React and Next.js. This document fills in the rest and explains the
choices that matter more than the tools.

## Recommended tools

| Layer | Choice | Why |
|---|---|---|
| Framework | Next.js with TypeScript | This app is mostly forms and tables over a database. Next.js can render those on the server, so most pages need very little JavaScript in the browser. |
| Database | PostgreSQL | The design uses rules the database enforces itself, which catches bad data early. Free hosted options are fine at chapter size, such as Neon or Supabase. |
| Database access | Drizzle | You write something close to real SQL, so students learn SQL rather than hiding from it. Prisma is the alternative and explains less of what it is doing. |
| Schema changes | Drizzle Kit migrations | A migration is a recorded change to the database structure. Keep every one, and never edit one after it has run. |
| Login | Auth.js, with university or email sign-in | Do not write your own login system. Getting passwords and sessions right is harder than it looks and there is no credit for it. |
| Input checking | Zod | Write the rules for a form once, and use them both in the browser and on the server. |
| Styling | Tailwind | Fastest option for a team not doing visual design. |
| Hosting | Vercel plus hosted Postgres | Free tiers are enough for one chapter. |

## Four decisions that matter more than the tools

### Check permissions on the server, every single time

The permission rules are stored as data: positions hold privileges, and members hold
positions each term. So it is easy to check a permission in the page and hide a button
that the member is not allowed to use.

Hiding a button is not security. Anyone can send the request anyway.

Every action that changes data must check the acting member's permissions on the server
before it writes anything. Write one helper function that does this check, and make it
the first line of every action.

This is the most common real security hole in applications shaped like this one, and it
is worth showing students exactly how it happens.

### Put the term in the URL

Nearly every page is about one term. Make that visible, for example
`/fall-2026/roster`. It means a link always shows the same thing to whoever opens it,
and it saves you from tracking the current term in a hidden global setting.

### Calculate progress when the page loads

Do not store each member's total hours in a column and try to keep it updated. That
column will drift out of date the first time a credit is deleted.

Add up the credits when the page loads. With a hundred members and a few thousand
credits, this is fast. If it ever becomes slow, measure it first, then fix it. Students
should see a query they assumed was slow return in a few milliseconds.

### Keep it to one application and one database

Two things running is more than twice the work of one. No separate API service, no
message queues, no containers to orchestrate.

## Things to leave out

- **Taking payments.** Record who paid. Collect the money the way the chapter already
  does. Handling cards brings security requirements that are not a student project.
- **A phone app.** Make the website work well on a phone instead.
- **Live updating pages.** Nothing here changes second by second.
- **Extra services and infrastructure.** Adding pieces is the most common reason student
  projects never finish.

## What finished looks like for version one

Terms, members, membership by term, officer positions and privileges, events, attendance,
requirements, credits, and one page showing progress.

Deploy it and have real officers use it before building anything else.
