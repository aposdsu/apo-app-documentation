# Capture: memberhome.php?action=eventcreate  (Add Calendar Event form)

- URL: https://www.apoonline.org/alphadelta/memberhome.php?action=eventcreate
- Also captured with a prefilled requirement: memberhome.php?action=eventcreate&reqid=867
- Captured: 2026-08-28 via get_page_text + find + DOM form read. THE FORM WAS NOT SUBMITTED.
- Why this URL was opened: it carries no record id and no value-bearing parameter, so a
  plain GET of it renders an empty form. Nothing was typed into it and nothing was sent.

## Section labels on screen, verbatim

"Event Title", "Date of Event", "break event into shifts", "All day", "Repeat...",
"Location", "Requirement Credit", "This event will not count towards any requirement",
"+ add another credit", "Additional Information", "Mobile Check-in",
"Require attendees to check-in on their mobile phones to receive credit",
"Diamond Subscription Required learn more", "Allow Sign-ups on", "Lock Sign-ups on",
"Close Sign-ups on", "Require Ride", "Require attendees to have a ride", "add bonus",
"Max Number of Attendees", "leave blank if no limit", "Coordinator(s)",
"Make me the event coordinator.", "Let anyone volunteer to be the coordinator.",
"Delegate taking attendance to:", "Add event coordinator(s) as attendee(s)",
"Who can see this event?", "Who can sign-up?", "Show attendee list?",
"Event coordinators and site admins can always view the attendee list.",
"Invite Chapters/Groups", "Group Event?",
"Is this event part of a semester-long series that should be grouped together and counted
as a single event?", "Attach files?", "Attach Files", "or cancel"

Sentence printed under the visibility select, verbatim:
"This event will appear on your Alpha Delta Calendar and the Region B Calendar; visible to
any logged in member."

## Form (read only, never submitted)

- method: post
- submit button label: "Add Calendar Event"
- every field is namespaced `eventinfo[...]`

| name | type | max | value on empty form |
|---|---|---|---|
| __csrf_magic | hidden | | <redacted> |
| eventinfo[title] | text | 255 | |
| eventinfo[eventDate_date] | text | 10 | |
| eventinfo[eventDate_hours] | text | 2 | |
| eventinfo[eventDate_mins] | text | 2 | |
| eventinfo[eventDate_ampm] | select-one | | pm (2 options) |
| eventinfo[eventDate_hours_end] | text | 2 | |
| eventinfo[eventDate_mins_end] | text | 2 | |
| eventinfo[eventDate_ampm_end] | select-one | | pm (2 options) |
| eventinfo[eventDate_date_end] | text | 10 | |
| eventinfo[numshifts] | hidden | | 1 |
| eventinfo[shift_1_hours] | text | 2 | |
| eventinfo[shift_1_mins] | text | 2 | |
| eventinfo[shift_1_ampm] | select-one | | pm |
| eventinfo[shift_1_date] | text | 10 | |
| eventinfo[isAllDay] | checkbox | | 1 |
| eventinfo[recur_isRepeat] | checkbox | | true |
| eventinfo[recur_repeat] | select-one | | weekly (4 options) |
| eventinfo[recur_repeatevery] | select-one | | 1 (30 options) |
| eventinfo[recur_until] | text | | |
| eventinfo[location] | text | | |
| eventinfo[locationLat] | hidden | | |
| eventinfo[locationLng] | hidden | | |
| eventinfo[numreqs] | hidden | | 0 on the empty form, 1 when opened with &reqid=867 |
| eventinfo[info] | textarea | | |
| eventinfo[requireCheckIn] | checkbox | | 1 |
| eventinfo[eventDateShow_date] | text | 10 | 08/28/2026 (today) |
| eventinfo[eventDateShow_hours] | text | 2 | 11 |
| eventinfo[eventDateShow_mins] | text | 2 | 00 |
| eventinfo[eventDateShow_ampm] | select-one | | pm |
| eventinfo[eventDateLocked_date] | text | 10 | |
| eventinfo[eventDateLocked_hours] | text | 2 | |
| eventinfo[eventDateLocked_mins] | text | 2 | |
| eventinfo[eventDateLocked_ampm] | select-one | | pm |
| eventinfo[eventDateClosed_date] | text | 10 | |
| eventinfo[eventDateClosed_hours] | text | 2 | |
| eventinfo[eventDateClosed_mins] | text | 2 | |
| eventinfo[eventDateClosed_ampm] | select-one | | pm |
| eventinfo[ride] | checkbox | | 1 |
| eventinfo[ridebonus_units] | text | 5 | |
| eventinfo[ridebonus_reqid] | select-one | | empty (19 options, see below) |
| eventinfo[maxattendees] | text | | |
| eventinfo[coordinatorOption] | radio | | self (selected), volunteer, deligated |
| eventinfo[coordinatorname] | text | | |
| eventinfo[coordinator] | hidden | | |
| eventinfo[coordinator2name] | text | | |
| eventinfo[coordinator2] | hidden | | |
| eventinfo[coorAsAttendee] | checkbox | | true |
| eventinfo[coorbonus_units] | text | 5 | |
| eventinfo[coorbonus_reqid] | select-one | | empty (19 options) |
| eventinfo[visibility] | select-one | | 45 (6 options) |
| eventinfo[rsvp] | select-one | | 45 (6 options) |
| eventinfo[rsvpvisibility] | select-one | | 0 (5 options) |
| eventinfo[invitewhom] | radio | | none (selected), custom |
| eventinfo[invitechapterids] | hidden | | |
| eventinfo[isGroupedEvent] | radio | | no (selected), new, existing |
| eventinfo[eventGroupTitle] | text | | |
| eventinfo[attachFiles] | checkbox | | true |
| (unnamed) | submit | | "Add Calendar Event" |

