<!--
SPDX-FileCopyrightText: Copyright (C) 2022 Opal Health Informatics Group at the Research Institute of the McGill University Health Centre <john.kildea@mcgill.ca>

SPDX-License-Identifier: CC-BY-SA-4.0
-->

# Architecture

Opal is a solution aimed at providing patients and their caregivers[^1] access to the patient's medical data.
Opal provides two main parts to achieve this goal:

1. A patient/caregiver-facing part to give them access to the medical data.
1. A clinical staff facing part to manage the patient data.

!!! note

    The diagrams presented here are based on the [C4 model](https://c4model.com) for visualizing software architecture.
    They are created with [PlantUML](https://plantuml.com) using the [C4 PlantUML Extension](https://github.com/plantuml-stdlib/C4-PlantUML).

    We use system context and container diagrams.
    Note that a container represents an application or data store (and not a "Docker container").
    In this document we use container and component interchangeably.

## High-level Architecture

The following system context diagram shows a high-level view of the architecture.

```plantuml source="docs/development/architecture/diagrams/context_diagram.puml"
```

The Opal solution provides the _Opal Patient Information Exchange (PIE)_ which is typically deployed inside a hospital.
The components accessible by caregivers are available via mobile app stores and are also hosted on the web.
These components consist of the user registration web application to create user accounts and the application for patients (or their caregiver(s)) to access the patient's medical data.

### Overview of User Applications

The following container diagram focuses on the user applications that users (caregivers) use with Opal.

```plantuml source="docs/development/architecture/diagrams/container_diagram_user.puml"
```

As can be seen in the above diagram, communication between the user applications and the Opal PIE is accomplished via Firebase.

The _User Registration_ currently only supports user account creation by requesting access to a patient's data.
The user will receive a registration code at the end of this process which is required on the _User Registration_.

### Overview of the Opal PIE

The following container diagram shows the Opal PIE.

```plantuml source="docs/development/architecture/diagrams/container_diagram_pie.puml"
```

The diagram presents the Opal PIE as it is today.

#### Future Vision

Recently, we have started with a process to migrate functionality to a new component (_Backend_).
The functionality provided by components marked as legacy will be migrated to the backend over time.
We are following the [Strangler Fig migration pattern](migration.md) for this process.

The vision is that the backend will be a [majestic](https://signalvnoise.com/svn3/the-majestic-monolith/) [monolith](https://www.monolithic.dev/).
The following diagram depicts this vision.

```plantuml source="docs/development/architecture/diagrams/container_diagram_pie_vision.puml"
```

Note that additional external systems were left out for brevity.

## Overview of components

The following is an overview of all the components that are part of the Opal solution.

### OpalAdmin (New)

- **Repository:** https://github.com/opalmedapps/opal-admin
- **Documentation:** https://github.com/opalmedapps/opal-admin/tree/main/docs
- **API Documentation:** Available when running at `<hostAddress>/api/schema/swagger-ui`

_OpalAdmin_ (aka. _New OpalAdmin_) is the new backend that replaces the [legacy OpalAdmin](#opaladmin-legacy).
It provides APIs for the user applications and other systems, such as an integration engine.
In addition, it provides the new user interface for OpalAdmin containing all the new functionality, auditing, user authentication and authorization.

Over time, other existing functionality will be migrated to this component (see [future vision](#future-vision)).

### OpalAdmin (Legacy)

- **Repository:** https://github.com/opalmedapps/opal-admin
- **API Documentation for integration:** https://github.com/opalmedapps/opal-admin-legacy/blob/main/php/openapi.yml

_Legacy OpalAdmin_ provides the admin interface for clinicians and staff.
The web application is used to manage patients, hospital maps, questionnaires etc.
It exposes all of its functionality via an API.
One part of the API is intended for the frontend which is built as a single page application.
The other part of the API is intended for use by other services that integrate with Opal, such as an integration engine of a hospital.

The _legacy OpalAdmin_ also contains a publishing module which has scripts that are run periodically.
These scripts manage new data that was added, and determine whether caregivers need to be informed about new patient data (via push notifications to their mobile devices).

??? note "Lab Results Specifics"

    _Legacy OpalAdmin_ also has an API endpoint to insert lab results for a particular patient.
    This endpoint was migrated from another component and does not use _OpalAdmin_'s authentication system.
    HTTP Basic authentication configured in the reverse proxy is used to prevent unauthenticated access.

### Listener

- **Repository:** https://github.com/opalmedapps/opal-listener
- **Documentation:** https://github.com/opalmedapps/opal-listener/tree/main/docs

The _Listener_ is the component that interacts with Firebase in order to handle requests coming from the user applications.
The requests it handles are those intended for the hospital the Opal PIE is operating in.
See the [section on communication below](#communication-between-user-applications-and-the-opal-pie) for more information.

The listener contains legacy app and registration functionality as well as new functionality for forwarding API requests to the new _OpalAdmin_:

- The legacy part handles request types and directly executes queries on the databases.
- The new functionality receives API requests (basically, HTTP requests as JSON) and forwards them to the OpalAdmin API.
    It acts as a kind of proxy/middleware and makes actual HTTP requests.
    The HTTP response is directly returned.

### User Registration

- **Repository:** https://github.com/opalmedapps/opal-registration

The registration web application provides a user (caregiver) the ability to create their Opal account.
In order to use the _registration_, a caregiver has to request access to a patient's data at the hospital.
At the end of this request process, the hospital will provide a registration code to the caregiver.
Using the registration code and the patient's identification number (health insurance number or MRN) the user can complete the registration process.

### Web and Mobile App

- **Repository:** https://github.com/opalmedapps/opal-app

The web and mobile app provides caregivers the ability to access patient data for the patients under their care.
The mobile app is the same as the web app.
It is built using _Cordova_ as a mobile app and distributed through the Google Play and Apple App stores.
The mobile app supports additional features native to mobile devices, such as location, sharing etc.

### Sidecar components

#### Database Migrations and Initial Data

- **Repository:** https://github.com/opalmedapps/db-management

Historically, the legacy components of Opal did not maintain migrations of the database schema.
Migrations and initial data (to set up Opal at a new hospital) is maintained in this separate component.
The migrations are managed using [Alembic](https://alembic.sqlalchemy.org/).
Initial data and upgrade scripts are maintained as SQL files.

A container image is produced for this component.
It is only necessary to run this during setup and upgrade.

### Third-party components

#### Redis

- **Project page:** https://redis.io/

Redis is used by the labs feature in _Legacy OpalAdmin_ to cache the patients whose lab results are being processed.
This is done to avoid sending caregivers push notification multiple times when batch processing.

## Communication between user applications and the Opal PIE

Hospital networks are typically not accessible from the outside.
Firebase is used to support passing data from within the hospital firewall to the user applications and vice versa.

Opal makes use of two Firebase services:

- [_Authentication_](https://firebase.google.com/docs/auth) is used for user accounts (via email and password).
- [_Realtime Database_](https://firebase.google.com/docs/database) is used to pass requests and responses between user applications and the Opal PIE.

A Firebase user account is created when a user completes the user registration for the first time.
The Firebase Realtime Database acts as a kind of queue for sending requests and receiving responses.

The Opal PIE establishes an outgoing connection to Firebase to observe the Realtime Database for changes.
Any time a new request is added by a user application it is notified of this change and handles the request.
The response for the request is placed into the Realtime Database and the user application–which is notified of the response–reads and handles the response.

### Encryption

_Details to be added._

### Supporting Multiple Hospitals

_Details to be added._

[^1]: We consider a caregiver to also include the patient.
    In that case they are caring for themself.
