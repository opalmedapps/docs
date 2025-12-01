<!--
SPDX-FileCopyrightText: Copyright (C) 2024 Opal Health Informatics Group at the Research Institute of the McGill University Health Centre <john.kildea@mcgill.ca>

SPDX-License-Identifier: CC-BY-SA-4.0
-->

# Deploying the Opal solution

## High-level Architecture

<figure markdown="span">
    ![Opal High-Level Architecture](https://raw.githubusercontent.com/opalmedapps/.github/refs/heads/main/profile/architecture.png){ width=500 }
</figure>

The platform's primary goal is to securely share data across the perimeter of a healthcare institution's protected network between the Opal app and their medical record in the hospital's source systems.
This is achieved using a cloud-hosted authentication service and *Realtime Database* relay.
Currently, this service is provided by Google's [Firebase](https://firebase.google.com/) service.

The Opal PIE is typically deployed in a hospital (but does not have to be).
The user applications are deployed separately, on a web server and the mobile app stores.

## Deploying the Opal PIE

### Deployment diagrams

We support different deployment scenarios for how the database is deployed.

For ease of deployment (such as when testing a deployment) you can deploy the database as a container:

```plantuml source="docs/install/diagrams/deployment_diagram_pie.puml"
```

Relationships between components on the same host are left out for brevity (except those making use of third-party components).

The database server can also be run on a separate server:

```plantuml source="docs/install/diagrams/deployment_diagram_pie_db.puml"
```

Relationships between components on the same host are left out for brevity (except those making use of third-party components).

### Requirements

You need at least one machine on which to deploy the Opal PIE.
This machine needs to have the [Docker Engine](https://docs.docker.com/engine/) and [Docker Compose](https://docs.docker.com/compose/) installed.
A compatible container engine that also has support for compose can also be used.

In addition, you need a Firebase project.

#### Creating a new Firebase project

If you don't have a Firebase project yet, [create a Firebase project](../development/local-dev-setup.md#create-a-new-firebase-project), [create a Realtime Database](../development/local-dev-setup.md#create-a-new-realtime-database), and [enable password-based authentication](../development/local-dev-setup.md#enable-email-and-password-authentication).

#### Create a Firebase service account

By default, Firebase creates a service account and API keys with excessive permissions.
This is fine for development.
However, it is not recommended for a production environment.

To create a dedicated service account, go to the [Service Accounts in Google Cloud](https://console.cloud.google.com/projectselector2/iam-admin/serviceaccounts) and:

1. Select your Firebase project
1. Select "Create service account"
1. Type in a display name and generate a service account ID
1. Click "Create and continue"
1. In the "Permissions" section, select the following roles:
    - *Firebase Authentication Admin*
    - *Firebase Cloud Messaging Admin*
    - *Firebase Realtime Database Admin*
    - *Firebase Rules Admin*
1. Click "Continue"
1. Click "Done"
1. Click on the newly created service account
1. Select "Keys", select "Add key", and then "Create new key"
1. Choose key type "JSON" and click "Create"
1. Store this file in a secure place for later

### Automated deployment

We offer a semi-automated deployment via a [`copier`](https://copier.readthedocs.io/en/stable/) template.
This project template supports various deployment options and sets up the basic project structure to get the Opal PIE deployed in a few minutes.

Please follow the instructions in the [`deploy-pie`](https://github.com/opalmedapps/deploy-pie) repository.

## User Applications

### Deployment diagram

```plantuml source="docs/install/diagrams/deployment_diagram_user.puml"
```

### Requirements

#### Create or restrict Firebase API keys

If you already [retrieved Firebase client configurations](../development/local-dev-setup.md#retrieve-the-firebase-project-configurations), then you do not need to create new API keys but can instead restrict the already generated ones.
In that case, skip the create steps below and edit the exiting keys instead.

Go to the [API Credentials in Google Cloud](https://console.cloud.google.com/apis/) and select the corresponding Firebase project.

##### Browser key

1. Click "Create credentials" and select "API Key"
1. Give it a name, such as "Browser key"
1. Under "Application restrictions", choose "Websites"
1. Add the following websites at a minimum
    - `app://localhost`
    - `http://localhost`
    - `https://<your-firebase-project-id>.firebaseapp.com`
1. Under "API Restrictions", choose "Restrict key"
1. Choose the following APIs
    - *FCM Registration API*
    - *Firebase Realtime Database Management API*
    - *Identity Toolkit API*
1. Click "Create"

##### Android key

1. Click "Create credentials" and select "API Key"
1. Give it a name, such as "Android key"
1. Under "API Restrictions", choose "Restrict key"
1. Choose the following APIs
    - *FCM Registration API*
    - *Firebase Realtime Database Management API*
    - *Identity Toolkit API*
    - *Firebase Installations API*
1. Click "Create"
