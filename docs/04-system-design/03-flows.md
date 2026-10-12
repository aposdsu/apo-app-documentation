# The main workflows, end to end

> Summary: How the nine workflows that matter actually run on the real site, from the first
> click to the row that gets written. Each one ends with what to copy and what to change.
> Status: OBSERVED (the steps and the screens) with DESIGN notes marked.
> Read this if: you are about to build a feature and want to know what it has to do.
> Depends on: docs/02-data-model/00-domain-model.md, docs/03-api/write-operations.md

Nothing in this document was performed. Every step was read from the pages, the links and
the forms. Where a step's effect is a prediction, it says so.

## 1. A new person becomes a member

Four ways in, all on `?action=inviteuser`
(`raw/pages/memberhome_action-inviteuser.md`):

1. **Find them in the shared database.** The page says transfer students "may already be
   in the system". An officer searches, picks the person, chooses an account type and
   optional officer positions.
2. **Type them in.** First, middle and last name, suffix, nickname, e-mail, account type.
3. **Upload a CSV.**
4. **Share the public link** `https://www.apoonline.org/alphadelta/register.php`. The
   visitor picks student, advisor or alum and registers themselves.

Route 4 lands in a queue. `?action=userspending` lists everyone waiting. Each row shows the
applicant's name, e-mail and **what they are asking to become** ("Requesting to be a PNM."),
and the decision is a **single dropdown per applicant** (`status[N]`) whose options are
**Skip** and **Reject** followed by **every account type**; choosing an account type
approves the applicant as that type, and officer positions can be set in the same submit
(`positions[N][]`). The form posts to `?action=approveusers`. Until approved they cannot log
in. The chapter had 7 people waiting.
(`raw/pages/signup-flow-observed.md`, `raw/pages/memberhome_action-userspending.md`,
`raw/pages/full-read-findings.md`)

### The self-registration path, step by step

This is what a visitor using route 4 actually goes through
(`raw/pages/register-and-remaining.md`, `raw/pages/unread-routes-sweep.md`):

1. **Start.** The visitor opens `register.php`. The first screen offers **"Sign up
   instantly with..." Google or Facebook**, or **"...or enter your personal email"** (with
   a tip not to use a shared address like `president@chapter.com`), plus an "I already have
   an account" link to log in. So an account is created either from a social identity or
   from an e-mail and password.
2. **Pick a role.** The visitor chooses **student**, **advisor**, or **alum** (carried as a
   hidden `statusOption`), each shown with a short preview of what that role will be able to
   do. This is a self-declaration; it becomes the "what they are asking to become" shown to
   the officer later, and the officer, not the visitor, sets the final account type.
3. **Fill the account-creation form.** Fields include e-mail, **password (capped at 15
   characters, a weakness not to copy)**, first/last/suffix/maiden/nickname, phone, campus
   and home addresses, gender, pledge-class term and year, graduation-class term and year,
   and birthday. The visitor also **sets their own per-field privacy** (`profile[visibility]
   [N]` on the public form) and answers an `identityCheck`. Maiden name is explicitly "used
   to find your membership record", which is how a returning or transfer member is matched
   to an existing person.
4. **Submit → pending.** The person is created but lands in the `userspending` queue as a
   pending registration; they cannot log in yet.
5. **Officer decision.** An officer opens the queue and chooses Skip, Reject, or assign an
   account type and approve. On approval the person becomes an active member with that
   account type. (Officers can also seed the same outcome ahead of time via the invite or
   CSV routes above, which send an activation e-mail instead of waiting for a queue.)

No separate e-mail-verification step was observed between the form and the queue; the gate
is the officer approval, not an e-mailed link. (The social path relies on Google/Facebook
having verified the address.)

`[design]` Copy the three-way choice. "Approve or nothing" is the version students build
first, and it leaves an officer with no way to decline someone without deleting them.

**What to copy.** The approval queue, and the separation between a person and their
membership in a chapter. **What to change** `[design]`: for one chapter you do not need
the shared cross-chapter database, so a person and a member can be one record, with a
`membership` row per term.

