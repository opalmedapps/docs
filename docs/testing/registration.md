# Testing the Registration Process

!!! note
    The following instructions concern the legacy registration process (i.e., before the User-Separation Project).

The complete registration process consists of *opalsignup* (for QR code generation), *registration-web-page* (for a user to create their Opal account) and *opal-listener* (to process requests from the web page).

!!! note
    *opalsignup* will be moved to the Django-based backend as part of UPS. See QSCCD-160.

## Generate QR code

In order to generate QR code `opalsignup` needs to communicate to the hospital ADT system via the OIE (or a mock thereof) to find the patient record.

One way would be to use *SOAPUI* to launch a `MockService`. An easier alternative would be to make a small change in *opalsignup* and always return the expected JSON response when searching for an MRN/RAMQ (instead of calling the a webservice).

Change `php/patient/searchPatientByMrns.php` and change the content to the following:

```php title="searchPatientByMrns.php"
<?php

include_once('patient.inc');

$json = file_get_contents($abspath . 'mrn.json');

// Decode json to variable
$response = json_decode($json, true);
print json_encode(array($response)); // return response

?>
```

Add `mrn.json` to the root of the project with the following contents:

```json title="mrn.json"
{
    "alias": null,
    "birthPlace": "MX16",
    "birthDt": "1962-12-27 00:00:00.000",
    "fatherFirstName": "NIL",
    "fatherLastName": "NIL",
    "firstName": "PRODRX",
    "height": "150.0",
    "heightUnit": "CM",
    "homeAddCity": "Hudson",
    "homeAddPostalCode": "J0P 1A0",
    "homeAddProvince": "PQ",
    "homeAddress": "456 STEEPLECHASE ROAD.",
    "homePhoneNumber": "(514)123-1234",
    "lastName": "TEST RVH",
    "maritalStatus": "Married",
    "motherFirstName": "NIL",
    "motherLastName": "NIL",
    "mrns": [
        {
            "active": true,
            "lastUpdate": "2020-10-09 00:00:00.000",
            "mrn": "9999994",
            "mrnType": "MR_PCS"
        },
        {}
    ],
    "primaryLanguage": "EN",
    "ramqExpDate": "+87543-01-25 00:00:00.000",
    "ramqNumber": "TESP62622718",
    "sex": "Female",
    "spouseFirstName": null,
    "spouseLastName": null,
    "workPhoneNumber": "(514)934-1934",
    "motherMaidenName": null,
    "weight": "66.0",
    "weightUnit": "KG"
}
```

Now, when you search for a patient, select *Royal Victoria Hospital* and enter *9999994* as the MRN.

This should give you a search result for which you can generate a code for.

## Register account

Now you can open the registration web site locally (while the listener is also running) and enter the resulting code and RAMQ (*TESP62622718*).

### Dealing with an expired registration code

After a few days the registration code automatically expires. To enable the same registration code again you can change its status from `Expired` to `New` in `registerdb.registrationcode`.

??? info "SQL Command"

    ```sql
    UPDATE `registrationcode` SET `Status` = 'New' WHERE `ID` = '1';
    ```

### Registering again

If you want to redo the process you don't need to generate a QR code again. You can:

* Change the code's status in `registerdb.registrationcode` to `New`.
* Delete the security questions of the patient/user.
* Delete the Firebase account
