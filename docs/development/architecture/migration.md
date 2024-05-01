# Migration

The Opal solution has organically evolved over time since its inception.
In order to simplify the architecture and reduce accidental complexity we started a process to migrate functionality in legacy components over time to the _backend_ (using Python and the Django web framework).
At the same time, this helps to move away from old technology.
See the [high-level architecture](index.md#high-level-architecture) for more details on the current architecture and future vision.

## Migrating Legacy Components using the Strangler Fig Pattern

We are using the [Strangler Fig Pattern](https://martinfowler.com/bliki/StranglerFigApplication.html) in order to move from the legacy components of Opal to new components and a new architecture in an incremental way.

This approach provides an alternative to building a completely new system from scratch and doing a complete switch over once it is fully completed.
Instead, the new system is built and operated in parallel and new functionality is only added to the new system.
The new system is incrementally built and the old system eventually strangled.

More details about this pattern can be found in the resources below.

### Resources

* [Strangler Fig Application - Martin Fowler](https://martinfowler.com/bliki/StranglerFigApplication.html)
* How Shopify applied the Strangler Fig Pattern within the same codebase: [Refactoring Legacy Code with the Strangler Fig Pattern](https://shopify.engineering/refactoring-legacy-code-strangler-fig-pattern)

#### Additional articles about Strangler Fig Pattern

* Paper: [An Agile Approach to a Legacy System](http://cdn.pols.co.uk/papers/agile-approach-to-legacy-systems.pdf)
* [Legacy Application Strangulation: Case Studies](https://paulhammant.com/2013/07/14/legacy-application-strangulation-case-studies/)
* [The Strangler Fig Migration Pattern | by Diana Darie | Medium](https://dianadarie.medium.com/the-strangler-fig-migration-pattern-2e20a7350511)
* [The Strangler pattern in practice - Michiel Rook's blog](https://www.michielrook.nl/2016/11/strangler-pattern-practice/)
* [What is the Strangler Fig Pattern and How it Helps Manage Legacy Code](https://www.freecodecamp.org/news/what-is-the-strangler-pattern-in-software-development/)
* [The Ship of Theseus to NOT rewrite a legacy system from scratch](https://understandlegacycode.com/blog/ship-of-theseus-avoid-rewrite-legacy-system/)
* [https://docs.microsoft.com/en-us/azure/architecture/patterns/strangler-fig](https://docs.microsoft.com/en-us/azure/architecture/patterns/strangler-fig)

## Migration Process

As outlined in the [future vision](index.md#future-vision) the goal is that all functionality will be migrated to the _Backend_ component.
The backend is operated in parallel and was established to provide new functionality, such as hospital settings, caregivers and their relationships to patients, caregiver management, email verification for the registration etc.

Before the migration process began, Opal only supported a one-to-one relationship between a patient and user.
Patient and user are tightly connected concepts in the legacy system.
For instance, the `Patient` table in the `OpalDB` database contains several user-specific columns and a `Users` record always links to a `Patient` record.
The reliance in the legacy codebase on both of these in combination makes it more difficult to completely remove the `Users` table right away.
In addition, patients are the most important concept as all data and relationships are tied to a patient.
During the initial phase of the migration process, there is some duplicated data required to be held in both the legacy system and the backend.

### Data Overview

The following table shows data that exists in both systems.
_Legacy_ refers to the legacy backend (stored in the legacy database _OpalDB_) and _Backend_ for the new backend.

| Concept     | Legacy            | Backend                               |
| ----------- | ----------------- | ------------------------------------- |
| Patient     | `Patient` table: Contains all patients and a dummy patient entry for users who are not patients themselves. | `Patient` model: Contains all patients with a `legacy_id` referring to `Patient.PatientSerNum` in the legacy DB. |
| Caregiver User | `Users` table: Contains all users. The `UserType` is `Patient` if the user is also a patient and `Caregiver` if it is a caregiver only. | The `Caregiver` model is a type of `User` which contains all existing (migrated) and new caregiver users. The `CaregiverProfile` model links to it and adds the `legacy_id` which refers to `Users.UserTypeSerNum`. |
| Hospital Site | `Hospital_Identifier_Type` table: Contains sites of a hospital and their internal code. | `Institution` and `Site` models: Contains institutions and their site(s) along with their properties and settings. |
| Hospital Patient | `Patient_Hospital_Identifier` table: Contains the list of MRNs and site codes | `HospitalPatient` model: Contains the list of MRNs and a reference to the `Site` instance |
| Security Question | **Deprecated**: `SecurityQuestion` table: Contains a list of pre-defined security questions | `SecurityQuestion` model: Contains a list of (migrated) pre-defined security questions |
| Security Answer | **Deprecated:** `SecurityAnswer` table: The answer to a particular question | `SecurityAnswer` model: The answer to the question. The question is a field within the same model to support user-defined questions in the future. |
| User (Staff) | `OAUser` table: Contains all users who can log in to OpalAdmin | The `ClinicalStaff` model is a type of `User` which contains all users. |

#### Diagrams

The following diagrams were initially produced using the Django app [`django-model2puml`](https://github.com/sen-den/django-model2puml).

##### OpalDB (Legacy)

Some of the tables shown are an excerpt and do not contain all columns (denoted with `...` at the bottom).

```plantuml source="docs/development/architecture/diagrams/migration/userdata_legacy.puml"
```

##### Backend

```plantuml source="docs/development/architecture/diagrams/migration/userdata_backend.puml"
```

### Keeping Data in Sync

Keeping the same data in two places has the risk that the data runs out of sync.
In order to keep the data in sync between both there are management commands in the backend that can migrate data from the legacy system over.
Most commands are intended to be run only once to migrate data during an upgrade.
There also exist management commands that check for deviations (for patients and caregivers).
These commands are run periodically.

### Maintaining User Session Data

For certain tasks, such as logging in, decryption of requests and encryption of responses, the listener needs access to certain data (such as the current session encryption key).
The table `PatientDeviceIdentifier` in the legacy database (`OpalDB`) contains various session data and acts as some kind cache/session store where data related to the user's session is stored.
Since the listener already accesses this data, we can use this table to store session-related data in the short term.

* Keep the `PatientDeviceIdentifier` table as a cache for the listener

    * Store the Firebase username as a reference to the user (available with every request)
    * Store the current security answer hash
    * Maintain the current use of storing the device and push IDs

Over time we can then fully move it to the backend and cache required session data in the listener directly.

### Path Forward

There is still a lot of functionality to be migrated.
More investigation is required to determine the exact migration path forward.
