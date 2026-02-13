<!--
SPDX-FileCopyrightText: Copyright (C) 2022 Opal Health Informatics Group at the Research Institute of the McGill University Health Centre <john.kildea@mcgill.ca>

SPDX-License-Identifier: CC-BY-SA-4.0
-->

# Opal Documentation

This is the technical documentation for [Opal](https://www.opalmedapps.com) – the open source patient-in-the-loop data platform.
We've grouped together information on using, contributing, and deploying Opal.

Opal is an award-winning open source patient-in-the-loop data platform, connecting patients, clinicians, industry partners and researchers.
Opal provides real-time access for patients to their medical data, through a host of features,
such as appointments, lab results, clinical notes, personalized educational and reference materials,
questionnaires, connection to smart devices, on-site appointment check-in and call-in, e-consent, data donation, etc.
To learn more about Opal, visit us at https://www.opalmedapps.com/.

## Structure of the Documentation

To explore the documentation on this site, use the tabs at the top of this page.
Each tab has a sidebar on the left listing its sub-pages.
The following is a high-level overview of each section:

1. [User Guide](user/index.md) (coming soon): instructions on navigating and configuring the Opal system as an end-user or administrator.
1. [Contribute](development/index.md): everything you need to know as a developer to contribute to Opal's open-source development:
    - [Architecture](development/architecture/index.md)
    - [Setting up a local development environment](development/local-dev-setup.md)
1. [Install](install/index.md) (coming soon): how to deploy the Opal system in an environment

## Try it Yourself

If you'd like to get a feel for the experience of using Opal as a patient, try it yourself by logging into a test account in our demo hospitals.

1. Download the `Opal - Patient in the loop` app from the [Google Play Store](https://play.google.com/store/apps/details?id=com.hig.opal2)
    or [Apple App Store](https://apps.apple.com/ca/app/opal-patient-in-the-loop/id1446920350).
1. Launch the app, and log in with a test account[^1].
    Under the password field, you'll be prompted to choose a hospital: Select `Opal Demo 1`.
1. Take a look around the app, and feel free to try out all the features (including answering questionnaires, checking into appointments, etc.).

!!! info

    Due to the app's security settings, each account only allows one concurrent login.
    If another user logs into the account you're using, you'll be logged out with the message "You have logged in on another device".
    The number of available test accounts will be adjusted according to demand; to report an issue, please contact us at `___`.

[^1]: We will add test account credentials to this page soon.
    If you are eager to try it out in the meantime, please [reach out to us](https://www.opalmedapps.com/).
