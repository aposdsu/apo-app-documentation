# Capture: memberhome.php?action=viewevents  (View Upcoming Events)

- URL: https://www.apoonline.org/alphadelta/memberhome.php?action=viewevents
- Captured: 2026-08-28 via get_page_text + read_page (no submission)

## Row shape

Each row is: a date block (three lines: month abbreviation, day number, weekday
abbreviation), the event title as a link, an optional attendance line, and one or more
credit chips.

The title link href is `?action=eventsignup&eventid=<id>`.

Examples of the exact strings, with event titles kept because they are chapter content,
not personal data:

```
AUG 28 FRI   Spontaneous Fellowships              1 | Fellowship Event
AUG 31 MON   Fall '26 Flyering!                   5 members are attending    0.75 | External Relations Credits
AUG 31 MON   Tomodachi Life: Living in APO | GBM #1   15 members are attending   1 | Meeting
AUG 31 MON   Open Forum #1: ...                   13 members are attending   1 | Open Forum Credit   1 | Leadership Credit
SEP 3  THU   RUSH: Service Night                  8 members are attending    1 | External Relations Credit   1 | Service Hour   1 | Philanthropy Hours
JAN 16 SAT   Region A & B Regionals 2-day Conference   2 | Interchapter Credits
MAR 6  SAT   Sectionals B1 & B2 Conference        (no credit chip shown)
```

Points this page establishes directly:
- One event can carry more than one credit chip, each naming a different requirement.
  Two examples above show two and three chips.
- The credit amount can be fractional (0.75) and can be more than one (2).
- The unit label is pluralised on the chip ("Interchapter Credits", "External Relations
  Credits") and singular when the amount is 1.
- The attendance line reads "N members are attending" or "1 member is attending", and is
  absent for some events.
- 45 events were listed, spanning AUG 28 2026 to MAR 6 of the following year, with no
  pagination control visible.
