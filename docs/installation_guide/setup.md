# Set up a local development environment

The current supported way is to set up everything locally on your machine.
This guide is split into several aspects of the [Opal solution](architecture/index.md#high-level-architecture) because some components are less frequently worked on.

## Supported operating systems

As our team uses macOS (Apple Silicon) and Windows machines we strive to support both these operating systems for local development.

## Part 0: Prerequisite Software and Setup

### Prerequisite Software

This guide outlines the essential and recommended software required for developing with Opal. You can opt for recommended software used by the team to enhance collaboration and support during the setup process. If you are comfortable with equivalent tools, feel free to use them. Each tool is labeled FE (frontend), BE (backend), or both to indicate its applicability.

## Software Installation Guide for Opal Development

### Required Software

- **Git (FE, BE)**
    - **Purpose**: Version control
    - **Installation**: Check with `git --version`, [Windows](https://git-scm.com/download/win), [MacOS](https://git-scm.com/download/mac)

- **Git LFS (FE, BE)**
    - **Purpose**: Versioning large files
    - **Installation**: [Git LFS](https://git-lfs.github.com/)

- **Docker Desktop (BE)**
    - **Purpose**: Containerization of projects
    - **Installation**: [Docker Desktop](https://www.docker.com/products/docker-desktop/)

- **IDE (Visual Studio Code or other) (FE, BE)**
    - **Purpose**: Coding, with global search and navigation features
    - **Installation**: [Visual Studio Code](https://code.visualstudio.com/)

- **Node.js (FE, BE)**
    - **Purpose**: Build and run the mobile app as a web app
    - **Installation**: [Node.js](https://nodejs.org/en)
    - **Note**: Consider using [Node Version Manager (nvm)](https://github.com/nvm-sh/nvm) for managing multiple Node versions.

- **Database Viewer (HeidiSQL, MySQL Workbench) (BE)**
    - **Purpose**: Database interaction
    - **Installation**: [HeidiSQL for Windows](https://www.heidisql.com/download.php), [MySQL Workbench for MacOS and Windows](https://www.mysql.com/products/workbench/)

### Recommended Software

- **Text Editor (Notepad++ or other) (FE, BE)**
    - **Purpose**: Quick edits of code and config files
    - **Installation**: [Notepad++ for Windows](https://notepad-plus-plus.org/downloads/)

- **Git GUI (SourceTree or other) (FE, BE)**
    - **Purpose**: Graphical interface for git version control
    - **Installation**: [SourceTree for Windows and MacOS](https://www.sourcetreeapp.com/)

- **Advanced IDE (WebStorm, PhpStorm, Visual Studio) (FE, BE)**
    - **Purpose**: Enhanced coding environment with error detection
    - **Note**: Free for students with a McGill email ([WebStorm](https://www.jetbrains.com/webstorm/download/#section=windows), [PhpStorm](https://www.jetbrains.com/phpstorm/download/#section=windows)), consult Opal team for other licenses.

- **Local Server Environment (XAMPP/MAMP) (BE) [Optional - not needed if using Docker]**
    - **Purpose**: MySQL support for local databases
    - **Installation**: XAMPP for [Windows and MacOS](https://www.apachefriends.org/index.html) (install in default directory to avoid errors), MAMP for [Mac systems](https://www.mamp.info/en/downloads/).

## Instructions for Cloning Repositories

Here is the recommended file structure for your Opal installation.

```
<root folder>
└─── Opal
```

Then follow these steps to clone all repositories at once under the group `opalmedapps` using `glab` :

1. **Install Glab**  
   Open your terminal and install `glab` by running the following command:

   ```bash
   brew install glab
   ```

2. **Authenticate your session with glab by executing**

   ```bash
   glab auth login
   ```

3. **To clone all the repositories under the group opalmedapps, use the command:**

   ```bash
   glab repo clone -g opalmedapps --paginate
   ```

## Set up main components

### Pre-Setup Instructions for Local Development

Before you begin setting up your local development environment, please make sure to review the [Architecture Overview](https://opalmedapps.gitlab.io/docs/architecture/). Understanding the overview will help you comprehend the role and relationships of each component within the system.

### Required Projects for Local Setup

To run the application locally, you will need to set up the following required projects following their `README`:

Required project for Frontend:

- **qplus**: The mobile app component.
  
Required project for Backend (Complete installation):

- **qplus**: The mobile app component.
- **Backend**
- **db-docker**: This is for the legacy databases.
- **opal-listener**
- **opalAdmin**
- **Firebase**

Each of these projects has a `README` file with detailed instructions on how to set it up, including how to run each component as a container.

### Part 1: Frontend Only (qplus project)

This part of the installation guide will help you install a local copy of the frontend application that will connect to the live listener, database and firebase located at the MUHC (in the staging environment, which is used by developers, not patients).
This is similar to having the Opal Staging app on your phone.

If you would like to install a complete development environment of Opal on your computer, you must complete Part 1 before moving on to Part 2. If you only need the frontend app, only follow Part 1.

Read the rest of the Part 1 instructions below, then follow the qplus' `README` here: https://gitlab.com/opalmedapps/qplus.
Make sure you are on the **staging** branch's README. Start from the beginning and follow all sections except
those mentioned as being excluded below.

- Skip the section on "Installing, building, and serving the mobile **app code**". The app code section describes how to build
    the app for a mobile device, which you won't need to do while developing in a browser (you'll follow the section on **web code**
    instead).  Also skip the section "Optional dev server".

- If you see a 404 error when visiting the README, this means you haven't been added as a contributor to the qplus repository yet;
    in this case, ask an Opal team member for help. If you run into problems and cannot solve them using the Troubleshooting section,
    don't worry. Reach out to an Opal team member for help.

- While developing, you will most often be using `npm run start` (which is an alias for `npm run start:web`).
    This command uses `webpack-dev-server` to serve the app in a browser, and to auto-reload the app when you make changes to the code.
    You shouldn't need to use scripts that begin with `npm run build:`, which build the app in `www` and don't auto-reload changes.

### Part 2: Complete Development Installation (with Backend)

You must have successfully completed Part 1 (qplus Installation) before following Part 2. Part 2 will help you set up a complete local development copy of Opal. This means that you will have the frontend app, firebase, listener and database all running together on your computer.

Follow the instructions on the [backend installation](./backend-installation.md) page.

### Optional Projects

There are additional projects mentioned in the [Architecture Overview](https://opalmedapps.gitlab.io/docs/architecture/) that are optional for basic setup. These are only required if you need specific features that they provide.

Please ensure that all the necessary tools and projects are properly installed and configured before proceeding with the development setup.
