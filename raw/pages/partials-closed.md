# Capture: closing every capture that described itself as partial

- Captured: 2026-08-29.
- Why: a grep of `raw/pages/` for the words "sampled", "truncated", "partial" and
  "not read" found seven captures that admitted to being incomplete. This file finishes
  all of them. `raw/` is append-only, so the originals are unchanged and this file
  supersedes the incomplete sections.

## 1. Officer position ids, complete

`raw/pages/memberhome_action-editofficerpositions.md` says its id list "is partial".
The complete mapping, read from the row links:

| Position | officerid |
|---|---|
| President (Primary) | 2892 |
| Academic Chair | 2997 |
| Conference Chair | 7239 |
| Equity & Inclusion Chair | 5928 |
| Fellowship Vice President | 2993 |
| Fundraising Chair | 2999 |
| Historian | 5927 |
| Interchapter Chair | 3050 |
| Leadership Vice President | 3874 |
| Membership Vice President | 2930 |
| Philanthropy Chair | 4338 |
| Pledge Trainer | 2906 |
| Public Relations Chair | 3949 |
| Recording Secretary | 2996 |
| Sergeant-At-Arms | 3589 |
| Service Vice President | 2992 |
| Special Events Coordinator | 6485 |
| Treasurer | 2931 |
| Chapter Advisor (Primary) | 6144 |

18 officer positions and 1 advisor position, 19 in total.

**This closes a loop.** The officer dashboard's budget link is
`?action=viewtransactions&filter=officer%7C6144`, which decodes to `officer|6144`
(`raw/pages/memberhome_action-managemenu.md`). 6144 is the Chapter Advisor position, which
is the position the logged-in account holds. So the dashboard's "Budget: $0 remaining"
panel shows the budget of the viewer's own office.

## 2. Requirement 3 goals, complete

`raw/pages/memberhome_action-editrequirement_reqid-3.md` left four account types unread.
The complete grid for "Service Project" (reqid 3):

| statusid | account type | goal internal | goal external |
|---|---|---|---|
| 0 | Prospect | (empty) | (empty) |
| 3 | Potential New Member | 15 | 5 |
| 2 | Active | 15 | 5 |
| 4 | Associate | (empty) | 5 |
| 111 | Bad Standing | 15 | (empty) |
| 127 | Half-Active | 7.5 | 5 |
| 8 | Inactive | (empty) | (empty) |
| 112 | Leave of Absence | (empty) | (empty) |
| 1 | Officer | 15 | 5 |
| 339 | System | 15 | 5 |
| 5 | Advisor | (empty) | (empty) |
| 6 | Alum | (empty) | **15** |
| 7 | Honorary | (empty) | (empty) |
| 321 | Deceased | (empty) | (empty) |

Two rows worth noting, both previously unread:

- **Alum has an external cap of 15 with no internal target.** A cap with no target is a
  strange state, and it is the kind of data a rebuilt system should either prevent with a
  constraint or handle deliberately. The proposed schema's
  `goal_external_within_target` check would reject this row as written, which is a
  disagreement between our design and the vendor's data worth stating out loud.
- **Bad Standing has a target of 15 and no external allowance**, so members in bad standing
  must earn all 15 hours at chapter events.

## 3. Event ride and coordinator bonus requirement list, complete

`raw/pages/memberhome_action-eventcreate.md` truncated this list. Complete, verbatim
(value=label), for both `eventinfo[ridebonus_reqid]` and `eventinfo[coorbonus_reqid]`:

(empty), 1=Dues, 2=Meeting, 3=Service Hour, 865=Fellowship Event, 866=Leadership Credit,
867=Fundraising Credit, 912=Interchapter Credit, 925=Chair Credit, 937=Special Fellowship,
944=Committee Credit, 1507=Academic Credit, 1511=External Relations Credit,
1605=Open Forum Credit, 2130=Required Event, 2164=Philanthropy Hours, 2234=Dues,
2236=Philanthropy Credit, 2377=Training Credit

