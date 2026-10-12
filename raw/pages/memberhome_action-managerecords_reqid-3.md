# Capture: memberhome.php?action=managerecords&reqid=3  (officer view of everyone's Service Hours progress)

- URL: https://www.apoonline.org/alphadelta/memberhome.php?action=managerecords&reqid=3
- Captured: 2026-08-28 via DOM table/form read. MEMBER NAMES NOT RECORDED.

## Report header block (table 0), verbatim

"Alpha Phi Omega Alpha Delta Chapter | REPORT OF SERVICE HOURS |
 Date of Report: August 28th, 2026 | Begin Date: June 20th, 2026 | End Date: December 19th, 2026"

The Begin Date and End Date match the term boundaries configured on
`?action=setterm` (semester month/day pairs 12/20 and 6/20), so the default reporting
window is the current term.

## Progress table (table 1) column headers, verbatim, in order

Member | Total Service Hours | Service to the Campus | Service to the Community |
Service to the Nation | Service to the Fraternity

and beneath those, a repeating triple for each of the five groups:

Internal | External | Total   (x5)

39 rows. Each data row has 16 cells. A sample row's numeric cells read:
`0 | 0 | 0 of 15 | 0 | 0 | 0 of 0 | 0 | 0 | 0 of 0 | 0 | 0 | 0 of 0 | 0 | 0 | 0 of 0`

So the Total cell is formatted "<earned> of <goal>". The goal 15 matches the
`goal[2][internal]` value of 15 on the requirement edit form for reqid 3
(raw/pages/memberhome_action-editrequirement_reqid-3.md).

## The member name cell links to

`?action=managebrother&userid=<id>&chapterid=311&panel=records&reqid=2&filter=custom&startdate=<unix>&enddate=<unix>`

Example seen on `?action=managerecords&reqid=2`:
userid=121225, chapterid=311, panel=records, reqid=2, filter=custom,
startdate=1781938800, enddate=1797753599. The two timestamps are Unix seconds and
correspond to the term window shown in the report header.

## Two filter forms on the page (both GET, neither submitted)

FORM1: hidden `action=managerecords`, hidden `chapterId=311`, select `reqid` with 17 options.
FORM2: hidden `action=managerecords`, hidden `reqid=3`, text `startdate` = 6/20/2026,
       text `enddate` = 12/19/2026, submit labelled "Update".
