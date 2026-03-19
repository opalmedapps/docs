<!--
SPDX-FileCopyrightText: Copyright (C) 2022 Opal Health Informatics Group at the Research Institute of the McGill University Health Centre <john.kildea@mcgill.ca>

SPDX-License-Identifier: MIT
-->

# Decisions

We use [Architecture Decision Records (ADR)](https://adr.github.io/) to record architecture decisions, whether the decision concerns architecture, code, project setup or something else.
In this repository, architecture decisions are those that impact the whole Opal solution.
Architecture decisions within particular components are contained in their corresponding repository.
Read more about the [benefits of ADRs and when to write them](https://engineering.atspotify.com/2020/04/when-should-i-write-an-architecture-decision-record).

The ADRs live in `docs/development/architecture/decisions/` and follow the [Markdown Architecture Decision Record (MADR) format](https://adr.github.io/madr/) in version `4.0.0`.

We recommend the use of the tool [`adrs`](http://joshrotenberg.com/adrs/) to help manage ADRs.

The following table shows all ADRs:

{{ adr_summary(adr_path="docs/development/architecture/decisions/", adr_style="MADR4", template_file="overrides/adr-summary.jinja") }}
