<!--
SPDX-FileCopyrightText: Copyright (C) 2024 Opal Health Informatics Group at the Research Institute of the McGill University Health Centre <john.kildea@mcgill.ca>

SPDX-License-Identifier: CC-BY-SA-4.0
-->

# User Guide

There are two sets of documents found under this section.

The **OpenEMR** section provides instructions on the minimal OpenEMR requirements see the Opal-OpenEMR demo integration in action. As we continue to evolve the integration with other features the documentation will be added.

The **Opal** section provides instructions for using our software. Opal must be integrated with external medical systems to verify and obtain patient data. data.

The Opal-OpenEMR live demo provides a fully functional cloud-based instance of Opal integrated with OpenEMR.

[Opal](https://www.opalmedapps.com/) is an award-winning open-source patient-in-the-loop data platform consisting of a data publishing tool (Opal ADMIN) and a patient portal (Opal app).[^1]

[OpenEMR](https://www.open-emr.org/) is the world’s most popular open-source electronic medical record system.

The demo allows users to login to OpenEMR, add patient data as a clinician would, and see the patient data in Opal as a patient would. Users can create new patients, register them for Opal, and setup rules and aliases in Opal ADMIN to share data between OpenEMR and Opal.

![Opal-OpenEMR Demo](images/Opal-OpenEMR_Demo.png)

The following data are currently synchronized between OpenEMR and Opal\[2\*\]:

- Diagnosis information,
- Appointment information with maps and “how to prepare” instructions,
- Lab results (in real-time with trends and links to explanatory materials),
- Clinical notes.

1\* _Opal also has a fully-integrated waiting room management system but it is not currently available in the live demo._

2\* _The submission of questionnaires from the Opal app to OpenEMR is a work in progress. Other integrated functionality will be added to this document as they become available._

Additionally, Opal is configured with demonstration questionnaires, education materials and treating team messages.

To run a demo, two logins are required: (1) OpenEMR, (2) Opal app. Also, for certain tasks, a login to Opal ADMIN is needed.

## 1. OpenEMR Demo Login (Demo Doc)

<table>
  <tr>
   <td><strong>Account type:</strong>
   </td>
   <td>Clinician who can add and modify patient data.
   </td>
  </tr>
  <tr>
   <td><strong>URL:</strong>
   </td>
   <td><a href="https://openemr.opalmedapps.com">openemr.opalmedapps.com</a>
   </td>
  </tr>
  <tr>
   <td><strong>Username:</strong>
   </td>
   <td>DemoDoc
   </td>
  </tr>
  <tr>
   <td><strong>Password:</strong>
   </td>
   <td>Painting-Spirit2-Gravel
   </td>
  </tr>
</table>

## 2. Opal Patient Portal Demo Login (Mike Brown)

<table>
  <tr>
   <td>
<h3>Account type:</h3>

</td>
   <td colspan="4" >Opal user (<strong>Mike Brown</strong>) who is both a demo patient and a demo <span style="text-decoration:underline;">caregiver to his wife (Kathy Brown)</span>.
   </td>
  </tr>
  <tr>
   <td>
<h3>App stores</h3>

(click on images)

</td>
   <td>

![AppStore](images/appstore.avif)

</td>
   <td>

![GooglePlay](images/googleplay.avif)

</td>
   <td colspan="4" >Alternative web version:
<p>
<a href="https://research.app.opalmedapps.ca/">research.app.opalmedapps.ca</a>
   </td>
  </tr>
  <tr>
   <td>
<h3>Username:</h3>

</td>
   <td colspan="4" >mike@opalmedapps.ca
   </td>
  </tr>
  <tr>
   <td>
<h3>Password:</h3>

</td>
   <td>12345Opal!!
   </td>
   <td colspan="3" ><strong>Note:</strong> The app automatically logs out after 5 mins.
   </td>
  </tr>
  <tr>
   <td>
<h3>Hospital:</h3>

</td>
   <td colspan="4" >Opal Demo 1 (OD1)
   </td>
  </tr>
  <tr>
   <td>
<h3>Security answers:</h3>

</td>
   <td colspan="4" >What was the colour of your first car? red
<p>
What is the name of your first pet? meg
<p>
What was the name of your favorite superhero as a child? superman
<p>
What is the first name of your childhood best friend? diana
<p>
Where did you go on your first vacation? florida
   </td>
  </tr>
</table>

## 3. Opal ADMIN Demo Login (Demo Admin)

<table>
  <tr>
   <td>
<h3>Account type:</h3>

</td>
   <td>Clinician who can create aliases (for appointments, clinical notes, lab results, diagnoses) as well as education materials and questionnaires.
   </td>
  </tr>
  <tr>
   <td>
<h3>URL:</h3>

</td>
   <td><a href="https://demo.opalmedapps.com/opalAdmin">demo.opalmedapps.com/opalAdmin</a>
   </td>
  </tr>
  <tr>
   <td>
<h3>Username:</h3>

</td>
   <td>DemoAdmin
   </td>
  </tr>
  <tr>
   <td>
<h3>Password:</h3>

</td>
   <td>Silk7-Artificial-Floral
   </td>
  </tr>
</table>

## Things to try

To get a feel for how Opal and OpenEMR are integrated, we suggest trying the following tasks.

## 1. Add an appointment

While logged into OpenEMR as **Demo Doc**, create a **new appointment** for the patient Mike Brown and see it appear in Mike Brown’s Opal app.

1. Login to OpenEMR as clinician **Demo Doc**
1. Create an appointment for **Mike Brown**
    1. (Category: Consult New In)
1. Login to the Opal app as user **Mike Brown**
1. Confirm that Mike Brown’s new appointment appears in the Opal calendar (refresh the calendar if needed with the circular arrow at the top right)
    2\. (Consultation Appointment with the medical oncologist)

## 2. Add a clinical note

Add a **PDF note** to the chart of patient **Mike Brown** and see it appear in the Opal app.

1. Login to OpenEMR as clinician **Demo Doc**
    1. Find patient **Mike Brown**
    1. Go to Documents for **Mike Brown**
    1. Upload a PDF document under **Mike Brown’s** Medical Record
1. Login to the Opal app as user **Mike Brown**
1. Observe the document appear in Opal in the Clinical Notes menu

## 3. Add a diagnosis

Add a **diagnosis** (medical problem) for patient Mike Brown and see it appear in the Opal app. Note: only certain diagnoses are currently aliased so please follow the example below. If the same diagnosis is added twice in OpenEMR, it will be shown twice in Opal.

1. Login to OpenEMR as clinician Demo Doc
    1. Find patient Mike Brown
    1. Add a new diagnosis of **Syringomyelia and syringobulbia** using the Medical Problems card
1. Observe the diagnosis appear in Opal in the Diagnosis menu with today’s date

## 4. Send educational material

Create a simple educational document in Opal ADMIN, publish it to all patients with Syringomyelia, and see it appear in the Opal app for Mike Brown.

1. Login to Opal ADMIN as user DemoAdmin
    - Go to the Educational / Reference Materials card
    - Add a new video and use a Youtube url
    - Remember the title you gave the material
1. Go to the Publication Tools card and add a rule for Educational / Reference Materials
    - Find your education material
    - Enter “Syringomyelia” in the Diagnosis section
    - Submit the publication
    - Find your education material again, click the “Active” check box and Save Changes - this will activate the publication rule
1. Login to Opal as Mike Brown
    - View the video in the Clinical Reference Material section of Mike Brown’s Chart
    - Note: It may take a few minutes for the material to make it to the patient’s Opal

## 5. Create a new patient, register them for Opal

Create a new patient in OpenEMR, generate a QR code in Opal ADMIN, register the patient on the Opal registration website and login with Opal.

1. Login to OpenEMR as **Demo Doc**
1. Create a new patient in OpenEMR
    1. Be sure to complete all fields
    1. Provide a 7-digit MRN
    1. Provide a healthcare number with 4 letters followed by 8 numbers
        - Like: ABCD12345678 (emulates the Quebec Medicare number)
1. Login to Opal ADMIN as DemoAdmin
    4\. In the Administration section, open the Patients card
    5\. Select Opal Registration
    6\. Enter required details
    7\. Provide password for DemoAdmin
1. Use the QR code to navigate to [research.registration.opalmedapps.ca](https://research.registration.opalmedapps.ca/) and complete the patient’s registration for Opal
    8\. Use the MRN or healthcare number to identify the patient
1. Login to Opal using the username, password, and security answers that the patient was registered with.

<!-- Footnotes themselves at the bottom. -->

## Notes
