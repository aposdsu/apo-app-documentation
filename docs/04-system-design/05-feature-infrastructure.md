# What each feature actually takes to build

> Summary: Most features on this platform are a table and a page. A handful are not: they
> need something running outside the request, a place to put files, or a third party. This
> separates the two, so nobody plans a semester around a feature that turns out to need a
> payment processor.
> Status: OBSERVED (what the platform does) and DESIGN (what it would take you to build it)
> Read this if: you are planning what to build when, or estimating a feature.
> Depends on: docs/05-rebuild-plan/00-feature-inventory.md, docs/04-system-design/04-infrastructure.md

## The one distinction that matters

**A request-time feature** happens while someone is waiting for a page. A form is
submitted, rows are written, a page comes back. Almost everything is this. It needs a
database and nothing else.

**A background feature** happens when nobody is waiting. An e-mail goes out on Sunday
morning. A reminder fires two days before an event. A payment settles five days after
someone clicked pay. These need something that runs on its own schedule, and that is a
genuinely different piece of machinery from a web page.

Students consistently underestimate the second kind. The rule of thumb: if the feature has
a *when* in its description that is not "now", it is a background feature.

## Feature by feature

`[observed]` columns describe what the real platform does, cited below the table.
`[design]` columns are what building it would cost you.

| Feature | What it needs beyond a table and a page | Verdict |
|---|---|---|
| Members, roster, account types | nothing | CORE |
| Officer positions and both privilege grids | nothing | CORE |
| Requirements, goals, categories | nothing | CORE |
| Events, sign-ups, attendance | nothing | CORE |
| Completing an event and awarding credit | nothing, but it must be idempotent | CORE |
| Manual credit entry | nothing | CORE |
| Progress pages and reports | nothing, until they get slow | CORE |
| CSV export of a report | a CSV writer, about 20 lines | CORE |
| Audit log | nothing; write the row in the same transaction | CORE |
| Approval queue for registrations | nothing | CORE |
| **Recurring events** | a decision, not a service: materialise the occurrences | LATER |
| **Waitlist on a full event** | nothing extra, but a promotion rule and a notification | LATER |
| **Event location on a map** | a geocoding API key | SKIP |
| **Add to Google Calendar** | an `.ics` generator, no service | LATER |
| **Timezone handling** | no service, but real care. See below. | CORE |
| **CSV import of members** | a parser and a preview-then-commit flow | LATER |
| **File uploads of any kind** | object storage, plus access control on every file | LATER |
| **Profile photos** | object storage plus image resizing | LATER |
| **Photo albums, blog images, form header images, event attachments** | the same object storage | SKIP |
| **Any outgoing e-mail** | a delivery service, a queue, and a bounce/unsubscribe story | LATER |
| **Scheduled reminders and the weekly digest** | a scheduler calling your app | LATER |
| **Data/e-mail automation on a trigger** | a scheduler plus a rules engine | SKIP |
| **SMS** | a paid provider; there is no free tier worth using, and messages are capped at one segment | SKIP |
| **Online dues payment** | a payment processor, webhooks, and reconciliation | SKIP |
| **Invoices, payment plans, refunds** | all of the above plus a ledger you can defend | SKIP |
| **Courses and quizzes** | nothing exotic, but a lot of tables and screens | SKIP |
| **Public chapter website** | a second, unauthenticated rendering path, plus a page/theme editor | SKIP |
| **Scheduled publishing** (blog posts with a future publish date) | a scheduler, or a "publish_at <= now" filter on every read | SKIP |
| **Retention rules** (event attachments deleted after six months) | a recurring cleanup job | SKIP |
| **Leaderboards across chapters** | multi-tenancy, which you are deliberately not building | SKIP |

## The four pieces of machinery worth understanding

### 1. Something that runs on a schedule

The moment you build the weekly digest, the event reminder, or anything that happens
without a person clicking, you need a scheduler: a service that calls a URL in your app at
a set time, and your app decides what to do. `docs/04-system-design/04-infrastructure.md`
recommends Upstash QStash for this, and it is free at your size.

