# Where to run it, and what it costs

> Summary: For a chapter under 50 people, the whole system runs on free tiers, except
> one open question about Vercel's terms. Day one needs only two services: Vercel to run
> the app and Neon for the database. Realistic cost is 0 to 20 dollars per month.
> Status: DESIGN (a recommendation, not a fact about the existing site)
> Read this if: you are choosing where to host the rebuilt system.
> See also: docs/04-system-design/05-feature-infrastructure.md, which says which features
> need any of this in the first place.
> Prices checked: August 2026. Check them again before you commit; they change.

## The short answer

| Job | Service | Cost for a chapter under 50 |
|---|---|---|
| Run the website | Vercel | Free, see the note below on terms |
| Store the data | Neon (Postgres) | Free |
| Send scheduled reminder emails | Upstash QStash | Free, and not needed until you build reminders |
| Actually deliver emails | Resend or Postmark | Free at this volume |
| Handle login | Auth.js | No separate service, runs inside the app |

You do not need all of these on day one. Day one is Vercel plus Neon. Add the other two
only when you build the email features, which are marked LATER in the feature inventory.

## About Upstash

You suggested Vercel plus Upstash. One correction. Upstash is not a general database. It
is a fast key-value store (Redis) and a job scheduler (QStash). Our data is relational,
meaning it is rows in connected tables like members, events, and credits. That needs a
relational database, which is Postgres, not Upstash.

So Upstash cannot hold the main data. It is the right tool for one specific job: firing
the scheduled email reminders. QStash calls a URL in your app on a schedule, for example
every morning, and your app decides which reminders to send. Its free tier allows 1,000
messages per day and 10 active schedules, which is far more than a 50-person chapter will
ever use.

The relational database should be **Neon**, which is Postgres that turns itself off when
nobody is using it, so it is free when idle. Its free tier gives 0.5 GB of storage. A
chapter of 50 people with several years of history will not come close to filling that.

## The Vercel terms question

Your instinct was right to check. Here is the accurate picture.

Vercel's free plan, called Hobby, is generous on the technical limits (100 GB of traffic
a month, which you will not approach). The catch is in the terms, not the limits. Vercel
says Hobby is for personal, non-commercial projects, and that anything serving a business
or generating revenue should be on the paid Pro plan.

Whether an APO chapter's internal tracking tool counts as commercial is a genuine gray
area. It earns no money and has no paying customers, which is not commercial. But it is
an organization's tool, not one student's personal project, which is the part that does
not clearly fit "personal." Nobody can tell you for certain how Vercel would classify it,
and at this size the chance of Vercel noticing or acting is low. But the terms do not
clearly permit it, so you should decide with eyes open rather than assume it is fine.

Two clean ways to remove the doubt:

1. **Pay for Vercel Pro.** It is 20 dollars per month per developer who deploys, not per
   person who uses the app. Members who only log in and use the system are never charged.
   So if one or two students handle deployment, the cost is 20 or 40 dollars a month
   total, and the terms question disappears.

2. **Host somewhere without that restriction.** Cloudflare Pages and Railway both run a
   Next.js app and do not carry Vercel's non-commercial rule. Cloudflare's free tier is
   large. Railway is usage-based and small at this scale. This keeps the cost near zero,
   at the price of a slightly less smooth Next.js experience than Vercel gives.

My recommendation: start on Vercel's free tier while building, because it is the fastest
path and clearly fine for a student project in development. Before real chapter data goes
in and members start using it daily, either move one student to a Vercel Pro seat, or
move hosting to Cloudflare. Make that a deliberate decision, not an accident.

## Realistic monthly cost

| Situation | Cost per month |
|---|---|
| While building and testing | 0 dollars |
| Live, staying on Vercel free (accepting the gray area) | 0 dollars |
| Live, one student on Vercel Pro for clean terms | about 20 dollars |
| Live, hosted on Cloudflare instead of Vercel | near 0 dollars |

Email sending is free at this volume on Resend or Postmark. If you ever exceed their free
tiers, the cost is a few dollars a month, not more.

## What not to do

Do not rent a server you have to manage yourself, do not set up Kubernetes or Docker
orchestration, and do not run your own database on a virtual machine. All of these cost
more in time and money than the managed free tiers above, and they teach operations
skills that are not the point of this project. The managed services keep the students
focused on building the application.

## Sources

Prices and terms were checked in August 2026 and change often. Verify before committing.

- Vercel plans and the Hobby non-commercial restriction: https://www.fencode.dev/en/blog/vercel-free-vs-pro-2026-official-limits-pricing
- Neon free tier limits: https://agentdeals.dev/vendor/neon
- Upstash QStash free tier: https://upstash.com/pricing/qstash
