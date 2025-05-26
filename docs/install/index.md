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

### Automated deployment

We offer a semi-automated deployment via a [`copier`](https://copier.readthedocs.io/en/stable/) template.
This project template supports various deployment options and sets up the basic project structure to get the Opal PIE deployed in a few minutes.

Please follow the instructions in the [`deploy-pie`](https://github.com/opalmedapps/deploy-pie) repository.

## User Applications

### Deployment diagram

```plantuml source="docs/install/diagrams/deployment_diagram_user.puml"
```
