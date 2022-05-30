# Current versions of software in use by O-HIG

The following table provides an overview of the current software in use.

| Tool           | Info  |
| -------------- | ----- |
| node           | https://nodejs.org/en/about/releases/ |
| pm2            | https://pm2.keymetrics.io/docs/usage/process-management/ |
| Apache         | https://httpd.apache.org/ |
| PHP            | https://www.php.net/downloads.php |
| MariaDB        | https://mariadb.org/download |
| Python         | https://www.python.org/downloads/ |
| Java (OpenJDK) | https://docs.microsoft.com/en-us/java/openjdk/download |

Current versions can be seen based on the Docker image with the specific version tags in below file. Dependency updates to the file `versions.Dockerfile` are facilitated using the Renovate Bot. This allows us to keep track of updates to images in an easier way.

```docker title="versions.Dockerfile"

--8<-- "versions.Dockerfile"

```
