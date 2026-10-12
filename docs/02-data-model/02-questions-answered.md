# The eight questions, answered

> Summary: The eight open questions at the end of the first data model, each answered
> from the walkthrough with the file that shows it, or recorded as still unknown.
> Status: OBSERVED
> Read this if: you want the short version of what the walkthrough settled.
> Depends on: docs/02-data-model/00-domain-model.md

### 1. What is the complete list of privileges?

**Answered.** There are two lists.

Officer position privileges, 39 in total: 20 general ones (site settings, approve users,
external webpages, photo album images, blog posts, edit member profiles, fundraising
campaigns, announcements, bulk e-mail, bulk SMS, families/groups, achievements, meeting
minutes, awards and voting, file uploads, create forms, complete national forms, courses,
external sales tools, calls for applications), and one "Manage X Requirement" privilege
per requirement, generated from the requirement list.

Account type privileges, 40 in total: 7 about events, 16 about access, and one
"Log their own: Internal X" per requirement.

Full lists with field names:
`raw/pages/memberhome_action-editofficerprivileges_officerid-2892.md` and
`raw/pages/memberhome_action-editprivileges_statusid-2.md`.

### 2. What kinds of requirements exist? Is the target always a number?

**Answered.** The target is always a number, but there are two kinds of number. A
requirement is either counted in units ("Hours/Points, each member must attend X number of
hours/points") or as a share ("Percentage, each member must attend X% of the total number
of events of this type"). The flag is `isPercentage`. Targets can be fractional; this
chapter uses 7.5 and 0.75. Setting a target to 0 hides that progress bar from members of
that account type, which the form states in words.
(`raw/pages/memberhome_action-createrequirement.md`,
`raw/pages/memberhome_action-editrequirement_reqid-3.md`)

There is also a second, simpler kind of record called a **point tracker**: the same two
label fields with a flag and no goals. This chapter has none.
(`raw/pages/memberhome_action-createPointTracker.md`)

### 3. Can one event count toward more than one requirement?

**Answered: yes.** The event form has a repeating "Requirement Credit" group with a
"+ add another credit" button. The events list shows one event carrying three credit chips
("1 | External Relations Credit   1 | Service Hour   1 | Philanthropy Hours"), and a member
notification reads "you've been credited with: 1 Meeting, 1 Required Event".
(`raw/pages/memberhome_action-eventcreate.md`, `raw/pages/memberhome_action-viewevents.md`,
`raw/pages/memberhome_action-viewnotifications.md`)

### 4. Are meetings a kind of event, or something separate?

**Answered: a kind of event, and specifically a requirement.** "Meeting" is requirement id
2 in the same list as Service Project and Fellowship Event. Its management page is the same
template as every other requirement's, with the word "Meeting" substituted in.
(`raw/pages/memberhome_action-managerequirements.md`,
`raw/pages/memberhome_action-manageevents_reqid-2.md`)

One difference is worth knowing: meeting credit cannot be typed in by hand the way service
hours can. The Account Manager (`raw/pages/memberhome_action-managebrother_panel-records.md`)
says, verbatim, "To add meeting credit you will need to
either log a past meeting or create a new meeting on the calendar and add this member to
the attendee list."

### 5. What membership statuses exist by default, and what do chapters add?

**Answered.** Ten account types come with the product: Prospect, Officer, Active,
Potential New Member, Associate, Advisor, Alum, Honorary, Inactive, Deceased. This chapter
added four of its own, under the heading "Custom Local Account Types (Alpha Delta Only)":
Bad Standing, Leave of Absence, Half-Active, System.

Above those sit six national membership statuses that every account type maps to: Active,
Alumni, Deceased, Inactive, PNM, Prospect. Above those again sit four "membership stages"
used for bulk transitions: Prospect, Potential New Member, Member, Alumni.
(`raw/pages/memberhome_action-managestatuses.md`,
`raw/pages/memberhome_action-editstatus_statusid-111.md`,
`raw/pages/memberhome_action-viewMembershipStages.md`)

### 6. Is progress calculated when the page loads, or stored and updated later?

**Partly answered, and the evidence points to calculated on demand.** Every progress
screen carries a date range that the reader can change, and changing it re-runs the
figures ("Showing transactions from ___ to ___.", "Begin Date:" and "End Date:", the four links
"this term | academic year | calendar year | all time"). A stored total could not answer
an arbitrary date range. `[inferred]`, confidence medium-high.
(`raw/pages/memberhome_action-managerecords_reqid-3.md`,
`raw/pages/memberhome_action-viewrecords_reqid-3.md`)

What is definitely stored is the individual credit row. Whether the site also caches a
per-member total is not visible from the pages we read.

### 7. Do requirements carry over between terms, or does each term start fresh?

**Answered: requirements carry over; the credits are what get windowed.** A requirement
has no term field anywhere on its form. What changes per term is the date window that
progress is measured in, which comes from the chapter's term start dates.
(`raw/pages/memberhome_action-createrequirement.md`,
`raw/pages/memberhome_action-setterm.md`,
`raw/pages/memberhome_action-managerecords_reqid-3.md`)

This is a meaningful correction. Our first schema attached `term_id` to `requirement`,
which would force a chapter to re-enter every rule twice a year.

### 8. If a member's status changes mid-term, what happens to their credits and targets?

**Answered for the credits, by direct observation, without changing anyone's account
type.** The reasoning that was a guess before now has evidence
(`raw/pages/gap-resolution-2.md`):

- A credit row carries no account-type tag and no term tag. The "Add Record" form sends
  only userid, title, date, units, category, isExternal and the reqid, so a credit is filed
  under (member, requirement).
- The operator's own Timeline shows a real account-type change ("Apr 11, 2024 -
  Transitioned to an 'Advisor: Chapter Advisor'"), and their 48.5 service hours earned in
  2015-2016 still list and total today, even though their current type (Advisor) has no
  service target.

So **existing credits persist unchanged across an account-type change; they are not
recalculated and not re-filed.** Changing the account type only changes the target (the
denominator), which is looked up by the member's current account type. Confidence: high.
The single thing still unobserved is cosmetic (how a progress bar renders when the current
type's target is 0 or blank), not where the data goes.
