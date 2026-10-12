# Capture: memberhome.php?action=managebrother&userid=<id>&chapterid=311&panel=account
# (Account Manager, one member's account panel)

- URL pattern: memberhome.php?action=managebrother&userid=<id>&chapterid=311&panel=account
- Captured: 2026-08-28 from one real member record. THE FORM WAS NOT SUBMITTED.
- ALL VALUES ON THIS PAGE ARE REAL PERSONAL DATA AND ARE NOT RECORDED HERE. Only the
  field names, types, lengths and option lists are recorded.

## Panel structure, verbatim tab labels

Top row: "Profile", "Attachments", "LEADS", "Engagement"
Second row, under the chapter name: "Account", "Records", "Awards", "Family", "Events"

## Section labels and read-only text, verbatim

- "View <first name>'s profile", "Change Profile Picture"
- "Member Information"
  - "National ID:" with visibility "Hidden (Staff Only)"
  - "Full Name:" with visibility "Anyone"
  - "Preferred First Name: (replaces your first name)" with visibility "Anyone"
  - "Maiden Name: (help appear in search results)" with visibility "Anyone"
  - "OFFICIAL Membership Status:" shown as static text, with visibility "Anyone"
  - "Login Status: Recently logged in on <date>" with visibility "Officers"
- "Education History / Share your alma mater and connect with other alumni across Alpha
   Phi Omega." with "Add education history"
- "Work Experience / Network with other members working in the same company or industry
   by adding your employment information." with "Add work experience"
- "Profile Information"
  - "Login E-mail:" visibility "Hidden (Staff Only)", plus "Manage Contact Preferences"
  - "Login Password: Reset Password"
  - "Contact E-mail:" visibility "Hidden (Staff Only)"
  - "Email Preference: Send all emails to my Login Email address. / Send all emails to my
     Contact Email address."

The three visibility words seen next to fields are "Anyone", "Officers" and
"Hidden (Staff Only)".

## FORM1, the profile form (post, 50 elements, submit named `edit`)

| name | type | max | notes |
|---|---|---|---|
| __csrf_magic | hidden | | <redacted> |
| userid | hidden | | which member |
| profile[memberNumber] | text | 75 | the "National ID" field |
| profile[visibility][4] | hidden | | visibility of memberNumber |
| profile[firstname] | text | | |
| profile[middlename] | text | | |
| profile[lastname] | text | | |
| profile[suffix] | text | | |
| profile[nickname] | text | | "Preferred First Name" |
| profile[maidenName] | text | | |
| profile[email] | text | 100 | login e-mail |
| profile[visibility][5] | hidden | | |
| profile[email_public] | text | 100 | contact e-mail |
| profile[visibility][6] | hidden | | |
| profile[notify_email] | radio | | values "0" and "60" |
| profile[473] | text | 100 | a numbered custom field |
| profile[visibility][473] | hidden | | |
| profile[phone] | text | 100 | |
| profile[visibility][7] | hidden | | |
| profile[campusaddress] | text | 255 | |
| profile[campusaddress2] | text | 100 | |
| profile[campusaddressCity] | text | 50 | |
| profile[campusaddressState] | text | 25 | |
| profile[campusaddressZipCode] | text | 10 | |
| profile[campusaddressCountry] | select-one | | 247 options |
| profile[visibility][8] | hidden | | |
| profile[homeaddress] | text | 255 | |
| profile[homeaddress2] | text | 100 | |
| profile[homeaddressCity] | text | 50 | |
| profile[homeaddressState] | text | | |
| profile[homeaddressZipCode] | text | 10 | |
| profile[homeaddressCountry] | select-one | | 246 options |
| profile[visibility][9] | hidden | | |
| profile[major] | text | 75 | |
| profile[visibility][10] | hidden | | |
| profile[gender] | select-one | | (empty), M=Male, F=Female, N=Non-binary |
| profile[pledgeclassterm] | select-one | | (empty), Spring, Summer, Fall, Winter |
| profile[pledgeclassyear] | text | 4 | |
| profile[visibility][12] | hidden | | visibility of pledge class |
| profile[gradclassterm] | select-one | | same four term names |
| profile[gradclassyear] | text | 4 | |
| profile[visibility][13] | hidden | | |
| profile[birth_month] | select-one | | 13 options |
| profile[birth_day] | select-one | | 32 options |
| profile[birth_year] | select-one | | 213 options |
| profile[visibility][16] | hidden | | |
| profile[aboutme] | textarea | 255 | |
| chapternumber[311] | text | 75 | a member number scoped to chapter id 311 |
| edit | submit | | |

Two points worth noting:
- Every visibility control is keyed by a small integer (4, 5, 6, 7, 8, 9, 10, 12, 13, 16
  and 473). The key 473 also appears as a profile field name, `profile[473]`, which
  suggests the site stores profile fields as numbered rows rather than as fixed columns,
  and that some fields are chapter-specific additions.
- `chapternumber[311]` is keyed by chapter id, so a member can hold a different member
  number in each chapter they belong to.

## FORM2, profile picture upload (post): __csrf_magic, userfile[file], submit

## FORM3, education history (post)

fields: __csrf_magic, action (hidden), userId (hidden), institution (text),
degreeLevel (radio, 6 values), degree (text), monthJoined (select, 12 months),
yearJoined (text), monthEnded (select, 12 months), yearEnded (text), city (text),
state (text), country (select)

## FORM4 exists on the page and was not read in detail; by its position it is the
work-experience form.
