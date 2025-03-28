<!--
SPDX-FileCopyrightText: Copyright (C) 2022 Opal Health Informatics Group at the Research Institute of the McGill University Health Centre <john.kildea@mcgill.ca>

SPDX-License-Identifier: CC-BY-SA-4.0
-->

# Appointment Check-in Process

A core functionality within the Opal ecosystem is the ability for a patient (or a caregiver of a patient) to check in to an appointment at the hospital.
There are several different ways this can happen, depending on whether the Opal Room Management System (ORMS) has been installed at the hospital or not, and whether the hospital system itself tracks appointment check-ins.

## Opal App Check-ins

When a user logs into the Opal application, they can see right away if they have any scheduled appointments for that day in the app home screen.
By default, an appointment can only be checked in from the app if the user is located at or near the hospital site where the appointment is scheduled.

Currently, when a user attempts to login for themselves or for a patient under their care, all appointments for that day will be attempted to be checked in at once.
The _Listener_ container receives this request and is responsible for making all necessary API calls to successfully check the patient in for that day's appointments.

Configuration variables within the _Listener_ environment control whether the _Listener_ will attempt to notify ORMS and/or the hospital source system of this patient check-in.
_OpalAdmin_ is always notified of a patient check-in.

The following sequence diagram details the series of API calls that are made immediately after a patient clicks the _Check In_ button from the Opal app.

```plantuml source="docs/development/architecture/diagrams/checkins/app_checkins.puml"
```

Note that a check-in is only considered _successful_ if all attempted check-in API calls to the various check-in systems were successful.
In addition, under the "check-in to all appointments for a day" paradigm, a single failed appointment check-in will result in displaying an error message to the patient indicating that all check-ins have failed.

## Opal Room Management System Check-ins

The Opal Room Management System will be notified of Opal app check-ins as shown in the sequence diagram above.
However, ORMS also provides several additional methods of checking in to an appointment for patients.

These are:

- Kiosk Check-ins - where a patient can scan their hospital card at an ORMS kiosk in the hospital to check in to all appointments for the day, before proceeding to the waiting room
- Virtual Waiting Room (VWR) Check-ins - where a patient can request to be checked into all appointments for that day at a reception desk, and a clinical staff member uses the ORMS VWR to perform the check-in on the patient's behalf
- SMS Check-ins - where a patient can respond to an automated SMS sent to their mobile device with the phrase 'Check In' in order to be checked in for all appointments for the day

From the perspective of the Opal ecosystem, all three of these check-in methods are identical in that they result in the same API call(s) from ORMS to Opal, although from a patient perspective they are different.

The following sequence diagram details the series of API calls that are made immediately after a patient attempts a check in from a wait room Kiosk, via an SMS, or via a clinical staff member interacting with the ORMS virtual waiting room.

```plantuml source="docs/development/architecture/diagrams/checkins/orms_checkins.puml"
```
