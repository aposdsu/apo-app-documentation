# Account types

> Summary: The chapter's own list of membership categories, each mapped to one of six
> national statuses, each with its own privilege grid.
> Status: OBSERVED
> Read this if: you are modelling membership.
> Depends on: raw/pages/memberhome_action-managestatuses.md

**Route:** `memberhome.php?action=managestatuses`

## What it does

It lists every account type the chapter uses and lets an admin add more. Ten come with
the product. Four on this chapter were made locally, under the heading "Custom Local
Account Types (Alpha Delta Only)".

## The table

Columns: Account Type, Membership Status, Local Members, At Cost?, Actions.

| Account type | Maps to | Members |
|---|---|---|
| Prospect | Prospect | 0 |
| Officer | Active | 16 |
| Active | Active | 8 |
| Potential New Member | PNM | 0 |
| Associate | Active | 19 |
| Advisor | Alumni | 5 |
| Alum | Alumni | 517 |
| Honorary | Alumni | 0 |
| Inactive | Inactive | 1 |
| Deceased | Deceased | 0 |
| Bad Standing (local) | Active | 11 |
| Leave of Absence (local) | Active | 12 |
| Half-Active (local) | Active | 0 |
| System (local) | Inactive | 1 |

## Two things worth noticing

**"Officer" is an account type, not just a job.** The system moves people into it when
they take an office and back to "Active" when they leave. That is a design mistake to
avoid; see `docs/04-system-design/02-auth-and-permissions.md`.

**The "At Cost?" column is the vendor's billing, not the chapter's.** It marks which
account types the chapter pays for. Ignore it entirely in your own build.

## What to take from it

The two-level idea is worth copying: a small fixed list that the national organisation
recognises, and a chapter-defined list on top of it. It is what lets a chapter invent
"Leave of Absence" without anyone changing code.
