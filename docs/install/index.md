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

#### Create and set up a new Firebase project

If you don't have a dedicated Firebase project yet, follow the steps to [set up a Firebase project].
Please also ensure that you restrict the permissions of the Firebase service account and API keys.

#### Retrieve the Apple Push Notification certificates

!!! note

    These instructions are specific to *macOS* as they require the *Keychain Access* utility.

While push notifications on Android are delivered via *Firebase Cloud Messaging*, on iOS the *Apple Push Notification Service* is used.

The following instructions assume that your iOS app has already been created in [App Store Connect](https://appstoreconnect.apple.com/apps) and therefore has an *App ID*.

!!! success "Preparation: Generate a *Certificate Signing Request*"

    As a preparation, follow the instructions to [create a certificate signing request](https://developer.apple.com/help/account/certificates/create-a-certificate-signing-request).

Log in to your [Apple Developer Account](https://developer.apple.com/account) and do the following:

1. Under "Program resources" > "Certificates, IDs & Profiles", click "Certificates"
1. Click the plus icon next to "Certificates"
1. Under "Services", select "Apple Push Notification service SSL (Sandbox & Production)" and click "Continue"
1. Select the App ID of your app and click "Continue"
1. Upload your certificate signing request and click "Continue"
1. Download your certificate

You now have a `.cer` file which needs to be imported to the keychain so it can be exported as a PKCS #12 archive:

1. Double-click the `.cer` file to add it to your keychain
1. In *Keychain Access*, select the "login" keychain and look for the "Apple Push Services: `<appID>`" certificate
1. Expand this certificate to reveal the private key entry
1. Select both certificate and private key
1. Right-click and select "Export 2 items..."
1. Save the `.p12` file somewhere
    - Leave the password empty
    - Confirm the export with your password and selecting "Allow"

The `Certificates.p12` file contains both the certificate and private key.
To separate them, run the following using the OpenSSL `pkcs12` command:

```console
# export certificate
openssl pkcs12 -in Certificates.p12 -clcerts -nokeys -legacy -out apn.crt
# export private key
openssl pkcs12 -in Certificates.p12 -nodes -nocerts -legacy -out apn.key
```

!!! note "Note on OpenSSL version"

    The above commands assume that you are using OpenSSL v3 which requires the `-legacy` flag.
    This is because older algorithms like the one used by keychain when exporting the certificates are disabled by default.
    If you are using OpenSSL v1.1, remove the `-legacy` flag from the commands.

### Automated deployment

We offer a semi-automated deployment via a [`copier`](https://copier.readthedocs.io/en/stable/) template.
This project template supports various deployment options and sets up the basic project structure to get the Opal PIE deployed in a few minutes.

Please follow the instructions in the [`deploy-pie`](https://github.com/opalmedapps/deploy-pie) repository.

## User Applications

### Deployment diagram

```plantuml source="docs/install/diagrams/deployment_diagram_user.puml"
```

### Requirements

We assume that you already [set up your Firebase project](#create-and-set-up-a-new-firebase-project) and [retrieved Firebase client configurations](../development/local-dev-setup.md#retrieve-the-firebase-project-configurations).
This means that API keys were already created for you which you need for the web and mobile apps.