19 options: an empty one plus all 18 requirements. Unlike the credit dropdown, this one has
no category suffix, so a bonus is granted against a requirement as a whole.

## 4. Account Manager FORM4, read

`raw/pages/memberhome_action-managebrother_panel-account.md` says FORM4 "was not read in
detail". It is the work experience form:

post: `__csrf_magic`, `action` (hidden), `userId` (hidden), `company` (text),
`companyId` (hidden), `companyName` (hidden), `title` (text),
`industryId` (select, 20 options), an unnamed text field, `monthJoined` (select, 12),
`yearJoined` (text), `monthEnded` (select, 13), `yearEnded` (text), `city` (text),
`state` (text), `country` (select, 246), submit.

The `companyId` and `companyName` pair alongside a free-text `company` is the same
resolve-as-you-type pattern used for members elsewhere, so employers are their own records
that a member links to. That is what makes the alumni directory's "search by employer"
possible.

## 5. Transaction ledger footer, complete

`raw/pages/memberhome_action-viewtransactions.md` truncated the footer. Complete, verbatim:

"Total (Net) with current filters:  $0.00"
"Total (Net) for current term Jun 20 - Dec 19, 2026:  $0.00"
**"Fees are not included in balance totals."**

That last line is a real accounting rule: the processor's fee is recorded on the
transaction (the ledger has a Fees column) but excluded from the balance.

## 6. Contact preferences, complete

`raw/pages/memberhome_misc-surfaces.md` says "the list continued past the captured slice".
The complete set of notification switches, verbatim:

- "...each Sunday showing all upcoming events:"  -> `notify[upcomingevents]`
- "...when an event I am attending approaches:"  -> `notify[event]`, a select with
  Never, 1 hour, 2 hours, 3 hours, 12 hours, 1 day, 2 days, 3 days, 4 days, 5 days,
  6 days, 1 week before
- "...when hours for an event I attended is reported:" -> `notify[completed]`
- "...when I receive a private message:" -> `notify[pm]`
- **"...when I am promoted from a waitlist:"** -> `notify[waitlist]`
- **"...when my account type has changed:"** -> `notify[status]`

**The waitlist switch is a feature nothing else on the site revealed.** Taken with
`eventinfo[maxattendees]` on the event form, it means an event with a limit does not simply
refuse further sign-ups; it keeps a waitlist and promotes people from it.

### Per-affiliation e-mail preferences

Three blocks, one per level of the organisation, each headed "General Updates from
&lt;body&gt;: All other ad-hoc emails sent by &lt;body&gt; leadership." with an
"Email OK  RECOMMENDED" toggle:

- "Alpha Phi Omega National Service Fraternity Emails"
- "Region B Emails"
- "Alpha Delta Chapter Emails"

Field: `notify[optInChapterIds][N][]`, three of them.

### Call, text and paper mail preferences

A separate grid headed "Call, Text, Paper Mail Preferences" with columns "Call | Text |
Paper Mail" and a row per level (National, Region B, Alpha Delta Chapter), each cell a
"Call OK" / "Text OK" / "Mail OK" toggle.

Fields: `notify[doNotCall][]`, `notify[doNotText][]`, `notify[doNotMail][]`, three each.

Note the field names are negative (`doNotCall`) while the labels are positive ("Call OK"),
the same inversion already seen in the privilege grids.

## Full form field list for contact preferences

post: `__csrf_magic`, `userid`, `notify[notify_email]` x2, `notify[email]`,
`notify[email_public]`, `notify[upcomingevents]`, `notify[event]`, `notify[completed]`,
`notify[pm]`, `notify[waitlist]`, `notify[status]`, `notify[optInChapterIds][N][]` x3,
`notify[doNotCall][]` x3, `notify[doNotText][]` x3, `notify[doNotMail][]` x3, submit.