`[observed]` The real platform clearly has one. Its notification settings offer "each
Sunday showing all upcoming events" and a reminder "when an event I am attending
approaches" with twelve choices from "1 hour before" to "1 week before"
(`raw/pages/memberhome_misc-surfaces.md`). Its release notes mention reminder e-mails being
"auto-rescheduled" when a date moves, and a whole "Data/Email Automation" feature that
fires "on their birthday or after they submit a form"
(`raw/pages/memberhome_action-whatsNew.md`).

That last detail is the one to learn from: **when the thing a reminder points at moves, the
reminder has to move too.** A scheduled job that stores "send at 6pm Thursday" and never
re-checks the event will happily e-mail everyone about an event that was cancelled. Store
the reminder as a rule against the event, not as a fixed timestamp.

One more thing the scheduler has to carry: `[observed]` "Ability to schedule bulk emails to
be sent in the future" (`raw/pages/whatsNew-full-read.md`). So the same machinery serves
reminders, automation and deferred sends. Build it once.

### A design problem worth thinking about before you meet it

`[observed]` The platform offers "Anonymous forms ... ensuring only a single submission per
person but yet anonymous" (`raw/pages/whatsNew-full-read.md`).

`[design]` Those two requirements pull against each other: the obvious way to stop a second
submission is to record who submitted. The usual answer is to keep two tables, one recording
*that* a member submitted (member id, form id, no answers) and one recording the answers
with no member id. Neither table alone identifies anyone's answers. Worth knowing before a
chapter asks for an anonymous vote, which they will.

### 2. Somewhere to put files

Files do not belong in a database and they do not belong on the web server's disk, because
on a platform like Vercel that disk disappears between requests. They belong in object
storage, such as Cloudflare R2 or Vercel Blob.

The part students miss is not the storage, it is the **access control**. Every file needs an
answer to "who may fetch this URL?", and the answer cannot be "whoever guesses it".

`[observed]` The file manager was gated behind the top subscription tier until the chapter
upgraded. With it unlocked, every upload carries one of three audiences, verbatim:
"Officers & Advisors Only", "Initiated Members", "Non-Initiated and Initiated Members"
(`raw/pages/diamond-tier-sweep.md`). There is also a second form that stores a *link* to a
file held elsewhere, with the same three audiences. Profile photos are separate again,
stored as "Media" records with their own ids in the audit log
(`raw/pages/memberhome_action-viewlog.md`).

So the product treats a file as a record with an audience, not as a path, and it treats
"a file we host" and "a file we point at" as the same kind of record. That is a good model
to copy: one `attachment` table with an owner, an audience, and either a storage key or an
external URL.

Note also that photo albums have a two-step flow: a member with the upload privilege adds
photos, and an officer with "Post and Approve Photo Album Images" approves the album before
it is public (`raw/pages/diamond-tier-sweep.md`). Anything members can put in front of the
public needs a review step, and that is a database column and a screen, not a service.

`[design]` Skip files entirely in version one. When you do add them, add profile photos
first, because one small image per member is the easiest version of the problem.

### 3. Sending e-mail

Sending one e-mail is easy. Running e-mail is not. What the real platform's release notes
reveal about the parts nobody plans for:

- **A queue with statuses.** "Sent emails now shows a summary of the queue status codes to
  better visualize the result of the email send."
- **Tracking, and an exemption from it.** "Test emails are not tracked" implies the normal
  ones are.
- **Per-scope unsubscribe.** "opt-in/out from emails for each of your affiliations
  separately", and a bug fix making an unsubscribe apply "to the entire system instead of
  only one level".
- **Merge tags.** `{{first-name}}`, `{{president-email}}`.
- **Audience building.** Filtering "on any member field", plus "Saved Audiences".

(all from `raw/pages/memberhome_action-whatsNew.md`)

`[observed]` The audience model is the same for e-mail and SMS: a core filter (everyone, or
the attendees of one named event) intersected with a set of account types
(`raw/pages/diamond-tier-sweep.md`, `raw/pages/memberhome_misc-surfaces.md`). That is a
small, copyable design: two inputs, not a query builder.

`[design]` For one chapter, build the audience picker and hand the actual sending to Resend
or Postmark. The valuable, chapter-specific part is choosing who to send to. The delivery,
bounce handling and unsubscribe plumbing is a solved problem you should rent.

