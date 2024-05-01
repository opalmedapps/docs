# Migration to Django

As part of the migration using the [Strangler Fig pattern](strangler_fig.md) and to support the Patient-Caregiver functionality, some specific data needs to be moved to the Django-based backend in the first step.
For now, this is mostly user-specific and registration related data.

## Overview

Data that exists in both systems or was migrated. _Legacy_ refers to the legacy backend and _Backend_ for the Django-based backend:

| Concept     | Legacy            | Backend                               |
| ----------- | ----------------- | ------------------------------------- |
| Patient     | `Patient` table: Contains all patients | `Patient` model: Contains all patients with a `legacy_id` referring to the `PatientSerNum` in the legacy DB |
| User        | **Deprecated**: `Users` table: Contains all legacy users | `Caregiver` model: Contains all existing (migrated) and new users |
| Hospital Patient | `PatientHospitalIdentifier` table: Contains the list of MRNs and site codes | `HospitalPatient` model: Contains the list of MRNs and a reference to the `Site` instance |
| Security Question | **Deprecated**: `SecurityQuestion` table: Contains a list of pre-defined security questions | `SecurityQuestion` model: Contains a list of (migrated) pre-defined security questions |
| Security Answer | Deprecated: `SecurityAnswer` table: The answer to a particular question | `SecurityAnswer` model: The answer to the question. The question is a field within the same model |
| Registration Code | **Deprecated**: `registrationcode` table: The registration codes for registering a specific patient | `RegistrationCode` table: The registration code for a specific relationship between a patient and caregiver |
| Device      | `PatientDeviceIdentifier`: Still in use as a cache for the listener to keep session data | `Device` model: Currently unused |

## Registration

The registration is being completely moved to the Django-based backend.
The sequence diagrams are shown on [registration process](registration.md).
Every API endpoint with the exception of one is now forwarded to the backend by the listener.

The one remaining request handling in the legacy listener is for completing the registration (called `registerPatient`).
This is the most complex one as it handles the creation of the Firebase account, informing ORMS etc.
All this functionality needs to be moved to the backend Post-MVP.

## Patient-Caregiver Functionality (UPS)

With the UPS-project there can be many users for the same patient.
Since most of the user data is connected to the patient in the legacy system, the first part of the migration surrounds all of this data.

The data is:

* **User**: user-specific data, such as email, phone number etc.

    The Django user model is used and augmented, for example, with a phone number field.

* **Security questions/answers**:

    The existing security questions are migrated.
    However, security answers do not link to a security question.
    The security question title is copied to the security answer in the user's language.
    This makes it possible in the future to allow users to define their own questions.

* **Device**: Mobile device data used for tracking a user's mobile devices, e.g., for push notifications.

### Minimal Viable Product (MVP)

In order to minimize the work required with migration and maintaining support with older versions of the app, the migration is completed in stages.

For certain tasks, such as logging in, decryption of requests and encryption of responses, the listener needs access to certain data.
The table `PatientDeviceIdentifier` in the legacy database (`OpalDB`) contains various data and acts as some kind cache/session store where data related to the user's session is stored.
Since the listener already has access to this database, we can use this table to store session-related data in the short term.
Later, we can fully move it to the backend.

We have all of the models ready in the backend (see below). However, as a temporary solution to get ready to support UPS, we will start with the following:

* Keep the `PatientDeviceIdentifier` table as a cache for the listener

    * Store the Firebase username as a reference to the user (available with every request)
    * Store the current security answer hash
    * Maintain the current use of storing the device and push IDs

* Use the backend for storing security answers

### Diagrams

The following diagrams were initially produced using the Django app [`django-model2puml`](https://github.com/sen-den/django-model2puml).

#### OpalDB (Legacy)

Some of the tables shown are an excerpt and do not contain all columns (denoted with `...` at the bottom).

```plantuml source="docs/development/architecture/diagrams/migration/userdata_legacy.puml"
```

#### Backend

```plantuml source="docs/development/architecture/diagrams/migration/userdata_backend.puml"
```

*[MVP]: Minimal Viable Product
*[UPS]: User-Patient Separation
*[PIE]: Patient Information Exchange
