# Creating an event

> Summary: The biggest form on the site, about sixty fields. Most of it is scheduling and
> visibility; the part that matters to the data model is the repeating "Requirement Credit"
> group.
> Status: OBSERVED
> Read this if: you are designing the event tables.
> Depends on: raw/pages/memberhome_action-eventcreate.md

**Route:** `memberhome.php?action=eventcreate`, optionally with `&reqid=<id>` to start
with one credit filled in.

## What the form collects

- **When.** Start date and time, end time, an all-day flag, optional shifts, and an
  optional repeat rule with a "repeat every N" and an until date.
- **Where.** A location as free text, with hidden latitude and longitude fields.
- **What it earns.** One or more credit rows. Each is an amount, a requirement (and
  category, where the requirement is split), and a choice of "per shift" or "per event".
  The button reads "+ add another credit".
- **Sign-ups.** Three separate moments: when sign-ups open, when they lock, and when they
  close. A maximum number of attendees, blank for no limit. A "Require Ride" option.
- **Who runs it.** Up to two coordinators, or "let anyone volunteer". Coordinators can be
  given a bonus number of units toward a requirement of their own.
- **Who sees it.** Six levels, from "Only officers of Alpha Delta" through the chapter and
  the region to "Public to the Internet". A separate six-level setting for who may sign
  up, and a five-level setting for when the attendee list becomes visible.
- **Grouping.** An event can join an "Event Group" so a semester-long series counts as one
  event.

## The two facts that change the data model

**Credits are a list.** One event in this chapter awards three different credits at once.
So the link between events and requirements is its own table, not a column.

**A repeating event is not one record.** The access log shows five events created one
second apart, same title, five different ids. The repeat rule is a convenience in the
form, not a stored rule.

## What a single chapter should cut

The six visibility levels exist because the vendor serves many chapters, a region and a
national office. For one chapter, three are enough: officers only, members, public.
Shifts, mobile check-in, ride matching and cross-chapter invitations are all real
features, and all of them can wait.
