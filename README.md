# nps_service

### Background

Service that allows tracking of NPS related to touchpoints in user journey.

#### Saving Data
- Get Authentication name and password
- Make post request to `/api/v1/nps` with the following parameters
  - score (between 0 and 10)
  - touchpoint (string, eg. realtor_feedback)
  - respondent_class (string: eg. seller)
  - respondent_id (the unique ID representing the respondent)
  - object_class (string: realtor)
  - object_id (the unique ID representing the realtor)

- The respondent has completed all the steps from A
- The respondent opens the email again but this time clicks on "2"
- The service receives same params as A except the score which is now 2
- The service overwrites the previous data, storing the new score "2" for these incoming params.

#### Getting data
- Get Authentication name and password
- Make a GET request to `/api/v1/nps` with the following parameters
  - touchpoint (required)
  - respondent_class (optional)
  - object_class (optional)
