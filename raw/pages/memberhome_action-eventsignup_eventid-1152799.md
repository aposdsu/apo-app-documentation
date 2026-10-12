# Capture: memberhome.php?action=eventsignup&eventid=1152799  (one event's detail page)

- URL: https://www.apoonline.org/alphadelta/memberhome.php?action=eventsignup&eventid=1152799
- Captured: 2026-08-28 via DOM innerText read + find + read_page. Nothing was clicked.
- Why this URL was opened: it is the target of the event title link on
  `?action=viewevents` and on the officer dashboard, so it is the site's own "open this
  event" link. It carries an id and no value-bearing parameter.
- ATTENDEE NAMES AND PHONE NUMBERS APPEAR ON THIS PAGE AND ARE DELIBERATELY NOT RECORDED.

## What the page shows, in order

1. Event title as a heading: "Tomodachi Life: Living in APO | GBM #1"
2. "Admin Actions" block (see the link table below)
3. Date line: "Aug 31, 2026 at 7:00pm to 9:00pm"
4. "Add to Google Calendar"
5. Location line: "Zip Launchpad"
6. A short tagline, then the long description text
7. "Created by <member name redacted>"
8. "Sign-ups lock on Aug 31 at 7:00pm"
9. "Sign-ups close on Aug 31 at 7:00pm"
10. Credit chip: "1 Meeting"
11. "Event Coordinator: <member name redacted>"
12. A numbered attendee list. Each line is: position number, member name, phone number.
    The list ran from 1 to 15 with a 16th empty slot.
13. "Manually add member"

## Admin Actions links (verbatim hrefs). None of these were opened.

| Label | href | why not opened |
|---|---|---|
| Complete event | ?action=eventcomplete&eventid=1152799 | "complete" awards credit to attendees |
| E-mail attendees | ?action=defineEmailFilters&eventid=1152799 | leads to sending mail |
| Text attendees | ?action=smsform&eventid=1152799 | leads to sending SMS |
| Edit event | ?action=eventedit&eventid=1152799 | opened, see below; it renders a form |
| Manage attachments | ?action=manageeventattachments&eventid=1152799 | file management |
| Delete event | ?action=eventdelete&eventid=1152799 | destructive |

## Fields the page proves the event record holds

title, start date and time, end time, location (free text), description, creator,
sign-up lock time, sign-up close time, one or more requirement credits with an amount and
a requirement name, an event coordinator, and a list of signed-up members.
