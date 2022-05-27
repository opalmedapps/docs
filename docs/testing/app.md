# App

The assumption is that you already have your own Firebase project set up for testing purposes. This includes the config object with the values for this project.

Once you added an account to your Firebase project, you need to update your local database with the correct email and Firebase UID.

1. Change `Email` in table `Patient`

    ??? info "SQL command"

        ```sql
        UPDATE `Patient` SET `Email` = 'new@email.info' WHERE `PatientSerNum` = '51';
        ```

2. Change `Username` in table `Users` to Firebase UID of your Firebase user

    ??? info "SQL command"

        ```sql
        UPDATE `Users` SET `Username` = 'FirebaseUUID' WHERE `UserTypeSerNum` = '51';
        ```

This ensures that the app can successfully communicate with the listener.
