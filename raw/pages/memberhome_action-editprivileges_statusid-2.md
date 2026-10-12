# Capture: memberhome.php?action=editprivileges&statusid=2  (privileges of account type "Active")

- URL: https://www.apoonline.org/alphadelta/memberhome.php?action=editprivileges&statusid=2
- Captured: 2026-08-28 via get_page_text + DOM form read (no submission)
- statusid 2 = account type "Active" per raw/pages/memberhome_action-managestatuses.md

Two-column radio grid. Column headers on every section: "Allow" and "Disallow".
For each row the DOM contains two radios; the FIRST radio in DOM order sits in the
"Allow" column and the SECOND in the "Disallow" column. `*` marks the radio that was
already selected when the page loaded.

## Section: "Event Privileges | Allow | Disallow"

| Label on screen | Field name | Allow column sends | Disallow column sends | Selected |
|---|---|---|---|---|
| View chapter/group events | priv[hideChapterEvents] | false | true | Allow |
| Create an event | priv[createevent] | true | false | Disallow |
| Sign up for an event | priv[rsvpevent] | true | false | Allow |
| View attendees for an event | priv[disallowviewrsvp] | false | true | Allow |
| Edit event information as Event Coordinator | priv[cooredit] | true | false | Allow |
| Complete event as Event Coordinator | priv[coorcomplete] | true | false | Disallow |
| Send Text (SMS) to event attendees as Event Coordinator | priv[eventsms] | true | false | Allow |

## Section: "Access Privileges | Allow | Disallow"

| Label on screen | Field name | Allow column sends | Disallow column sends | Selected |
|---|---|---|---|---|
| View roster and profiles of other members | priv[hideMembers] | false | true | Allow |
| Post on the blog | priv[postblog] | true | false | Disallow |
| Upload photos to photo albums | priv[postimage] | true | false | Allow |
| Manage photos and photo albums | priv[managephotos] | true | false | Disallow |
| View meeting minutes | priv[hideChapterMinutes] | false | true | Allow |
| Manage meeting minutes | priv[adminminutes] | true | false | Disallow |
| View budget and transactions | priv[viewbudget] | true | false | Disallow |
| View anyone's requirement progress | priv[hideprogress] | false | true | Allow |
| View family lineage | priv[hidefamily] | false | true | Allow |
| Edit own family lineage | priv[ownfamily] | true | false | Disallow |
| Send feedback to officers using the Comment Form | priv[commentform] | true | false | Disallow |
| Send Bulk Emails | priv[bulkemail] | true | false | Disallow |
| Send Bulk Text (SMS) Messages | priv[bulksms] | true | false | Disallow |
| View chapter/group files in the File Manager | priv[hideChapterFiles] | false | true | Allow |
| Upload files to the File Manager | priv[uploadfile] | true | false | Allow |
| View Alumni Directory | priv[hideAlumniDirectory] | false | true | Allow |

## Section: "Record Privileges (not recommended) | Allow | Disallow"

Labels are all of the form "Log their own: Internal <requirement name>". They appear in
alphabetical order by requirement name, and the DOM field order matches exactly:

| Label on screen | Field name | Allow column sends |
|---|---|---|
| Log their own: Internal Academic Credits | priv[req1507] | true |
| Log their own: Internal Chair Credits | priv[req925] | true |
| Log their own: Internal Committee Credits | priv[req944] | true |
| Log their own: Internal Dues | priv[req2234] | true |
| Log their own: Internal External Relations Credits | priv[req1511] | true |
| Log their own: Internal Fellowship Events | priv[req865] | true |
| Log their own: Internal Fundraising Credits | priv[req867] | true |
| Log their own: Internal Interchapter Credits | priv[req912] | true |
| Log their own: Internal Leadership Credits | priv[req866] | true |
| Log their own: Internal Meetings | priv[req2] | true |
| Log their own: Internal Open Forum Credits | priv[req1605] | true |
| Log their own: Internal Philanthropy Credits | priv[req2236] | true |
| Log their own: Internal Philanthropy Hourses | priv[req2164] | true |
| Log their own: Internal Required Events | priv[req2130] | true |
| Log their own: Internal Service Hours | priv[req3] | true |
| Log their own: Internal Special Fellowships | priv[req937] | true |
| Log their own: Internal Training Credits | priv[req2377] | true |

There is no `priv[req1]` row in this section. req1 is "Dues & Fees" in the Records
navigation menu (raw/pages/memberhome.md).

## Form (read only, never submitted)

- action: ?action=updateprivileges
- method: post
- hidden fields: __csrf_magic (<redacted>), statusid = 2
- page also shows "or cancel"
