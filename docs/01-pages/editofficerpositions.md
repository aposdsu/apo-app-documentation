# Officer positions

> Summary: The list of offices the chapter has, each with an edit link, a privileges link
> and usually a delete link.
> Status: OBSERVED
> Read this if: you are modelling roles.
> Depends on: raw/pages/memberhome_action-editofficerpositions.md

**Route:** `memberhome.php?action=editofficerpositions`

## What it does

Lists the chapter's officer positions and, in a second table, its advisor positions. A
small form at the bottom adds one: a title of at most 75 characters and a choice of
officer, advisor, or both.

## What this chapter has

Eighteen officer positions (President, Academic Chair, Conference Chair, Equity &
Inclusion Chair, Fellowship Vice President, Fundraising Chair, Historian, Interchapter
Chair, Leadership Vice President, Membership Vice President, Philanthropy Chair, Pledge
Trainer, Public Relations Chair, Recording Secretary, Sergeant-At-Arms, Service Vice
President, Special Events Coordinator, Treasurer) and one advisor position (Chapter
Advisor).

## Two details that matter for the data model

**Some positions are protected.** President and Chapter Advisor are labelled "(Primary)"
and have no delete link. Everything else can be deleted. Your build should have the same
idea: a flag saying a row is built in and cannot be removed.

**A position with no privileges is a real state.** One row showed the warning "Missing
Privileges / This position doesn't have any privileges assigned!". Creating a position and
granting it privileges are two separate steps, and the site nags when the second one is
skipped. That is a nice touch worth copying.