One rule regardless: **an unsubscribe must be honoured at send time, not at compose time.**

### 4. Taking money

This is the one to leave alone, and the release notes are the argument. Over four years the
platform added: ACH support (with the note that "ACH payments can take up to five days to
complete"), failed payment attempts recorded on the invoice, invoice merging, payment plans
that can be cancelled and reactivated, shareable invoice links so a parent can pay, Stripe
Payout Reconciliation reports, and General Ledger Accounts assignable to invoice line
items. (`raw/pages/memberhome_action-whatsNew.md`)

`[observed]` The live settings page shows Stripe with "Total Fees 3.9% + $0.30", accepting
ACH and Venmo (`raw/pages/memberhome_misc-surfaces.md`).

`[design]` Every one of those features exists because money is asynchronous and reversible.
A payment is not a boolean. Record **who owes what and who has paid**, which is two tables
and no third party, and let the chapter collect money the way it already does. That is the
single largest scope cut available to you.

### A note on SMS, now that it is visible

`[observed]` The compose form caps `message` at **128 characters**
(`raw/pages/diamond-tier-sweep.md`). That is roughly one SMS segment, so the product does
not split long messages; it stops you writing one. It also keeps a sent-message log with
"Message | Date | Sent By".

`[design]` If you ever build SMS, copy the cap. A message that silently becomes three
billable messages is the classic way a student project runs up a bill.

## Two accounting rules the ledger states outright

`[observed]` "Fees are not included in balance totals."
(`raw/pages/partials-closed.md`) The processor's fee is stored on the transaction, and the
ledger has a Fees column, but the balance is computed without it.

`[observed]` The ledger reports two totals side by side: "Total (Net) with current filters"
and "Total (Net) for current term Jun 20 - Dec 19, 2026".

`[design]` Both are worth copying, and the first one is worth copying carefully. If you
store a fee on a transaction, decide once whether balances include it and write that
decision down, because the two readings differ by real money and nobody will remember which
one you chose.

## Fundraising, in one paragraph

`[observed]` The model is two levels: a **fund** is a destination for money and "may link
each fund to a unique bank account", and a **campaign** is a channel that raises money for
a fund and "may have a publicly accessible donation webpage ... and/or you may log offline
donations as well" (`raw/pages/diamond-tier-sweep.md`). The reports offered are Donors,
Donations, SYBUNT and LYBUNT, the last two being standard lapsed-donor reports.

`[design]` SKIP for version one, but note the one idea worth stealing if the chapter ever
does fundraising: **let a donation be logged offline.** A system that can only record money
it processed itself will not match the chapter's actual books.

## Three details from the unlocked features that change how you would build them

### Publishing is not the same as saving

`[observed]` A blog post carries a `publishDate` separate from when it was written, and a
`pvisibility` of public or "Private (Alpha Delta Member Only)". The public page at
`/alphadelta/blog.php` shows "No blog posts to date" while the admin list shows a stored
2015 entry, which is those two fields working
(`raw/pages/diamond-features-how-they-work.md`).

`[design]` If you ever build anything public-facing, give the record a state and a date
rather than a single "is published" checkbox. Then either filter every read on
`publish_at <= now()`, or run a job that flips the state. The filter is simpler and has no
moving parts; prefer it.

`[observed]` The form also issues a `newId` before anything is saved. `[design]` That is
the standard answer to "how do I attach an image to a post that does not exist yet": create
the id first, upload against it, then save. Worth knowing before you hit the problem.

### Something has to delete things on a schedule

`[observed]` The event attachment page states, verbatim, "Event attachments are only kept
for 6 months" (`raw/pages/diamond-features-how-they-work.md`).

`[design]` A retention rule is a promise that needs a recurring job behind it. It is also
the cheapest way to keep a file bill small. If you build file uploads, decide the retention
rule at the same time, not later, because deleting files nobody expected to lose is worse
than never having stored them.

### One setting can cause a double write

`[observed]` A fundraising fund has a `trackAsIncome` switch, labelled "Yes, donations made
directly to this fund benefit my chapter. Track as both a donation and a transaction."
(`raw/pages/diamond-features-how-they-work.md`)

`[design]` This is a good example of a rule that belongs in one place. A donation that is
also a ledger entry must write both rows in one transaction, or the two reports will
disagree and someone will spend an evening finding out why. If you ever have a record that
feeds two ledgers, write both together or write neither.

## A feature you are paying for may not work

`[observed]` Photo album image upload, `?action=addpictures`, is switched off by the
vendor. Its full text reads "The Photo Album Images feature is offline for the moment as we
apply the latest update. Check back Summer 2025 to see the latest updates." The capture date
is August 2026, so it has been offline for over a year, while remaining a listed feature of
the two paid tiers (`raw/pages/diamond-features-how-they-work.md`).

`[design]` No lesson for the schema, one for the students: a feature on a pricing page is a
claim, not a guarantee. It is also a reminder of why this repository documents what the
software *does*, checked page by page, rather than what its marketing says.

## One query that must not be shared

`[observed]` "View Upcoming Events" lists only future events and drops each one as it
passes; the e-mail audience selector lists every event including past ones
(`raw/pages/full-read-pass-2.md`).

`[design]` That looks like duplication and is not. The member-facing list wants
`starts_at >= now()`; the mail-the-attendees flow must reach events that have already
happened, or an officer can never thank the people who came. Two call sites, two filters.
It is the kind of thing that gets "simplified" into one shared query and quietly breaks a
workflow nobody tests.

## Timezones, the quiet one

`[observed]` The chapter sets one timezone, and changing it asks a question with real
consequences: "Adjust Events To Keep Same Displayed Times? Yes, if my events currently
display that they start at 6:00 PM, they should still show 6:00 PM after the change"
(`raw/pages/memberhome_action-editsitesettings.md`).

That question only exists because a stored timestamp and a displayed time are different
things. `[design]` Store every timestamp in UTC (`timestamptz`, as the schema does), keep
the chapter's timezone as a setting, and convert only when rendering. Do this from day one;
retrofitting it means rewriting every date in the database.

## What you get for free by building for one chapter

`[observed]` The subscription tier gates page access, not code. When the chapter upgraded
from the $3 tier to the $5 tier, no navigation entry appeared and no form gained a field.
The event form had `eventinfo[requireCheckIn]` and `eventinfo[attachFiles]` all along; the
only change was that the words "Diamond Subscription Required" stopped being printed next
to them (`raw/pages/diamond-tier-sweep.md`). One codebase, gated at the page.

`[design]` That is worth noticing for a different reason than pricing: **a feature hidden in
the interface is not a feature that is switched off.** If the students ever hide a control
from someone, the server still has to refuse the action. It is the same lesson as the
permission model, arriving from a different direction.

`[observed]` A related routing habit: an unknown `action` value renders the member home
page instead of an error (`raw/pages/diamond-features-how-they-work.md`). `[design]` Do not
copy this. Return a 404 for a route that does not exist. Silently showing a different page
makes every wrong link look like it worked, and it hides typos from you and from your
users.

`[observed]` A large part of this platform exists to serve many chapters at once: six
event visibility levels reaching out to a region and the nation
(`raw/pages/memberhome_action-eventcreate.md`), region and national calendars, leaderboards
scoped to chapter, region or nation, cross-chapter event invitations, a shared member
database people transfer between, and a whole Honor Societies product line visible
throughout the release notes.

Every one of those disappears for you. So does the per-plan feature gating
(`raw/pages/memberhome_action-viewstorage_tier-chart.md`), which is a billing mechanism,
not a product feature.

`[design]` Keep it that way. If the system ever has to serve a second chapter, the change
is to add a chapter id to most tables and filter every query by it. That is a real project,
and there is no reason to pay for it now.

## Suggested order

1. Everything in the "nothing" rows above. That is a working system.
2. Timezone discipline from the very first migration; it is not a feature, it is a habit.
3. CSV export, because officers will ask for it within a week.
4. E-mail, starting with the audience picker.
5. A scheduler, once there is one e-mail worth sending on a schedule.
6. File uploads, starting with profile photos.

Stop after step 1 and let real officers use it for a term before doing any of the rest.
