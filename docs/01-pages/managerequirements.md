# Requirements

> Summary: The list of the chapter's requirements. The page is headed "Event Type",
> because in this product a requirement and an event type are the same record.
> Status: OBSERVED
> Read this if: you are modelling requirements or events.
> Depends on: raw/pages/memberhome_action-managerequirements.md

**Route:** `memberhome.php?action=managerequirements`

## What it does

Two tables. The first, headed "Event Type", lists the chapter's requirements. The second,
headed "Point Tracker", lists simpler counters with no goals; this chapter has none.

## What this chapter has

Meeting (id 2), Service Project (3), Academic (1507), Chair Credit (925), Committee Credit
(944), Dues Credit (2234), External Relation (1511), Fellowship Event (865), Fundraising
Credit (867), Interchapter Credit (912), Leadership Credit (866), Open Forum (1605),
Philanthropy (2236), Philanthropy Hour (2164), Required Event (2130), Special Fellowship
(937), Training Credit (2377), and Dues Requirement (id 1).

Meeting, Service Project and Dues Requirement have no delete link, so they are built into
the product. The other fifteen were created by the chapter.

## The thing to notice

The low ids (1, 2, 3) are the built-in ones and the high ids (865 and up) are
chapter-made. That, plus the "Event Type" heading, plus the officer dashboard link that
reads "create event type and corresponding requirement progress bar", is what shows the
two concepts are one record.

For your own build, keep them apart. Merging them is why this product has an event type
called "Dues Requirement".
