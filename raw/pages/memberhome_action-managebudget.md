# Capture: memberhome.php?action=managebudget  (Chapter Budget)

- URL: https://www.apoonline.org/alphadelta/memberhome.php?action=managebudget
- Captured: 2026-08-28 via get_page_text and DOM read. Nothing was submitted.

## Table 1 headers, verbatim

"Officer | Budget Allocated | Total Expenses | Total Income | Budget Remaining"

One row per officer or advisor position, using the same 19 position names as the
transaction ledger filter. Every value on this chapter is $0.00.

## Table 2 headers, verbatim

"Budget | Budget Allocated | Total Expenses | Total Income | Budget Remaining"
with a "Create custom budget" link, and a "Grand Totals" row.

## Forms (post, never submitted)

- FORM1: __csrf_magic, budgetIdentifier (select-one), amount (text), submit.
  Header of its own small table: "Budget | Amount to Allocate".
- FORM2: __csrf_magic, title (text), budget (text), submit. This is the custom budget
  creator.

So a budget line is either tied to an officer position or is a free-standing named
budget, and both hold one allocated amount that expenses and income are measured against.