## 2. An officer sets up a requirement

`?action=managerequirements` lists them; "Create New" opens
`?action=createrequirement` (`raw/pages/memberhome_action-createrequirement.md`).

The officer gives it a label ("Service Project"), a unit label ("Service Hour"), says
whether it is split into categories, whether it is counted in units or as a percentage of
all events of that type, and whether outside work counts. Then they fill in a grid: for
each of the 14 account types, the total required and the most that may come from outside.
A target of 0 hides the progress bar for that account type.

Creating the requirement also creates two privileges for it, one in each grid: "Manage
&lt;name&gt; Requirement" for officer positions and "Log their own: Internal &lt;name&gt;"
for account types.

**What to copy.** All of it, except the merging of requirement and event type. See
`docs/02-data-model/01-how-the-vendor-differs.md`, point 2.

## 3. An event runs, from creation to credit

This is the workflow the whole product is built around.

1. **Create.** `?action=eventcreate`. Title, date and time, optional shifts, location,
   description, a limit on attendees, coordinators, a sign-up window with three moments
   (open, lock, close), who can see it, who can sign up, and whether the attendee list is
   visible. Then the important part: one or more **requirement credits**, each an amount
   and a requirement. (`raw/pages/memberhome_action-eventcreate.md`)
2. **Members sign up.** Each sign-up is its own row, created and deleted individually,
   inside the event's open/lock/close window, and it can record that the member is driving
   and has open seats. If the event has an attendee limit and it is full, further sign-ups
   go on a **waitlist**, and a member is notified when promoted off it (confirmed from the
   notification preferences, `raw/pages/unread-routes-sweep.md`).
   (`raw/pages/memberhome_action-viewlog.md`)
3. **The event happens.** An officer can add people to the list by hand ("Manually add
   member" on the event page).
4. **An officer completes it.** The event appears on `?action=pendingevents` under "Events
   Ready to be Completed", and the page states the effect in words: "Completing events
   awards each attendee credit for attending the event which is reflected in their
   requirement progress bars on their homepage."
   (`raw/pages/memberhome_action-pendingevents.md`)
5. **Everyone is credited and told.** Each attendee gets a credit for every credit row on
   the event, and a notification reading "For attending &lt;event&gt; you've been credited
   with: 1 Meeting, 1 Required Event."
   (`raw/pages/memberhome_action-viewnotifications.md`)

**What to copy.** The completion step. It is the moment when a messy sign-up list becomes
real data, and it gives officers a chance to correct the list first.

**What to change** `[design]`. Record attendance separately from sign-up, so you keep the
gap between who promised and who came. Make completion idempotent, meaning running it
twice does not double anyone's credit; the schema does this with a unique index on
(attendance, requirement).

## 4. A member gets credit for something the chapter did not run

`?action=viewrecords&reqid=<id>` shows one member's record for one requirement and carries
an "Add Service Hours" form: a project name, a date, a number of hours, a category, and a
choice between "Internal Event (chapter hosted)" and "External Event (service projects
completed outside of the chapter)". (`raw/pages/memberhome_action-viewrecords_reqid-3.md`)

The form sends no event id. That is the clearest single piece of evidence that credit is
its own record and does not depend on an event.

Whether a member may do this for themselves is an account-type privilege, and the site
labels that whole group "(not recommended)".

**What to copy.** All of it. Real chapters always have exceptions, and without a manual
entry route officers keep a private spreadsheet and stop using the system.

## 5. Everyone's progress gets checked

Two screens, both driven by a date window.

- `?action=managerecords&reqid=<id>` is the officer's view of everyone. Its header reads
  "REPORT OF SERVICE HOURS | Date of Report: August 28th, 2026 | Begin Date: June 20th,
  2026 | End Date: December 19th, 2026", the dates default to the current term, and each
  total cell is formatted as the amount earned, the word "of", and the goal. For a split
  requirement there is an Internal, External and Total column for the requirement and for
  each category. (`raw/pages/memberhome_action-managerecords_reqid-3.md`)
