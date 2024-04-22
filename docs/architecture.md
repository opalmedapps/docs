# Architecture

Opal is a solution aimed at providing patients and their caregivers access to the patient's medical data.
Opal provides two main parts to achieve this goal:

1. A patient/caregiver-facing part to give them access to the medical data.
2. A clinical staff facing part to manage the patient data.

!!! note
    The diagrams presented here are based on the [C4 model](https://c4model.com) for visualizing software architecture.
    They are created using the [C4 PlantUML Extension](https://github.com/plantuml-stdlib/C4-PlantUML).

    We use system context and container diagrams. Note that a container represents an application or data store (and not a "Docker container").

## High-level Architecture

The following system context diagram shows a high-level view of the architecture.

```plantuml source="docs/architecture/diagrams/context_diagram.puml"
```

The Opal solution provides the _Opal Patient Information Exchange (PIE)_ which is currently deployed inside a hospital.
The components accessible by caregivers are available via mobile app stores and are also hosted on the web.
These components consist of the user registration web application to create user accounts and the application for patients (or their caregiver(s)) to access the patient's medical data.

### Overview of User Applications

The following container diagram focusses on the user applications that users (caregivers) use with Opal.

```plantuml source="docs/architecture/diagrams/container_diagram_user.puml"
```

As can be seen in the above diagram, communication between the user applications and the Opal PIE is accomplished via Firebase.

### Communication between user applications and the Opal PIE

Firebase Authentication is used for user accounts using email and password.
A Firebase user account is created when a user completes the user registration for the first time.

The user needs to be logged in to Firebase first before being able to communicate to the Opal PIE.
The Firebase Realtime Database acts as a kind of queue for sending requests and receiving responses.

The Opal PIE establishes an outgoing connecting to Firebase to observe the Realtime Database for changes.
Any time a new request is added by a user application it is notified of this change and handles the request.
The response for the request is placed into the Realtime Database and the user application–which is notified of the response–reads and handles the response.
