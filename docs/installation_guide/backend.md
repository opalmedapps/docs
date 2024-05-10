# Installation for Development of the Entire Opal App Frontend & Backend

## Opal Frontend

Please note that to follow these instructions, you must have already installed the frontend (your installation's qplus folder).

## Opal Backend

During the installation, it's necessary to initialize test data in both the backend and db-docker. Firebase users must also be initialized by running `node ./initialize_users.js` within the listener container.

### Backend

Follow the Backend [`README`](https://gitlab.com/opalmedapps/backend) to set it up.

#### Setup Order

Initialize the backend project before setting up the listener. Use `python manage.py initialize_data` and `python manage.py insert_test_data OMI` to get the required tokens.

### Listener

make sure you have clone [the opal-listener repository](https://gitlab.com/opalmedapps/opal-listener) and check out its staging branch.

The listener can be set up and run one of two ways:

1. Using Docker (preferred way)

2. Direct installation (run using Node, not suggested)

#### Docker

To install the listener using Docker, you will be following the [Docker section of the listener README](https://gitlab.com/opalmedapps/opal-listener#installing-with-docker).
First start with the steps in this guide (e.g. "Create a Firebase Project" below), as they provide context for the requirements in the Docker instructions.
You may need to jump between the README and this guide as you go.

### Firebase

Firebase is essential for enabling communication between the app and the backend components, especially when the backend is deployed within a hospital network. Set up a personal Firebase project to integrate this functionality.

- The user applications [communicate via Firebase](index.md) with the _Opal PIE_.
  You are welcome to use another container engine.
  However, all the commands shown in our instructions are specific to `docker` and `docker compose`.

### Create a Firebase Project

Since Firebase is a Google product, if you have a Google account, you automatically have a Firebase account.
Log into Google and open the [Firebase Console](https://console.firebase.google.com/). Be aware that the steps below may change slightly as Firebase updates its UI.

_Note_: while setting up your project, make sure to always select the `us-central` region.
This will ensure that your installation supports the database's [URL scheme](https://firebase.google.com/docs/projects/locations#rtdb-locations).

Create a new Firebase project (you can skip this step and use an existing Firebase project if you already have one):

- Click on `+ Add project`.
- Give it a relevant Project name, such as `Opal Local` (you can edit the unique Project ID if you want to).
- Don't enable Google Analytics for this project.
- Click `Create project`.

In your Firebase project, click on `Database` in the left panel. Scroll down to `Realtime Database` and click `Create database`
(_DO NOT_ create a Cloud Firestore). In the popup "Security rules for Realtime Database", select "Start in test mode".
Then, navigate to the "Rules" tab of your new Realtime Database and enter the following:

```text
{
  "rules": {
    ".read": "auth.uid !== null",
    ".write": "auth.uid !== null"
  }
}
```

This configures your database to only be accessible by authenticated users. You can add more detailed rules later if desired.
Note that if you plan on connecting the registration-web-page to your local setup, the above rules won't work;
in that case, use the real rule set found in the listener repo under `/firebase/dev/database.rules.json`.
Find more information on Firebase rules [here](https://firebase.google.com/docs/rules).

#### Save your Firebase Configurations

Web configuration (for the frontend):

- Click on Settings (gear icon) in the left panel, then click on Project Settings.
- In the General tab, scroll down to Your apps and select the html `</>` icon (Web).
- Type `Opal Local` as the app nickname (don't enable Firebase Hosting).
- Click `Register app`.
- Copy and paste the code on the screen into a new text file. Call it `web_config.txt` and save it in your Opal installation's
  `firebase` folder (you will need information from this file later).

Private key (for the backend):

- Go back to the Project Settings page, and click on the tab `Service accounts`.
- In the `Firebase Admin SDK` tab, click `Create service account` (skip this step if a service account already exists).
- Scroll down and click on `Generate new private key`.
- Save the key in your installation's `firebase` folder. [Note: make sure that this file (and by extension your firebase folder)
  is not public. For example, never save this file in the xampp folder on your C: drive, or in public_html. Most normal document locations
  should be fine.]

Make sure to protect your private key; once you've downloaded it, you can't download it again, you can only generate a new one.

If you're setting up your listener using Docker, you'll need to copy the private key to another folder. See the listener README for details.

### Database

Follow the instructions in the [db-docker repository](https://gitlab.com/opalmedapps/db-docker) to set up your databases using Docker.
For the purpose of this installation, only OpalDB and QuestionnaireDB need to be fully set up.

Note: if you prefer to install the databases directly (without Docker), see the Reference section at the end of this document.

### Connect the Listener to the Database and to Firebase

At this point, you have all the pieces of your installation, and it's time to connect them together.
Connect the listener to the database and to Firebase by setting up its configuration file, copy `.env.sample`, as `.env`.

If you're setting up your listener using Docker, follow the remaining instructions in the listener README.
In particular, a Docker setup requires a different `FIREBASE_ADMIN_KEY` value than the one provided below.

[If you set up the databases without Docker, use the XAMPP and MAMP Default Credentials in the [Reference](#reference) section below, and replace both
`host.docker.internal` with `localhost`.]

- Open your `opal-listener` project. Copy the file `.env.sample` and paste it as `.env`.
- Fill in the following values:
    - `MYSQL_USERNAME`: "_The username you set up in the database step_",
    - `MYSQL_PASSWORD`: "_The password you set up in the database step_",
    - `MYSQL_DATABASE`: "OpalDB",
    - `MYSQL_DATABASE_QUESTIONNAIRE`: "QuestionnaireDB",
    - `MYSQL_DATABASE_PORT`: "_The port you set up in the database step (e.g. 3306)_",
    - `MYSQL_DATABASE_HOST`: "host.docker.internal",
    - `HOST`: "host.docker.internal",
    - `FIREBASE_ADMIN_KEY`: "_Absolute path to the json firebase admin key that you downloaded in your firebase folder,
    using forward slashes, not back slashes **OR** Value provided in the listener README for Docker setup_",
    - `DATABASE_URL`: "_This value can be found in the web_config.txt file in your firebase folder_",
    - `LATEST_STABLE_VERSION`: "0.0.1",
    - `FIREBASE_ROOT_BRANCH`: "dev3/A0",
    - _Leave all other variables blank by setting them to empty double quotes:_ `""`

### Connect the App to Firebase

Connect the app to firebase by setting up its configuration file, `opal.config.js`.

- Open your `qplus` project and navigate to `env/local/opal.config.js`. If this file doesn't exist, follow the instructions in
  the [environment setup README](https://gitlab.com/opalmedapps/qplus/-/blob/staging/env/local/README.md) to create it.
- Copy and paste the values from the `web_config.txt` file in your `firebase` folder to the `firebase` section of the `env/local/opal.config.js` file.

### Connect the Test User to Firebase and to the Database

You now need to register your test account in Firebase. The test account will already exist in your database,
but you'll have to register it in Firebase to be able to log in, since Opal uses Firebase's built-in authentication system.
You'll also need to link the Firebase authentication user to the database.

These steps are required for the app to successfully authenticate with Firebase in order to make requests to the listener.

Prerequisites:

1. You should have set up a Firebase project.

2. You should have set up the listener with its .env file. Make sure `FIREBASE_ADMIN_KEY_PATH` has been set to the path of an admin key file you downloaded.

3. The listener container should be running in Docker.

Steps:

1. In the Firebase Console, open your project and click on Authentication in the left menu panel.

2. Enable email and password authentication (don't enable any other forms of authentication).

3. Locate the listener entry in Docker Desktop (make sure it's running), and click on the child container to view its logs.

4. On the log page, go "Exec". (MacOS version)

5. Run: cd /app/src/firebase.

6. Run: node initialize_users.js.

7. You should see console output indicating that the test accounts were successfully created in Firebase.

### Run the Whole System

At this point, you have connected the entire system together. It's time to run it to see if it works.
Here's how to run your local copy of Opal:

- Make sure your database setup is running (Docker, or XAMPP/MAMP).
- Run the listener:
    - Docker: make sure your Docker container is running (in Docker Desktop, or according to the instructions in the listener README's Docker setup).
    - Direct installation: cd into the `listener` folder, and run `node server`. If you make any changes to the code or configurations in the listener, you'll need to stop it (CTRL+C) and restart `node server`.
- The listener's terminal (in Docker or otherwise) should print several lines of console output, then nothing. If it crashes or displays errors, ask an Opal team member for help.
- Run the app (qplus) by typing the following command in its terminal:

  ```JavaScript
  npm run start --env=local
  ```

  If you make any changes to the code, you don't need to restart the app (it will auto-reload and refresh for you).
- The app should open automatically in a browser.

If anything isn't working, first make sure that everything is running in the list above. It's possible that you forgot to run
one of the components, or that the listener crashed and you need to restart it. Also make sure that you followed all the above
setup steps correctly (especially concerning the configurations). If something still isn't working, reach out to an Opal team member
for help.

If everything appears to be running correctly, try logging in using the test account credentials:

```text
email: muhc.app.mobile@gmail.com
password: 12345Opal!!
hospital: McGill University Health Centre (MUHC)
security answer (depending on the question): red, guitar, superman, (first pet's name) dog or meg, bob, cuba
```

If it works, congratulations! You've successfully installed a local development environment of Opal.

If you'd like, you can try changing a value in the database (for example, changing a DiagnosisCode for
PatientSerNum 51 in the Diagnosis table, using one of the options from the DiagnosisCode table).
Then, simply log out and log back into the app, and watch your change appear!

### Clinical Notes (Optional)

Clincal notes are stored externally in the Opal system (not in OpalDB), which means that in order to access clinical notes, you will need to specify a path for them.
Without this path, trying to open a clinical note in Opal will cause the following error to be displayed:

```text
Error obtaining document from server
```

Setting up clinical notes is an optional step which isn't necessary unless you need to work directly with clinical notes.
If this is the case, you can set up dummy clinical notes as follows:

1. In your Opal `Installation` folder, create a sub-folder called `clinical-notes`, at the same level as `opal-listener`, i.e. as follows:

    ```text
    └─── Installation
              ├─── clinical-notes
              ├─── opal-listener
              ├─── qplus
              └─── ...
    ```

2. In your opal-listener, add the following value to the `DOCUMENTS_PATH` variable in `config.json`:

    ```text
      "DOCUMENTS_PATH": "<Path to your clinical-notes folder, using forward slashes, not back slashes, and ending in a forward slash>",
    ```

    **Important**: a final slash is required. Without it, you'll get errors.

3. In your OpalDB (viewed using HeidiSQL or similar), navigate to the `Document` table. The `FinalFileName` column contains the names of the pdf files
    associated with each document. For each clinical document that you'd like to simulate viewing in the app, add a pdf file (any file) to your
    `clinical-notes` folder, named to match the value in `FinalFileName`. It will then be visible in the app.

    To easily find the files that you'd like to add, you can print the serNum parameter passed to the `DocumentContent` request in the app.
    When you click on a document, this parameter will identify its `DocumentSerNum`, making it easier to find the document's row in the `Document` table.

If you need access to sample pdfs showing examples of real clinical notes, contact an Opal team member.

### Reference

The information below is provided as an additional reference.

#### XAMPP and MAMP Default Credentials

XAMPP

```text
HOST: localhost
PORT: 3306
USER: root
PASSWORD:
```

MAMP

```text
HOST: localhost
PORT: [3306|8889]
USER: root
PASSWORD: root
```

#### Direct Database Setup (Non-Docker)

Make sure you have installed XAMPP or MAMP. If you have MAMP, make sure to use MAMP and not MAMP Pro.

If using XAMPP (MySQL/MariaDB on Windows), configure MySQL/MariaDB to support [uppercase letters in table names](https://mariadb.com/docs/reference/mdb/system-variables/lower_case_table_names/). This is done by adding the following line under `[mysqld]`
in the file `my.ini`:

```text
lower_case_table_names=2
```

You can edit `my.ini` in XAMPP by opening the XAMPP Control Panel, and clicking on the button `Config` next to MySQL.

If you are using MAMP, you will need to change the port number that is being used. Open the preferences window as depicted [here](https://documentation.mamp.info/en/MAMP-Mac/Preferences/Ports/). Change the MySQL port to 3306.

Download a copy of the database files to your `database` folder (you should have been given access to these files for the purposes
of this installation). If you don't have access to these files, contact an Opal team member for help.
You should have two files: sql installation files for an OpalDB and a QuestionnairesDB, containing data from a test account.

Open the database files in a text editor capable of supporting large files (such as Notepad++). Search for the database name
`WaitRoomManagement`, and make sure that all lines referencing this database are commented out (unless your project specifically
involves working with appointment waiting times, in which case you will need access to the WaitRoomManagement database.
In this case, contact an Opal team member for help.). If they aren't commented out, either contact the Opal team member who gave you
the database file to let them know, or comment them out yourself. If you decide to comment them out yourself, comment out the entire
surrounding block. For example, in the code snippet below, you would comment out the entire "Step 3" `if` block:

```text
  ...
  set wsDS_Area = 'No';
  end if;
 end if;

 /*
 -- Step 3) If it is not a blood test and DS location only, then get the current location of the doctor
 if ((wsBloodTest = 'No') and (wsDS_Area = 'No')) then

  -- Return only the RC or DS location of the doctor
  -- Doctors may be assigned to two different rooms
  set wsReturnLevel =
   (SELECT Level
    FROM WaitRoomManagement.DoctorSchedule USE INDEX (ID_ResourceNameDayAMPM)
    WHERE ResourceName = wsDescription
     AND DAY = wsDayOfWeek
     AND AMPM = wsAMFM
    limit 1);

  -- If no location found, return N/A
  set wsReturnLevel = (IfNull(wsReturnLevel, 'N/A'));

 end if;
 */

 -- Step 4) Return the location
 set wsReturnHospitalMap = -1;
 ...
```

Launch XAMPP (open its Control Panel and click start on the MySQL option), or MAMP (open it and click on the start button).

Next, import the database using HeidiSQL or MySQL Workbench (see instructions below). Using phpMyAdmin is possible but not
recommended, as the files may exceed the maximum size or timeout length.

Using HeidiSQL:

- Configure a session to connect to your localhost (this will connect to MySQL running on XAMPP/MAMP):
  ![HeidiSQL localhost session: Network type = MySQL (TCP/IP); library = libmariadb.dll; hostname / IP = 127.0.0.1;
user = root, password = empty field, port = 3306, leave defaults everywhere else]
- Open the session.
- Click `File` > `Run SQL file...`.
- Run the OpalDB file saved in your `database` folder.
- When the import is done, click `Refresh` (round green arrow icon) in the top toolbar to see your new database appear in
  the left panel.
- Expand the database contents in the left toolbar and check that there is at least one table name containing a capital letter
  (e.g. AliasExpression, answerCheckbox). If not, the `lower_case_table_names` configuration is not set up correctly.
- If there were any issues with the import, you can right-click the database and click `Drop...` to delete the database
  permanently, then try importing it again.
- When this is done, repeat the steps above (starting with `File` > `Run SQL file...`) to import the QuestionnaireDB.

## Notes

- Please check the date below to make sure these instructions are up to date. If you are reading this much later,
  there is a chance things may have changed. Check with the developers of the project to make sure.

Author: Stacey Beard

Last Updated: 2024-05-08 by Stacey Beard and Shiqi Tan
