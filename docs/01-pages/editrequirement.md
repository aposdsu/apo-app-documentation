# Editing a requirement

> Summary: Where a chapter writes its bylaws into the system: labels, optional categories,
> and a target for every account type with a separate cap on outside work.
> Status: OBSERVED
> Read this if: you are designing the requirement tables.
> Depends on: raw/pages/memberhome_action-editrequirement_reqid-3.md,
> raw/pages/memberhome_action-editrequirement_reqid-865.md

**Route:** `memberhome.php?action=editrequirement&reqid=<id>`

## The fields

| On screen | Field | What it holds |
|---|---|---|
| Event Type Label | text_what | "Service Project", at most 50 characters |
| Event Type + Units Label | text_unit | "Service Hour", at most 25 characters |
| categories? | isSplit | whether the requirement has sub-parts |
| Hours or Percentage | isPercentage | count a number, or a share of all events of this type |
| outside credit? | isExternal | whether work done outside the chapter counts |
| the grid | goal[type][internal] and goal[type][external] | the target, and the most that may come from outside |

## The grid is the interesting part

There is one row per account type, fourteen on this chapter, and two boxes in each row.
The help text says a target of "0" hides the progress bar from members of that type.
Targets can be fractional: this chapter asks Active members for 15 service hours and
Half-Active members for 7.5.

When a requirement is split into categories, the grid repeats once per category. Service
Project is split four ways (Service to the Campus, Community, Nation, Fraternity), so its
form carries 4 x 14 x 2 = 112 extra boxes.

## The correction this page forced

There is no term on this form. A requirement is not written per semester; it is written
once and the progress screens count credits inside a date window. Our first schema put a
`term_id` on `requirement`, which would have made a chapter retype every rule twice a year.
That is now fixed.

## A detail worth copying

Built-in requirements cannot be relabelled. On requirement 3 the two label fields are
plain text on the page instead of input boxes, while on chapter-created requirement 865
they are editable. A record that the system depends on should not be freely renameable.
