# One event

> Summary: The page a member opens to read an event and sign up, and the page an officer
> uses to run it. The same list serves as the sign-up sheet and the attendee list.
> Status: OBSERVED
> Read this if: you are building the event screen.
> Depends on: raw/pages/memberhome_action-eventsignup_eventid-1152799.md

**Route:** `memberhome.php?action=eventsignup&eventid=<id>`

Despite the name, this is the event's detail page. Every event title on every list page
links here.

## What it shows

The title, the date and time, an "Add to Google Calendar" link, the location, the
description, who created it, when sign-ups lock and close, the credit it awards, the event
coordinator, and a numbered list of the members who have signed up. At the bottom of the
list is "Manually add member".

## Admin actions

Six links, none of which this walkthrough opened:

| Label | Route | What it would do |
|---|---|---|
| Complete event | `?action=eventcomplete&eventid=` | award credit to everyone on the list |
| E-mail attendees | `?action=defineEmailFilters&eventid=` | start a bulk e-mail to them |
| Text attendees | `?action=smsform&eventid=` | start a bulk SMS |
| Edit event | `?action=eventedit&eventid=` | open the create form with values filled in |
| Manage attachments | `?action=manageeventattachments&eventid=` | files on the event |
| Delete event | `?action=eventdelete&eventid=` | delete it |

## The thing this page does not have

A separate attendance list. The sign-up sheet is the attendee list, and an officer edits it
by hand rather than marking people present or absent. Nothing observed records "signed up
and did not come".

That is the one place where copying this product would lose data you want. Keep sign-up
and attendance as two lists; the gap between them is exactly what a chapter argues about.