### Requirement credit rows (repeating group)

When the page is opened as `?action=eventcreate&reqid=867`, `eventinfo[numreqs]` is 1 and
one credit row is rendered:

| name | type | value | options |
|---|---|---|---|
| eventinfo[req_1_units] | text | 1 | |
| eventinfo[req_1_id] | select-one | 867-0 | see the option list below |
| eventinfo[req_1_isPerShift] | select-one | 1 | 1=per shift, 0=per event |

`eventinfo[req_1_id]` options, verbatim (value=label). The value is
`<reqid>-<categoryid>`:

1-0=Charge as Admission Fee, 2-0=Meeting, 3-1=Service to the Campus,
3-2=Service to the Community, 3-3=Service to the Nation, 3-4=Service to the Fraternity,
865-0=Fellowship Event, 866-0=Leadership Credit, 867-0=Fundraising Credit,
912-0=Interchapter Credit, 925-0=Chair Credit, 937-0=Special Fellowship,
944-0=Committee Credit, 1507-0=Academic Credit, 1511-0=External Relations Credit,
1605-0=Open Forum Credit, 2130-0=Required Event, 2164-0=Philanthropy Hours, 2234-0=Dues,
2236-0=Philanthropy Credit, 2377-0=Training Credit

Note that requirement 3 (Service Project) is the only one with categories, and it appears
four times, once per category id 1 to 4. Those are the same category ids seen in
`existingSubGoal[<categoryid>][...]` on the requirement edit form
(raw/pages/memberhome_action-editrequirement_reqid-3.md).

Note also that reqid 1 appears as "Charge as Admission Fee" here, not "Dues & Fees".

### eventinfo[ridebonus_reqid] and eventinfo[coorbonus_reqid] options

(empty), 1=Dues, 2=Meeting, 3=Service Hour, 865=Fellowship Event, 866=Leadership Credit,
867=Fundraising Credit, 912=Interchapter Credit, 925=Chair Credit, 937=Special Fellowship,
944=Committee Credit, 1507=Academic Credit, 1511=External Relations Credit,
1605=Open Forum Credit (list continues; the read was truncated at this point)

These two selects are the "add bonus" controls next to "Require Ride" and next to the
coordinator options. They pair a number of units with a requirement.

### eventinfo[visibility] options ("Who can see this event?")

| value | label |
|---|---|
| 45 | Any Alpha Phi Omega member (recommended for most events) |
| 40 | Only members in Region B |
| 20 | Non-initiated and initiated members of Alpha Delta |
| 10 | Only initiated members and alumni of Alpha Delta |
| 5 | Only officers of Alpha Delta |
| 60 | Public to the Internet (recommended for recruiting events) |

### eventinfo[rsvp] options ("Who can sign-up?")

| value | label |
|---|---|
| 45 | Any Alpha Phi Omega member (recommended) |
| 40 | Only members in Region B |
| 20 | Only prospects, Potential New Members, members, and alumni of Alpha Delta |
| 10 | Only initiated members and alumni of Alpha Delta |
| 5 | Only officers of Alpha Delta |
| 0 | Disable sign-ups |

### eventinfo[rsvpvisibility] options ("Show attendee list?")

| value | label |
|---|---|
| 0 | Visible |
| 1 | Hidden until sign-ups are locked |
| 2 | Hidden until sign-ups are closed |
| 3 | Hidden until the start of the event |
| 4 | Hidden |

### Invite Chapters/Groups

Radio `eventinfo[invitewhom]`: "none" = "Do not send invitations",
"custom" = "Invite specific chapters/groups...", paired with hidden
`eventinfo[invitechapterids]`.

### Group Event

Radio `eventinfo[isGroupedEvent]`: "no" = "No", "new" = "Yes, create a new Event Group...",
"existing" = "Yes, group this event together with an existing Event Group...".
Text field `eventinfo[eventGroupTitle]` accompanies the "new" option.
