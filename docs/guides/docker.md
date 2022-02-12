# Docker

## Best practices

* Specify full version tag to allow for reproducible builds (e.g., `node:17.3.0-bullseye` instead of `node:17`, `node:17-bullseye` etc.)
* Don’t run app as root in container

## Resources

* [Best practices for writing Dockerfiles | Docker Documentation](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/) (see also [Reviewing the official Dockerfile best practices: good, bad, insecure](https://pythonspeed.com/articles/official-docker-best-practices/))
* [Broken by default: why you should avoid most Dockerfile examples](https://pythonspeed.com/articles/dockerizing-python-is-hard/)
* [The worst so-called “best practice” for Docker](https://pythonspeed.com/articles/security-updates-in-docker/)
* [Less capabilities, more security: preventing Docker escalation attacks](https://pythonspeed.com/articles/root-capabilities-docker-security/)
