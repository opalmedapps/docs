<!--
SPDX-FileCopyrightText: Copyright (C) 2026 Opal Health Informatics Group at the Research Institute of the McGill University Health Centre <john.kildea@mcgill.ca>

SPDX-License-Identifier: CC-BY-SA-4.0
-->

# The Opal Solution

The Opal solution is an open source platform created by the Opal Health Informatics Group, operating out of the Research Institute of the McGill University Health Centre in Montreal Canada. The group is directed by McGill Professor John Kildea.

The solution has four main components as seen below. The documentation will be sectioned into these components.

![Opal Components](images/opal_components.png)

## Components Overview

### Opal Admin

Opal Admin is the main component for setting up and maintaining the Opal solution. It has the pages where all new system setup and configurations occur, as well as the aliasing, creating, maintaining, and publishing of content to be shared with patients and caregivers, to support the understanding of their medical data. Questionnaires can be created and published to users and the answers viewed by clinical staff in the Opal RMS component described below.

Opal Admin is also where an institution will register patients and caregivers for access to the Opal Patient Portal.

### Opal RMS

Opal RMS (aka. ORMS) stands for Opal Room Management System. This is a clinical facing component to manage clinics with a virtual waiting room. It allows for configurations by clinic and doctor to set the virtual waiting room to the desired patient list, as well as examination rooms and hardware peripherals (kiosks with room direction navigation, TV screens). Doctors may also view patient provided information, such as questionnaire responses.

The Virtual Waiting Room reflects the checked in appointments of the day, while the Clinical Viewer allows for viewing data from previous appointments.

### Opal User Registration

Once a patient or caregiver obtains a registration code from the hospital’s administrative staff, they can complete the rest of the registration on their own via the Opal User Registration website. This component is what will set up the user in Opal, and establish their password and security questions. Behind the scenes, it is at this time that the user is created in the Opal databases and data accesses will be established for any caregiver roles they have been approved for. Depending on the institution and its processes, the access might require confirmation for certain caregiver roles. It is only when this approval occurs (e.g., by the medical records department) that the user can access the patient data.

### Opal Patient Portal

The Opal Patient Portal is a mobile application designed to empower patients with their medical information. The content created by clinicians via Opal Admin, as well as data from the healthcare systems the solution has established interfaces with, will be securely provided to patients in their mobile application. The patient portal can also be accessed via a browser.

For more information about Opal, refer to the [Opal website](https://www.opalmedapps.com/).

## Components used for registering a Patient Portal user

```mermaid
flowchart TD
    %% ===== Nodes =====
    Start([Start])
    EndNo([End])
    EndYes([End])

    A[A patient is created/exists in the hospital system<br/>e.g., <b>OpenEMR, ADT</b>]

    D{Patient consents<br/>to have <b>Opal</b>?}

    B[Registration code generated in <b>Opal Admin</b> and displayed as a QR code to the user]

    C[User completes their registration using the <b>Opal User Registration</b> website]

    E[Patient data pulled from hospital source systems<br/>and stored in Opal's Patient Information Exchange system]

    F[User accesses patient data on the <b>Opal Patient Portal</b>]

    %% ===== Flow =====
    Start --> A
    A --> D
    D -- No --> EndNo
    D -- Yes --> B
    B --> C
    C --> E
    E --> F
    F --> EndYes

    %% ===== Classes =====
    class Start,EndNo,EndYes startEnd
    class A,E hospital
    class B opalAdmin
    class C,F portal
    class D decision

    %% ===== Style Definitions =====
    classDef startEnd fill:#E6E6E6,stroke:#333,stroke-width:1px,color:#000
    classDef hospital fill:#7FB3FF,stroke:#1F4FBF,stroke-width:1px,color:#000
    classDef opalAdmin fill:#B39DDB,stroke:#5E35B1,stroke-width:1px,color:#000
    classDef portal fill:#8BC34A,stroke:#33691E,stroke-width:1px,color:#000
    classDef decision fill:#E8F5E9,stroke:#558B2F,stroke-width:2px,color:#000
```

## Components used for appointment check in

```mermaid
flowchart TD
    %% ===== Nodes =====
    Start([Start])

    A[An appointment is created/exists for a patient<br/>in the hospital system.<br/> e.g. <b>OpenEMR</b>]

    B[Interfaces send appointment data to Opal's Patient Information Exchange system.<br/><b>Opal Admin</b> and <b>Opal RMS</b>]

    D{Patient has <b>Opal<br/>Patient Portal</b>?}

    C[Patient receives maps, reminders, preparation instructions as configured in <b>Opal Admin</b>]

    E[Patient checks into their appointment using the <b>Opal Patient Portal</b> once within range of the hospital]

    F[Clinician manages patient appointment call ins via <b>Opal RMS</b>, which notifies the patient by the </b><b>Opal Patient Portal</b> and the TV screens]

    G[Patient checks in using the kiosk, SMS available with <b>Opal RMS</b> or at reception]

    H[Clinician manages patient appointment call ins via <b>Opal RMS</b>, which notifies the patient by the TV screens and/or SMS]

    EndYes([End])
    EndNo([End])

    %% ===== Flow =====
    Start --> A
    A --> B
    B --> D

    D -- Yes --> C
    C --> E
    E --> F
    F --> EndYes

    D -- No --> G
    G --> H
    H --> EndNo

    %% ===== Classes =====
    class Start,EndYes,EndNo startEnd
    class A hospital
    class B interfaces
    class C admin
    class D decision
    class E portal
    class F,H rms
    class G rmsAlt

    %% ===== Style Definitions =====
    classDef startEnd fill:#E6E6E6,stroke:#333,stroke-width:1px,color:#000
    classDef hospital fill:#7FB3FF,stroke:#1F4FBF,stroke-width:1px,color:#000
    classDef interfaces fill:#BDBDBD,stroke:#616161,stroke-width:1px,color:#000
    classDef admin fill:#9C8AD1,stroke:#512DA8,stroke-width:1px,color:#000
    classDef portal fill:#8BC34A,stroke:#33691E,stroke-width:1px,color:#000
    classDef rms fill:#F6A5A5,stroke:#C62828,stroke-width:1px,color:#000
    classDef rmsAlt fill:#F6A5A5,stroke:#C62828,stroke-width:1px,color:#000
    classDef decision fill:#E8F5E9,stroke:#558B2F,stroke-width:2px,color:#000
```
