# Capture: memberhome.php?action=editchapterinfo  (Chapter profile)

- URL: https://www.apoonline.org/alphadelta/memberhome.php?action=editchapterinfo
- Captured: 2026-08-28. THE FORM WAS NOT SUBMITTED. Values not recorded.

## On-screen labels, verbatim, in order

"Date Established", "Date Reestablished", "Institution", "E-mail", "Address 1",
"Address 2", "City", "State", "Zip", "Phone", "Country",
"Date of Last Initiation  This field is auto-updated by the system",
"Date Last Member Joined  This field is auto-updated by the system", "or cancel"

## Form (post)

| name | type | max |
|---|---|---|
| __csrf_magic | hidden | |
| chapterid | hidden | |
| dateEstablished | text | 255 |
| dateReestablished | text | 255 |
| chapterinfo[1] | text | 100 |
| chapterinfo[2] | text | 100 |
| chapterinfo[3] | text | 100 |
| chapterinfo[4] | text | 100 |
| chapterinfo[5] | text | 100 |
| chapterinfo[6] | text | 100 |
| chapterinfo[7] | text | 100 |
| chapterinfo[8] | text | 100 |
| chapterinfo[9] | select-one (246 country options) | |
| chapterinfo[20] | text | 255 |
| chapterinfo[21] | text | 255 |
| (unnamed) | submit | |

Matching the labels to the field order, chapterinfo[1] through chapterinfo[9] are
Institution, E-mail, Address 1, Address 2, City, State, Zip, Phone, Country, and
chapterinfo[20] and [21] are the two auto-updated dates.

The important structural point is that chapter attributes are stored under numeric field
ids, exactly like member profile attributes (`profile[473]` on the Account Manager page).
That is the signature of a generic "field id and value" table rather than one column per
attribute.
