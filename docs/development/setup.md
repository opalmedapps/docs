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

### Set up your own Firebase project

The user applications [communicate via Firebase](architecture/index.md#communication-between-user-applications-and-the-opal-pie) with the _Opal PIE_.

[^1]:
    You are welcome to use another container engine.
    However, all the commands shown in our instructions are specific to  `docker` and `docker compose`.