- `?action=viewrecords&reqid=<id>` is the member's own view, with four windows to choose
  from: this term, academic year, calendar year, all time.

`?action=createreport` builds the full report: pick the member fields, pick the
requirements, pick the account types, pick the dates, and either view it or download a CSV.
It also offers "Only show members lacking in the selected requirements", which is the query
an officer actually wants before a chapter meeting.
(`raw/pages/memberhome_action-createreport.md`)

**What to copy.** The date window, the "N of M" cell, and the "who is behind" filter.

## 6. The term turns over

Two separate things happen, and they are not connected in the product.

**The term window moves by itself.** The chapter sets a recurring month and day for each
term start (`?action=setterm`). When that date passes, "this term" means the next window,
and every progress bar starts from zero because the credits before it fall outside the
window. Nothing is copied, reset or archived.
(`raw/pages/memberhome_action-setterm.md`)

**People and officers are moved by hand.** `?action=viewMembershipStages` shows four
stages (Prospect, Potential New Member, Member, Alumni) and offers one bulk action:
tick members and press "Graduate Members »".
`?action=defineofficers` is a single page listing every position with a name box, and one
submit button labelled "Update Officers and Send Activation Emails".
(`raw/pages/memberhome_action-viewMembershipStages.md`,
`raw/pages/memberhome_action-defineofficers.md`)

**What to change** `[design]`. This is the weakest part of the product. Because account
type is not stored per term, a chapter cannot look back and say who was active last spring.
Storing membership per term costs one extra table and makes the whole history queryable.
It also makes officer transition safe: last term's assignments stay where they are instead
of being overwritten.

## 7. A member owes and pays dues

The money side has its own workflow, and it runs through three screens that were documented
separately (`raw/pages/unread-routes-sweep.md`, `raw/pages/memberhome_action-managedues.md`,
`raw/pages/memberhome_action-viewtransactions.md`, `raw/pages/self-flows-observed.md`).

1. **Define what is owed.** The Dues requirement (`?action=editrequirement&reqid=1`) is a
   special requirement: it sets a dues amount **per account type**, splits each amount into
   Chapter / Region / National, carries a due date and time, and has toggles for an
   automatic late fee and for accepting online payments. So a member owes the amount their
   account type is set to, and it shows as a progress bar on their home page like any other
   requirement. `[observed]`
2. **Charge.** `?action=managedues` ("Dues & Fees") lists every member with columns Member,
   Total Paid, Due Date, Account Type, Balance, and a "view details" / "Set Due Date" link.
   Beside it is a "Log Payment or Charge Fee" form. **Charge Fee** adds an ad-hoc amount to a
   member's balance (for a fine or a one-off fee) on top of the dues they already owe.
   `[observed]`
3. **Pay.** Two ways. An officer records a payment with the same form in **Log Payment**
   mode: pick the member, a method (Cash, Credit Card, Check, Other), an amount and a memo;
   "payments will be deducted from a member's balance". Or, if the Dues requirement's
   online-payments toggle is on, the member pays online through a checkout page and a
   payment processor (`?action=managePaymentProcessors`, plan-dependent). `[observed]` for
   the officer path; `[inferred]`, high, for the online path from the toggle and the
   payment-processor route.
4. **Record in the ledger.** Payments and fees land in the **Transaction Ledger**
   (`?action=viewtransactions`) with a Type of "Dues Payment" or "Fee Assessment" (the
   ledger also holds plain Withdraw / Deposit rows), columns Date, Payer/Payee, Memo, Type,
   Amount Paid, Fees, Amount Received, and each row can be attributed to a budget owned by an
   officer position. `[observed]`
5. **Balance and status settle.** The member's balance on `managedues` drops as payments are
   recorded, the dues progress bar fills, and the per-member **invoice** moves through its
   states (Open, Pending, Paid, Void). If the due date passes unpaid and the late-fee toggle
   is on, the automatic late fee is assessed. `[observed]` for the states;
   `[inferred]`, medium, for the automatic late-fee assessment (read from the toggle's label,
   not watched happening).

