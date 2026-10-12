# Award-grant and password flows (2026-08-30)

> Reading only. No award was granted here (the direct-grant path was exercised separately
> and reverted, see self-flows-observed.md Flow B). No password was changed or reset, and
> no reset control was clicked. Vote-turnout percentages are aggregate counts, not PII.

## Granting an award — two paths that meet at one record

An award ends up on a member's profile as an award record (`addUserAwardRecord`,
verified reversibly in `self-flows-observed.md` Flow B). There are two ways the chapter
decides who gets one:

### Path A: direct grant (officer decides)
`?action=manageUserAwardRecords` (or the Awards tab of the Account Manager): pick an award,
a member, an optional subtitle, and a date; submit posts to `addUserAwardRecord`. Remove via
the row's trash control (`deleteUserAwardRecord`). Five Distinguished Service Keys are
built in; chapter-defined awards are added on `?action=manageUserAwards` ("Define Chapter
Awards").

### Path B: chapter vote (a ballot)
`?action=manageballot` ("Manage Award Voting"), a five-step process (read live, polls
CLOSED on this chapter):
1. **Define Chapter Awards** — enter the awards the chapter gives.
2. **Setup Ballot** — choose which awards are voted on, by which account types, who is
   eligible for each award, and whether write-ins are allowed. (Setup is behind a button,
   not a link.)
3. **Open / Close Polls** — set a "date to close polls", or "Close Polls Now".
4. **View Results** — "Percent of members who have voted", broken down by account type
   (e.g. Actives 0 of 8, Alumni 0 of 517, Officers 0 of 16). Voting is anonymous with one
   submission per person (release note, Oct 2020).
5. **Clear all votes and reset results** — "Clear Votes and Reset Poll" clears the votes but
   keeps the ballot setup.

So the ballot decides the winners; the award is then recorded on each winner via the
direct-grant form (Path A). For the rebuild: an Award entity, an AwardRecord (member +
award + date + subtitle), and, if wanted, a Ballot (awards x eligible account types x
write-ins x open/close dates) with anonymous one-per-person votes.

## Password change and reset — three entry points (none exercised)

1. **In-app change (self, logged in):** `?action=changepassword` shows Login Email (with a
   separate "change" control), Current Password, New Password, New Password (again). It
   requires the current password. Fields: `__csrf_magic`, `email`, `oldpass`, `newpass1`,
   `newpass2`. The same page has "Log in with: Connect / Disconnect" for linking a Google or
   Facebook identity, so an account can have a password and/or a social identity. Read, not
   submitted.
2. **Self-service forgot password (can't log in):** the login page (shown when logged out)
   carries a "forgot password?" link. The standard shape is: enter your e-mail, a reset
   link/code is sent. The form behind the link was not opened or submitted (submitting would
   send a reset e-mail), and it is not reachable while logged in (login.php redirects).
   Recorded as observed-to-exist; the form fields are not read.
3. **Officer-initiated reset (for another member):** `?action=resetPassword` appears as a
   link in a member's Account Manager and "would send or force a password reset for the
   member" (`raw/pages/managebrother-all-panels.md`). NOT opened, because clicking it would
   send/force a reset. Recorded as observed-to-exist only.

The password value is never handled, typed, or reset in this documentation. The three
entry points are: the member changes it themselves with their current password; the member
who is locked out uses forgot-password; an officer forces a reset for someone else.
