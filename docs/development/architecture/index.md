# Architecture

Opal is a solution aimed at providing patients and their caregivers[^1] access to the patient's medical data.
Opal provides two main parts to achieve this goal:

1. A patient/caregiver-facing part to give them access to the medical data.
2. A clinical staff facing part to manage the patient data.

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

The Opal solution provides the _Opal Patient Information Exchange (PIE)_ which is currently deployed inside a hospital.
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

### Opal Integration Engine (OIE)

* [Project Page](https://gitlab.com/opalmedapps/opal-integration-engine)
* [Mirth Connect](https://www.nextgen.com/solutions/interoperability/mirth-integration-engine)

The OIE is responsible for interfacing with the hospital's interface.
It receives unsolicited HL7 messages from hospital source systems.
It also makes solicited requests to source systems in the hospital.
For example, to search for a patient in the hospital (that is not a patient in Opal yet), or, to send data, such as a PDF that should be stored in the patient's chart in the hospital system.
For the latter case, the OIE provides a set of API endpoints for our components to make requests to hospital systems.

!!! note

    This component is currently specific to the [McGill University Health Centre](https://muhc.ca) (MUHC) where this is used in production.
    Future work needs to establish a generic approach that can be adapted for other hospitals.
    Furthermore, some hospital systems do not send data in real time.
    Instead, they provide APIs to retrieve data instead.
    More work is required to support both these scenarios.

### OpalAdmin

* [Project Page](https://gitlab.com/opalmedapps/OpalAdmin)

OpalAdmin provides the admin interface for clinicians and staff.
The web application is used to manage patients, hospital maps, questionnaires etc.
It exposes all of its functionality via an API.
Most of the API is intended for the frontend which is built as a single page application.
The remaining parts of the API are intended for use by our other components, such as the OIE.

OpalAdmin also contains a publishing module which contains scripts that are run periodically.
These scripts manage new data that was added, and determine whether caregivers need to be informed about new patient data (via push notifications to their mobile devices).

### Listener

* [Project Page](https://gitlab.com/opalmedapps/opal-listener)
* [Published Documentation](https://opalmedapps.gitlab.io/opal-listener)

The listener is the component that interacts with Firebase in order to handle requests coming from the user applications.
The requests it handles are those intended for the hospital the Opal PIE is operating in.
See the [section on communication below](#communication-between-user-applications-and-the-opal-pie) for more information.

The listener contains legacy app and registration functionality as well as new functionality for forwarding API requests to the backend:

* The legacy part handles request types and directly executes queries on the databases.
* The new functionality receives API requests (basically, HTTP requests as JSON) and forwards them to the backend API.
  It acts as a kind of proxy/middleware and makes actual HTTP requests.
  The HTTP response is returned.

### Backend

* [Project Page](https://gitlab.com/opalmedapps/backend)
* [Published Documentation](https://opalmedapps.gitlab.io/backend)

The backend (aka. _New OpalAdmin_) is the new backend that replaces the [legacy OpalAdmin](#opaladmin).
It provides APIs for the user applications and other systems, such as the OIE.
In addition, it provides the new user interface for OpalAdmin containing all the new functionality, auditing, user authentication and authorization.

Over time, other existing functionality will be migrated to this component (see [future vision](#future-vision)).

### Opal Labs

* [Project Page](https://gitlab.com/opalmedapps/opal-labs)

_Opal Labs_ is an additional component which takes care of processing new lab results for patients.
It exposes an API endpoint for use by the OIE to handle new lab results.
_Opal Labs_ takes care of inserting those lab results into the database (`OpalDB`).
It also makes an API call to _OpalAdmin_ to request sending a push notification to caregivers.

??? note "MUHC Specifics"

    _Opal Labs_ also contains an API endpoint to retrieve the lab result history for a particular patient.
    The endpoint calls the _VSign_ SOAP web service of _OACIS_ to retrieve the history.
    This action is performed when a new patient is added to Opal at the end of the registration process.
    It is triggered by the OIE.

### User Registration

* [Project Page](https://gitlab.com/opalmedapps/registration-web-page)
* [Production Registration](https://registration.opalmedapps.ca)

The registration websites provides a user (caregiver) the ability to create their Opal account.
In order to use the registration website, a caregiver has to request access to a patient's data at the hospital.
At the end of this, the hospital will provide a registration code to the caregiver.
Using the registration code and the patient's identification number (RAMQ or MRN) the user can complete the registration process.

### Web and Mobile App

* [Project Page](https://gitlab.com/opalmedapps/qplus)

The web and mobile app provide caregivers the ability to access patient data for the patients under their care.
The mobile app is the same as the web app.
It is packaged as a mobile app and distributed through the Google Play and Apple App stores.
The mobile app supports additional features native to mobile devices, such as location, sharing etc.

### Helper components

#### Database Migrations and Initial Data

* [Project Page](https://gitlab.com/opalmedapps/db-docker/)

Historically, the legacy components of Opal did not maintain migrations of the database schema.
Migrations and initial data (to set up Opal at a new hospital) is maintained in this separate component.
The migrations are managed using [Alembic](https://alembic.sqlalchemy.org/).
Initial data and upgrade scripts are maintained as SQL files.

A container image is produced for this component.
It is only necessary to run this during setup and upgrade.

### Third-party components

#### Redis

* [Project Page](https://redis.io/)

Redis is used by _Opal Labs_ to cache patients being processed to avoid sending caregivers multiple push notification times when batch processing.

## Communication between user applications and the Opal PIE

Hospital networks are typically not accessible from the outside.
Firebase is used to support passing data from within the hospital firewall to the user applications and vice versa.

Opal makes use of two Firebase services:

* [_Authentication_](https://firebase.google.com/docs/auth) is used for user accounts (via email and password).
* [_Realtime Database_](https://firebase.google.com/docs/database) is used to pass requests and responses between user applications and the Opal PIE.

A Firebase user account is created when a user completes the user registration for the first time.
The Firebase Realtime Database acts as a kind of queue for sending requests and receiving responses.

The Opal PIE establishes an outgoing connection to Firebase to observe the Realtime Database for changes.
Any time a new request is added by a user application it is notified of this change and handles the request.
The response for the request is placed into the Realtime Database and the user application–which is notified of the response–reads and handles the response.

### Encryption

TBC

### Supporting Multiple Hospitals

TBC

https://gitlab.com/opalmedapps/qplus

[^1]:
    We consider a caregiver to also include the patient.
    In that case they are caring for themself.

### Appointment Checkin Processes

A core functionality within the Opal ecosystem is the ability for a patient (or a caregiver of a patient) to checkin to an appointment at the hospital.
There are several different ways this can happen, depending on whether the Opal Wait Room Management System has been installed at the hospital or not, and whether the hospital system itself tracks appointment checkins.

#### Opal App Checkins

When a user logs into the Opal application, they can see right away if they have any scheduled appointments for that day in the app home screen.
By default, an appointment can only be checked in from the app if the user is located at or near the hospital site where the appointment is scheduled.

Currently, when a user attempts to login for themselves or for a patient under their care, all appointments for that day will be attempted to be checked in at once.
The Listener container receives this request and is responsible for making all necessary API calls to successfully check the patient in for that day's appointments.

Configuration variables within the Listener environment control whether the listener will attempt to notify ORMs and/or the Hospital Source System of this patient checkin.
The Opal Backend is always notified of a patient checkin.

The following sequence diagram details the series of API calls that are made immediately after a patient clicks the Check In button from the Opal app.

```plantuml source="docs/development/architecture/diagrams/checkins/app_checkins.puml"
```

Note that a checkin is only considered "successful" if all attempted checkin API calls to the various checkin systems were successful.
In addition, under the "all appointment checkin for a day" paradigm, a single failed appointment checkin will result in displaying an error message to the patient indicating that all checkins have failed.

#### Opal Wait Room Management System Checkins

The Opal Wait Room Management system will be notified of Opal app checkins as shown in the sequence diagram above.
However, ORMs also provides several additional methods of checking in to an appointment for patients.

These are:

* Kiosk Checkins - where a patient can scan their hospital card at an ORMs kiosk in the hospital to checkin to all appointments for the day, before proceeding to the waiting room
* Virtual Waiting Room (VWR) Checkins - where a patient can request to be checked into all appointments for that day at a reception desk, and a clinical staff member uses the ORMs VWR to perform the checkin on the patient's behald
* SMS Checkins - where a patient can respond to an automated SMS received to their mobile device with the phrase 'Check In' in order to be checked in for all appointments for the day

From the perspective of the Opal ecosystem, all three of these checkin methods are identical in that they result in the same API call(s) from ORMs to Opal, although from a patient perspective they are different.

The following sequence diagram details the series of API calls that are made immediately after a patient attempts a checkin from a wait room Kiosk, from their phone SMS, or via a clinical staff member interacting with the ORMs virtual waiting room.

```plantuml source="docs/development/architecture/diagrams/checkins/orms_checkins.puml"
```
