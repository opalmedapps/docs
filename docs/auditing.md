# Opal PIE Data Auditing

This document describes the frameworks and configurations used for auditing of opal system data. This includes CRUD operations on all opal database schemas, administrative user logins, server requests, and user privelege alterations.

## Django EasyAudit App

For any data stored in the newer Django database schema, auditing is handled by the [Django EasyAudit App](https://github.com/soynatan/django-easy-audit).  EasyAudit covers auditing of database CRUD events, application login events, and server request events. All data can be viewed/searched from the django administration panel, or directly in the django database schema in the easyaudit_* tables.

We have configured the easy audit system to disallow delete events on audit data and to disable user existence checks on the database. We also append POST request parameters to RequestEvent objects specifically for the Questionnaire Export feature to allow for better visibility on what data has been exported from the OpalAdmin system.

## MariaDB Audit Plugin

This section describes auditing frameworks and procedures for legacy database OpalDB, QuestionnaireDB, and OrmsDatabase.

[As of MariaDB 5.5.34](https://mariadb.com/kb/en/mariadb-audit-plugin/), there is a built-in configurable audit system to capture all database-level interactions with MariaDB installations. In May of 2024 we switched to using this audit plugin to replace both the ORMS [System Versioning](https://mariadb.com/kb/en/system-versioned-tables/), which was causing increasing query slowness and table locking, as well as the OpalDB MH table system which is cumbersome to maintain compared to the audit plugin.

By default the Audit Plugin logs all events in the format
`Timestamp, MySQL host, database user, host connected from, connection ID, thread ID, operation, database name, SQL statement, return code`

### Audit Tuning

[This guide provides a breakdown of some of the audit ‘tuning’ that can be done with this plugin.](https://severalnines.com/blog/tips-and-trick-using-audit-logging-mariadb/)

All configurations are set in the mariadb.conf file for the database. For local developers, this file is located in the [db-docker repository](https://gitlab.com/opalmedapps/db-docker/-/blob/main/config/mariadb.cnf?ref_type=heads). For our live development environments, each environment’s database has its own .conf file on the database server (lxvmri04).

We can choose to capture all audit events, or exclude some depending on our requirements in each development environment (and the space these audit files require)

| Event Type | Description |
|----------- | ----------- |
| CONNECT | Connects, disconnects and failed connects, including the error code |
| QUERY | Queries executed and their results in plain text, including failed queries due to syntax or permission errors |
| TABLE | Tables affected by query execution |
| QUERY_DDL | Similar to QUERY, but filters only DDL-type queries (CREATE, ALTER, DROP, RENAME and TRUNCATE statements – except CREATE/DROP [PROCEDURE / FUNCTION / USER] and RENAME USER (they’re not DDL) |
| QUERY_DML | Similar to QUERY, but filters only DML-type queries (DO, CALL, LOAD DATA/XML, DELETE, INSERT, SELECT, UPDATE, HANDLER and REPLACE statements) |
| QUERY_DML_NO_SELECT | Similar to QUERY_DML, but doesn’t log SELECT queries. (since version 1.4.4) (DO, CALL, LOAD DATA/XML, DELETE, INSERT, UPDATE, HANDLER and REPLACE statements) |
| QUERY_DCL | Similar to QUERY, but filters only DCL-type queries (CREATE USER, DROP USER, RENAME USER, GRANT, REVOKE and SET PASSWORD statements) |

For the first pass at enabling this plugin, we have set the option list to 'CONNECT,QUERY_DDL,QUERY_DML,QUERY_DCL,TABLE', meaning that we will capture basically everything. However we may choose to change this option depending on the size of the resultant log files.

The full audit tuning can be checked from the database via:

`SHOW GLOBAL VARIABLES LIKE 'server_audit%';`

### Log File Rotation

In order to control the size of the log file, we can also set up automatic log file rotations within our logging directory. We specify two parameters: A maximum size per log file, and a maximum number of rotated log files before the oldest log file gets overwritten.

We have these set to 1MB and 30 files respectively.

### Searching Log Files

Given the size of the log files, it would be prudent to programmatically search for specific contents based on the use case. A few examples are provided below:

First navigate to the logging directory. For local developers, connect to the database docker container

`docker compose exec db bash`

`cd /var/log/mysql`

Then perform a grep search over all of the log files, since we don’t necessarily know which log file within the rotation set has the pertinent audit information. If we wanted to find query involving updates to the Diagnosis table, for example:

`grep -i ‘update diagnosis’ *`

Or to look for instances of privilege escalation:

`grep -i ‘grant’ *`
