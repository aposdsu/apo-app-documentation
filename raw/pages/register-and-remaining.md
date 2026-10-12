# Capture: public registration, leaderboards, and the last unopened routes

- Captured: 2026-08-29. Nothing was submitted.

## `/alphadelta/register.php` — the public registration form

The landing page asks the visitor to choose a path. The three choices are plain GET links:

- "I am a student"  -> `?&statusOption=student`
- "I am an advisor" -> `?&statusOption=advisor`
- "I am an alum"    -> `?&statusOption=alum`

Opening the student path renders the account creation form. It was read, not submitted.

### Form (post), submit `submit`

| name | type | required | max |
|---|---|---|---|
| __csrf_magic | hidden | | |
| registration_type | hidden | | |
| statusOption | hidden | | carries the chosen path |
| email | email | yes | 100 |
| **password1** | password | yes | **15** |
| **password2** | password | yes | **15** |
| firstname | text | yes | 25 |
| lastname | text | yes | 25 |
| suffix | text | | 15 |
| maidenName | text | | 25 |
| nickname | text | | 25 |
| phone | text | | 15 |
| campusaddress / campusaddress2 / City / State / ZipCode | text | | 255 / 100 / 50 / 25 / 10 |
| campusaddressCountry | select | | 247 options |
| homeaddress (same five) + homeaddressCountry | | | same |
| gender | radio x3 | | |
| profile[pledgeclassterm] | select | | 5 options |
| profile[pledgeclassyear] | text | | 4 |
| profile[graduationclassterm] | select | | 5 options |
| profile[graduationclassyear] | text | | 4 |
| birth_month / birth_day / birth_year | select | | 13 / 32 / 213 |
| profile[visibility][7,8,9,11,12,13,16] | hidden | | the per-field audience settings |
| identityCheck | radio | | |
| shippingSelection | radio x2 | | |

On-screen help text, verbatim: "Maiden Name: Used to find your membership record with Alpha
Phi Omega.", "Preferred First Name: Replaces your first name throughout the system.",
"Use the buttons below to define your privacy settings:", "Mobile phone preferred."

### Two things worth calling out

**The password field has `maxlength="15"`.** A cap on password length is a real weakness: it
limits how strong a password can be, and a low cap often indicates the value is being stored
in a fixed-width column rather than as a hash, since a hash is always the same length
regardless of input. This is an observation about the field, not proof about the storage,
and it is recorded as such.

`[for the analysis pass]` Whatever the students build, do not put a maximum length on a
password. Hash it, and the input length stops mattering.

**A visitor sets their own privacy settings during registration.** The
`profile[visibility][N]` hidden fields are present on the public form, so the per-field
audience is chosen by the member at sign-up rather than defaulted by the chapter.

`identityCheck` and `shippingSelection` were present but their labels were not captured;
`shippingSelection` suggests the registration flow can involve posting something physical.

## `?action=topNewMemberClasses` — the second leaderboard

Reached from the "Top Potential New Member Classes" tab on `?action=topbrothers`. Same
layout as the member leaderboard: one panel per requirement, headed "In Meetings", "In
Service Hours" and so on, with empty states reading "No recorded &lt;requirement&gt;".

So leaderboards exist for two subjects, individual members and pledge classes, over the same
requirement list.

## `?action=managerecords&reqid=<id>` for a requirement with no categories

On reqid 2130 (Required Event) the report table has just two columns, "Member | Total
Required Events", against the sixteen columns on the split requirement reqid 3
(`raw/pages/memberhome_action-managerecords_reqid-3.md`). Same page template; the column
count is driven by whether the requirement has categories.

Report header, verbatim: "REPORT OF REQUIRED EVENTS | Date of Report: August 29th, 2026 |
Begin Date: June 20th, 2026 | End Date: December 19th, 2026".

## `?action=manageevents&reqid=3` — the template with a different requirement

"Manage Service Projects", "Use this page to manage Service Projects. If you are not the
appropriate officer or the coordinator of the event then you must send them your attendance
list so that they can mark the project as 'complete' which adds Service Hour credit to those
who attended.", "Post New Service Project", "Log Past Service Project",
"Manually Record Service Hours".

Table headers: "Event | Date | Service Hours | Attendees | Actions".

Every noun in the page is substituted from the requirement, confirming one template serves
all 18.

## `eventinfo[recurringScope]` on the event edit form

It is a **hidden input with an empty value** on a non-recurring event. Its options cannot be
observed here, because they would only be offered when editing an event that is part of a
repeating series, and this chapter's recurring events were created as separate records. Its
purpose is therefore still inferred from the name, and remains marked as such in
`docs/03-api/write-operations.md`.

## Two more verbs found on the event detail page

Harvesting anchors from `?action=eventsignup&eventid=<id>` turned up two values that appear
nowhere in the navigation:

- **`?action=eventattendeeremove`** — removes one member from an event's attendee list. A
  write. Recorded, **not opened**. It is the counterpart of the access-log line
  "Removed '<member>' from the '<event>' event sign-up sheet"
  (`raw/pages/memberhome_action-viewlog.md`).
- **`action=TEMPLATE`** — not a real route. It appears in an anchor whose href is a
  client-side template string, used to build attendee rows in the browser. Its presence is a
  small finding in itself: the attendee list is partly rendered by JavaScript from a
  template, which is the only place on the site where that happens.

## Anchor-harvest coverage note

Verb sets were harvested from the anchors of: memberhome (dashboard), managemenu, profile,
viewchapter, managebrother, managedues, viewstorage, brothers, families, eventsignup, setup
and topbrothers. Every `action=` value found across all of them is now either captured or,
if it writes, recorded in `docs/03-api/write-operations.md` without being opened.
