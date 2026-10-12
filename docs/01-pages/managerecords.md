# Everyone's progress on one requirement

> Summary: An officer's table of every member's progress toward one requirement, inside a
> date window that defaults to the current term.
> Status: OBSERVED
> Read this if: you are building the progress screens.
> Depends on: raw/pages/memberhome_action-managerecords_reqid-3.md

**Route:** `memberhome.php?action=managerecords&reqid=<requirement id>`

## What it shows

A report header, verbatim: "REPORT OF SERVICE HOURS / Date of Report: August 28th, 2026 /
Begin Date: June 20th, 2026 / End Date: December 19th, 2026". The two dates are the current
term and can be changed with a small form.

Then a table with one row per member. For a requirement split into categories there is a
group of three columns for the requirement as a whole and for each category:

`Member | Total Service Hours (Internal, External, Total) | Service to the Campus (Internal, External, Total) | ...`

Each Total cell reads "&lt;earned&gt; of &lt;goal&gt;", for example "0 of 15". The goal is
looked up from the member's account type.

## What it tells you about the design

**Progress is a query, not a stored number.** The date range is a free choice, and the
page recomputes for whatever range you give it. A stored per-member total could not answer
an arbitrary window.

**Internal and external are counted separately all the way through.** The requirement sets
a maximum that may come from outside the chapter, so the report has to show both.

## For your own build

Start with a database view, exactly like the `requirement_progress` view in the proposed
schema. Only cache totals if the page is measurably slow, and measure before you decide.
