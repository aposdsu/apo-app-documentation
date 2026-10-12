# Access log

> Summary: The audit trail. Who did what, to which record, and when. It is also the best
> single source of evidence about how the system behaves.
> Status: OBSERVED
> Read this if: you want to know why an audit log is worth building on day one.
> Depends on: raw/pages/memberhome_action-viewlog.md

**Route:** `memberhome.php?action=viewlog`

## The shape

Three columns: Performed by, Action, Date. The actor is written as a name followed by
their user id in square brackets. The action is a sentence with the affected records named
and their ids in brackets. The date is to the minute.

## The sentence templates

- Added Event: '&lt;title&gt;' [id] for &lt;date&gt; at &lt;time&gt;.
- Updated Event: '&lt;title&gt;' [id]
- Added '&lt;member&gt;' [id] to the '&lt;event&gt;' [id] event sign-up sheet.
- Added '&lt;member&gt;' [id] to the '&lt;event&gt;' [id] event sign-up sheet as a driver
  with &lt;N&gt; open seats.
- Removed '&lt;member&gt;' [id] from the '&lt;event&gt;' [id] event sign-up sheet.
- Created userProfilePhoto Media: '&lt;filename&gt;' [id]
- Cleared profile history.

## What the log taught us that no other page did

**A repeating event is stored as separate events.** Five entries, one second apart, same
title, five different event ids. So the repeat control on the event form creates many
records rather than one rule.

**Sign-ups are rows that get created and deleted,** often several times by the same person
in the same minute. That means the sign-up needs to be its own table with its own history,
not a flag on a membership.

**A sign-up can carry extra data.** One template records a member signing up as a driver
with a number of open seats.

## For your own build

Log the actor, the verb, the entity type, the entity id and a small JSON blob of detail.
Write the row in the same transaction as the change. The first question anyone asks when a
number looks wrong is "who did this", and if you did not log it on day one you cannot
answer it.
