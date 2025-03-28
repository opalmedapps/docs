<!--
SPDX-FileCopyrightText: Copyright (C) 2025 Opal Health Informatics Group at the Research Institute of the McGill University Health Centre <john.kildea@mcgill.ca>

SPDX-License-Identifier: CC-BY-SA-4.0
-->

# Hospital Integration

An institution or hospital can integrate their data sources with the Opal solution through a series of REST API endpoints provided by the Opal Patient Information Exchange (PIE).
In addition, hospitals must provide some endpoints to Opal in order to facilitate patient demographic lookups, historical data fetching, etc.

Opal source data APIs are provided by the following components within the Opal PIE.

- [OpalAdmin](https://github.com/opalmedapps/opal-admin)
- [Legacy OpalAdmin](https://github.com/opalmedapps/opal-admin-legacy)

In order to successfully integrate the Opal solution with a hospital data system, the above mentioned application container images must be deployed to an application server and configured with database access, SSL certificates, and environment configuration.

## Authentication

Depending on which Opal application is providing the endpoint, the authentication method will be slightly different.

### OpalAdmin

_OpalAdmin_ is built using [Django](https://www.djangoproject.com/) and uses the [Django REST Framework](https://www.django-rest-framework.org/) which provides support for token-based authentication.
During the setup of the Opal PIE, an administrator can issue the hospital data system an API token which should be appended to the headers section of all API requests to _OpalAdmin_, for example:

```bash
curl --location 'https://<host>/api/' \
--header 'Content-Type: application/json' \
--header 'Authorization: Token <token>'
```

### Legacy OpalAdmin

_Legacy OpalAdmin_ exposes an authorization endpoint for system users, using password-based (username & password authentication for a system user.
_Legacy OpalAdmin_ will respond to successful calls at this endpoint with an array of values corresponding to the specific system user and their preferences and permissions.
Also included in the response will be a session/cookie string that should be appended to the headers of future requests to protected endpoints.
For example:

```bash
curl --location 'https://<host>/opalAdmin/user/system-login' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data 'username=<username>&password=<password>'
```

Handle the response and append the cookie string to the next request:

```bash
curl --location 'https://<host>/opalAdmin/patient/get/patient-exist' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--header 'Cookie: sessionId=<sessionid>' \
--data 'mrn=<mrn>&site=<site>'
```

#### Basic Authentication with `traefik`

Use the `htpasswd` utility to create a bcrypt hash, pressing enter when given the opportunity to enter an additional password for the hash.
For example:

```bash
echo $(htpasswd -nB integration_engine) | sed -e s/\\$/\\$\\$/g
```

The username and password used in the Basic Authentication header request from the hospital integration engine needs to be base64 encoded.
So:

```bash
echo -n 'integration_engine:<hash>' | base64
```

The base64 representation of the username:password can then be added as an authorization header in the destination connector settings for our labs channel, prepended by the string `Basic` to indicate the auth type.

```bash
--header 'Authorization Basic <value>'
```

### Opal Room Management System (ORMS)

ORMS separates private from public APIs and thus any calls to the public API endpoints don't require authentication by default.

## Data Format

In general the expectation for all Opal API is that payloads and responses are transmitted in JSON format, with a few exceptions.

- As an experimental feature, the pharmacy data endpoint within the OpalAdmin (`/api/patients/${uuid}/pharmacy`) was created with a built-in HL7 parsing class, the accepted data format is `application/hl7v2+er7`.
- In the `Requirements for Hospital Endpoints` section (see below), the sending of patient weight measurement PDFs from the wait room management system is expected to be sent with XML data containing a base64 string encoding of the measurement PDF.

## OpenAPI Schemas for Opal Source Data

In each of the Opal applications there is an `openapi.yml` file providing full details of all source data endpoints that a hospital can use to send data into the Opal Application Layer.
For `OpalAdmin`, we use [drf-spectacular](https://pypi.org/project/drf-spectacular/)) to dynamically generate the openapi file and render as a swagger doc.
This swagger page is accessible for authenticated users via `/api/schema/swagger-ui`.
For convenience, all endpoints in all openapi specifications related to integrations have been tagged with the `institution integration` label within the openapi specification.

- OpalAdmin: Swagger rendering at `<hostAddress>/api/schema/swagger-ui`
- [Legacy OpalAdmin: openapi.yml](https://github.com/opalmedapps/opaladmin/blob/main/php/openapi.yml)

## Requirements for Hospital Endpoints

In addition to the endpoints Opal provides for data integration, there are also a small number of endpoints that need to be made available to the Opal application layer to facilitate the full range of Opal functionality.
These endpoints should provide information like patient demographics, historical data retrieval, and patient location updates (for hospitals that have chosen to enable the `ORMS` service).

[We also provide an openapi specification roughly outlining what these endpoints should look like.](diagrams/openapi_hospital.yml)