The operator confirmed (2026-08-30) that this chapter has never used the automatic late fee
or online payment. In practice, dues here are recorded by an officer by hand, and steps 1
and 4 (define what is owed, record the payment) are the parts actually in use; the late-fee
and online-payment parts of steps 3 and 5 exist but are unexercised, so their behavior is
unobserved.

**What to copy.** Recording who paid what, by what method, against a balance, and keeping a
ledger. **What to change** `[design]`: the Chapter / Region / National split is a
national-hierarchy concern a single chapter collapses to one destination, and **taking card
payments online is a large project** (a payment provider, card-data rules, refunds) that the
feature inventory marks SKIP; record who paid and collect the money however the chapter
already does, at least to start.

## 8. An award is granted

An award ends up as a record on a member's profile, and there are two ways the chapter
decides who gets one (`raw/pages/award-and-password-flows.md`,
`raw/pages/self-flows-observed.md`).

1. **Define the award.** Five Distinguished Service Keys are built in; a chapter adds its
   own on `?action=manageUserAwards` ("Define Chapter Awards").
2. **Decide the winner, one of two ways:**
   - **Direct.** An officer just grants it: `?action=manageUserAwardRecords` (or the Awards
     tab of the Account Manager), pick award, member, an optional subtitle and a date.
   - **By vote.** `?action=manageballot` runs a five-step ballot: define awards, set up the
     ballot (which awards, which account types vote, who is eligible for each, whether
     write-ins are allowed), open and later close the polls, view turnout by account type,
     and finally clear votes and reset. Voting is anonymous, one submission per person.
3. **Record it.** Either way, the award is written onto the member with the grant form,
   which posts to `?action=addUserAwardRecord`; it then shows on the member's Awards panel.
   Removing it uses the row's trash control (`?action=deleteUserAwardRecord`).

This was the one write flow exercised directly and reversibly (a Distinguished Service Key
granted to the operator's own record and then removed), so the endpoints are verified, not
predicted (`raw/pages/self-flows-observed.md`, Flow B). One thing to note for a rebuild:
deleting the award record does not remove its "Received Award" entry on the member's
activity Timeline; that is a separate row deleted separately.

**What to copy.** An Award, an AwardRecord (member + award + date + subtitle), and, only if
the chapter votes on awards, a Ballot. **What to change** `[design]`: most single chapters
grant directly; treat the ballot as optional.

## 9. A member's password is changed or reset

Three entry points, and none was exercised (no password was typed, changed, or reset;
`raw/pages/award-and-password-flows.md`).

1. **The member changes it themselves.** `?action=changepassword` (Edit Profile > Change
   Password) asks for the **current password** plus the new one twice
   (`email`, `oldpass`, `newpass1`, `newpass2`). The same page links or unlinks a Google or
   Facebook identity ("Log in with: Connect / Disconnect"), so an account can sign in by
   password, by a social identity, or both.
2. **The member is locked out.** The login page carries a "forgot password?" link: enter the
   e-mail, and a reset link or code is sent. (The form was not opened or submitted, because
   submitting sends a reset e-mail.)
3. **An officer forces a reset for someone else.** `?action=resetPassword` appears in a
   member's Account Manager and sends or forces a reset for that member. It was recorded as
   existing and deliberately **not** opened.

**What to copy.** The three entry points map cleanly onto any modern auth library
(self-change with current password, e-mailed reset token, admin-initiated reset). **What to
change** `[design]`: drop the 15-character password cap seen on the registration form, and
store only a hash so a password is never handled in the clear, including here.

## The one workflow that does not exist

There is no approval step for credit. Credit is created by an officer completing an event
or by an officer typing it in, and it counts immediately. Nothing in the site showed a
pending-then-approved state for a credit. `[inferred]`, confidence medium: absence of
evidence across the record screens, the officer dashboard and the notification text.

`[design]` The proposed schema keeps `approved_at` on a credit anyway, because it costs one
nullable column and some chapters will want it. Default it to "approved on creation" and
only turn approval on if the chapter asks.
