# Term dates

> Summary: Two dates that decide what "this term" means everywhere in the system. The
> smallest form on the site with the largest effect.
> Status: OBSERVED
> Read this if: you are modelling terms.
> Depends on: raw/pages/memberhome_action-setterm.md

**Route:** `memberhome.php?action=setterm`

## What it collects

A choice between "Semester System" and "Quarter System", then a month and a day for the
start of each term. A semester chapter fills in two pairs; a quarter chapter fills in four.

This chapter is on semesters, with term starts on December 20 and June 20.

## What it does not collect

There is no term name, no year, and no list of past terms. The product does not store a
row per semester at all. It stores the recurring boundaries and works out the current
window from today's date.

You can see the result on other pages: the progress report header reads "Begin Date: June
20th, 2026 / End Date: December 19th, 2026", and the officer dashboard says "December 19th
marks the end of current term and the beginning of next."

## Why this matters more than it looks

Changing these two dates changes every progress bar, every default report window, and what
counts as "this term" for the whole chapter, retroactively. It is the highest-risk form on
the site and it has no warning on it.

## What to build instead

Keep a real `term` table with a name, a start date and an end date, generated from the
chapter's calendar setting. Named rows can be joined against, corrected when a term starts
late, and referenced by a membership row. Computing the window from two numbers on every
page cannot do any of that.
