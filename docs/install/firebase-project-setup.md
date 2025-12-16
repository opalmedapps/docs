<!--
SPDX-FileCopyrightText: Copyright (C) 2025 Opal Health Informatics Group at the Research Institute of the McGill University Health Centre <john.kildea@mcgill.ca>

SPDX-License-Identifier: CC-BY-SA-4.0
-->

# Firebase project setup

The user applications [communicate via Firebase](../development/architecture/index.md#communication-between-user-applications-and-the-opal-pie) with the _Opal PIE_.
You need your own Firebase project so that your app can communicate with the backend components.

!!! note

    Firebase is a Google product.
    Therefore, you need a Google account to be able to use Firebase.

## Create a new Firebase project

1. Open the [Firebase Console](https://console.firebase.google.com)
1. Click on "Create a new Firebase project"
1. Give it a relevant project name, such as "Opal Local"
1. Uncheck "Enable Google Analytics for this project" and other options that are proposed to you
1. Click "Create project"

The "Authentication" and "Realtime Database" features are needed for communication between the apps and backend components.
Follow the instructions below to enable and configure these features.

## Create a new Realtime Database

1. In the left panel of your newly created Firebase project, expand "Build" and click on "Realtime Database".
1. Click "Create Database"
1. On the second step of "Set up database" (Security rules), select "Start in test mode".

!!! note Security rules

    This configures your Realtime Database to be accessible to anyone for 30 days.
    It is also possible to restrict access to authenticated users only by specifying the condition as `auth.uid !== null`.
    However, not all features will work.
    The rules in use by the Opal solution can be found in the [listener project](https://github.com/opalmedapps/opal-listener/blob/main/firebase/database.rules.json).
    See the [instructions on how to deploy them](https://github.com/opalmedapps/opal-listener/blob/main/docs/source/firebase-rules.md) to your project or copy-and-paste them into your project's rules.

See also the Firebase documentation on [Firebase Security Rules](https://firebase.google.com/docs/rules).

## Enable email and password authentication

1. In the left panel, expand "Build" and click on "Authentication"
1. Click on "Get started"
1. Choose "Email/Password" as the sign-in provider
1. Enable "Email/Password" and click "Save"

See also the Firebase documentation on [Firebase Authentication](https://firebase.google.com/docs/auth).

## Retrieve the Firebase project configurations

Retrieve the client configuration for browser and Android apps:

### Browser client configuration

1. Click on the settings icon (gear) next to "Project Overview"

1. Click on "Project Settings"

1. In the "General" tab, under "Your Apps", click the "\</>" icon

1. Choose an app nickname, such as "Opal Local"

    You can also enable "Firebase Hosting" at this time if you are planning to use this project for production or intend to test the password reset feature in the app.

1. Click "Register app"

1. Copy the code and save it somewhere for later

### Mobile app client configuration

1. Go back to the "Project Settings" page
1. In the "General" tab, under "Your Apps", click the Android icon
1. Choose an Android package name
1. Click "Register app"
1. Download the `google-services.json` file and save it somewhere for later

!!! question "Do I also need to add an iOS app?"

    You do not need to add it if you are only building the iOS app.
    The iOS app is reusing the `google-services.json` file during the build.

    However, if you intend to use [Firebase App Distribution](https://firebase.google.com/docs/app-distribution) to distribute your mobile app to testers, you will need to register an iOS app as well.

    1. Go back to the "Project Settings" page
    1. In the "General" tab, under "Your Apps", click the iOS icon
    1. Provide the Apple bundle ID of your app
    1. Click "Register app"

### Service account

Retrieve the private key for the admin SDK:

1. Go back to the "Project Settings" page and click on the "Service accounts" tab
1. Click on "Generate new private key" and then "Generate key"
1. Download the file somewhere safe on your machine for later

See also the Firebase documentation on [Admin SDK Authentication](https://firebase.google.com/docs/database/admin/start).

## Restrict permissions

During the above set up, Firebase creates a service account and API keys for you.
By default, these have permissions that are more permissive than what is needed.
Therefore, we strongly recommend to restrict their permissions, especially for production environments.

### Restrict service account permissions

By default, Firebase creates a service account and API keys.
The service account likely has more permissions than are needed.
We recommend to restrict the permissions as much as possible.

Go to the [Service Accounts in Google Cloud](https://console.cloud.google.com/projectselector2/iam-admin/serviceaccounts) and select your Firebase project, then:

1. Click on the name of the service account that was created for you
1. Go to "Permissions" and click on "Manage access"
1. Update the assigned roles to match the following roles:
    - _Firebase Authentication Admin_
    - _Firebase Cloud Messaging Admin_
    - _Firebase Realtime Database Admin_
    - _Firebase Rules Admin_
1. Click "Save"

### Restrict API keys

When registering apps on your Firebase project, Firebase automatically creates API keys.
These should be further restricted.

!!! question "Can new API keys be created instead?"

    This is generally possible.
    However, as part of the set up you will need to get a `google-services.json` file.
    When this file is retrieved, Firebase automatically creates corresponding API keys.

Go to the [API Credentials in Google Cloud](https://console.cloud.google.com/apis/credentials) and select the corresponding Firebase project.

#### Browser key

1. The browser key should have a name like "Browser key (auto created by Firebase)"

1. Click on its name to edit it

1. Under "Application restrictions", choose "Websites"

1. Add the following websites at a minimum to allow mobile app users to access this project

    - `app://localhost`
    - `http://localhost`
    - `https://<your-firebase-project-id>.firebaseapp.com`

    You should also add the base URL of your registration and web app to this list.

1. Under "API Restrictions", choose "Restrict key"

1. Choose the following APIs

    - _FCM Registration API_
    - _Firebase Realtime Database Management API_
    - _Identity Toolkit API_

1. Click "Save"

#### Android key

1. The Android API key should have a name like "Android key (auto created by Firebase)"
1. Click on its name to edit it
1. Under "API Restrictions", choose "Restrict key"
1. Choose the following APIs
    - _FCM Registration API_
    - _Firebase Realtime Database Management API_
    - _Identity Toolkit API_
    - _Firebase Installations API_
1. Click "Save"

It is also possible to restrict the key further to a specific Android app.

#### iOS key

The iOS key gets generated when [registering an iOS app](../development/local-dev-setup.md#mobile-app-client-configuration).
This key, named "iOS key (auto created by Firebase)", is not needed and can be deleted.
