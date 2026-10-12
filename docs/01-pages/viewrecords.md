# A member's own record

> Summary: One member's credits for one requirement, with four time windows and a form
> that adds a credit by hand.
> Status: OBSERVED
> Read this if: you are building the member-facing progress page, or the manual credit
> entry.
> Depends on: raw/pages/memberhome_action-viewrecords_reqid-3.md

**Route:** `memberhome.php?action=viewrecords&reqid=<id>&userid=<id>&filter=<window>`

## The four windows

`filter=semester` (labelled "this term"), `filter=academicYear`, `filter=year`
("calendar year"), `filter=all` ("all time"). The current window's dates are printed next
to the links, for example "6/20/26 - 12/19/26".

## The manual entry form

Labelled "Add Service Hours". It sends:

| Field | What it is |
|---|---|
| userid | which member |
| title | a name for the work, at most 100 characters |
| date | when it happened, defaulting to today |
| units | how much, at most 5 characters |
| requirementCategoryId | which category, when the requirement is split |
| isExternal | 0 for a chapter event, 1 for outside work |

**This form sends no event id.** That is the clearest evidence on the whole site that a
credit is its own record and does not need an event behind it.

The radio labels are worth quoting: "Internal Event (chapter hosted)" and "External Event
(service projects completed outside of the chapter)".

## One exception

Meeting credit cannot be typed in. The Account Manager
(`raw/pages/memberhome_action-managebrother_panel-records.md`) says: "To add meeting credit you
will need to either log a past meeting or create a new meeting on the calendar and add this
member to the attendee list." So the product does gate manual entry on some requirements.
