# Set up a local development environment

The current supported way is to set up everything locally on your machine.
This guide is split into several aspects of the [Opal solution](architecture/index.md#high-level-architecture) because some components are less frequently worked on.

## Required software

In general, all projects with the exception of one project (the mobile app) are containerized.
Therefore, the required software to be installed on your machine directly is fairly small.

* [Git](https://git-scm.com/) for version control
* [Git Large File Storage (LFS)](https://git-lfs.com/) is used by some projects to version large files
* [Docker Desktop](https://www.docker.com/products/docker-desktop/)[^1]
* An IDE, such as [Visual Studio Code](https://code.visualstudio.com/)
* [Node.js](https://nodejs.org/en) to build and run the mobile app (as a web app)

??? info "Note about `node`"

    It can be beneficial to use the [Node Version Manager (nvm)](https://github.com/nvm-sh/nvm) if you intend to try out different Node versions.
    Otherwise, using a package manager (such as Homebrew) to install Node is sufficient.

## Supported operating systems

As our team uses macOS (Apple Silicon) and Windows machines we strive to support both these operating systems for local development.

## Set up main components

The components most frequently being worked on are the user and clinical staff facing ones.
Therefore, the following instructions focus on these components.
The other components are considered optional.

!!! tip "Clone repositories using the GitLab CLI"

    Instead of cloning repositories "manually" by copying their git URL from the project page and cloning it via `git clone` it is also possible to use the [GitLab CLI](https://docs.gitlab.com/ee/editor_extensions/gitlab_cli/) to do so.

    The CLI provides the [`repo clone`](https://gitlab.com/gitlab-org/cli/-/blob/main/docs/source/repo/clone.md) command to clone repositories.
    Note that if you clone all repositories of a group you will clone more repositories than you actually need.

### Set up your own Firebase project

The user applications [communicate via Firebase](architecture/index.md#communication-between-user-applications-and-the-opal-pie) with the _Opal PIE_.
You need your own Firebase project so that your local app can communicate with the backend components.

!!! note

    Firebase is a Google product.
    Therefore, you need a Google account to be able to use Firebase.

#### Create a new Firebase project

1. Open the [Firebase Console](https://console.firebase.google.com)
2. Click on "+ Add project"
3. Give it a relevant project name, such as "Opal Local"
4. Uncheck "Enable Google Analytics for this project"
5. Click "Create project"

The "Authentication" and "Realtime Database" features are needed for the communication.

#### Create a new Realtime Database

1. In the left panel of your newly created Firebase project, expand "Build" and click on "Realtime Database".
2. Click "Create Database"
3. On the second step of "Set up database" (Security rules), select "Start in test mode".

!!! note Security rules

    This configures your Realtime Database to be accessible to anyone for 30 days.
    It is also possible to restrict access to authenticated users only by specifying the condition as `auth.uid !== null`.
    However, not all features will work.
    The rules in use by the Opal solution can be found in the [listener project](https://gitlab.com/opalmedapps/opal-listener/-/blob/main/firebase/dev/database.rules.json).
    See the [instructions on how to deploy them](https://opalmedapps.gitlab.io/opal-listener/tutorial-firebase-rules.html) to your project or copy-and-paste them into your project's rules.

See also the Firebase documentation on [Firebase Security Rules](https://firebase.google.com/docs/rules).

#### Enable email and password authentication

1. In the left panel, expand "Build" and click on "Authentication"
2. Click on "Get started"
3. Choose "Email/Password" as the sign-in provider
4. Enable "Email/Password" and click "Save"

See also the Firebase documentation on [Firebase Authentication](https://firebase.google.com/docs/auth).

#### Retrieve the Firebase project configurations

Retrieve the client configuration:

1. Click on the settings icon (gear) next to "Project Overview"
2. Click on "Project Settings"
3. In the "General" tab, under "Your Apps", click the "</>" icon
4. Choose an app nickname, such as "Opal Local"
5. Click "Register app"
6. Copy the code and save it somewhere for later

Retrieve the private key for the admin SDK:

1. Go back to the "Project Settings" page and click on the "Service accounts" tab
2. Click on "Generate new private key" and then "Generate key"
3. Download the file somewhere safe on your machine for later

See also the Firebase documentation on [Admin SDK Authentication](https://firebase.google.com/docs/database/admin/start).

### Set up the backend

Follow the [backend README](https://gitlab.com/opalmedapps/backend/-/blob/main/README.md) to set it up.

In addition, there are management commands that initialize required data as well as test data.

Run the following management commands on the backend:

```python
python manage.py initialize_data
python manage.py insert_test_data OMI
```

See the command's help to learn about all options.

The `initialize_data` command generates authentication tokens for system users that are needed for configuring other components.

### Set up the legacy databases

All legacy databases are managed using [Alembic](https://alembic.sqlalchemy.org/en/latest/).
Follow the instructions in the [db-docker README](https://gitlab.com/opalmedapps/db-docker/-/blob/main/README.md) to set them up.

Ensure that you also insert the test data via the `reset_data.sh` script as outlined in the instructions.

### Set up the listener

Follow the instructions outlined in the [listener README](https://gitlab.com/opalmedapps/opal-listener/-/blob/main/README.md) to set it up.

Once the listener is running, initialize the test users in Firebase with the [initialize_users script](https://gitlab.com/opalmedapps/opal-listener/-/blob/main/src/firebase/initialize_users.js):

```shell
docker compose exec app node src/firebase/initialize_users.js
```

The script creates several test users all with the same password (see the script).

### Set up opalAdmin

Follow the instructions outlined in the [opalAdmin README](https://gitlab.com/opalmedapps/opalAdmin/-/blob/develop/README.md) to set it up.

### Set up the mobile app

Follow the instructions outlined in the [mobile app README](https://gitlab.com/opalmedapps/qplus/-/blob/main/README.md).

[^1]:
    You are welcome to use another container engine.
    However, all the commands shown in our instructions are specific to  `docker` and `docker compose`.
