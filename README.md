<!--
SPDX-FileCopyrightText: Copyright (C) 2022 Opal Health Informatics Group at the Research Institute of the McGill University Health Centre <john.kildea@mcgill.ca>

SPDX-License-Identifier: MIT
-->

# Opal Documentation

[![ci](https://github.com/opalmedapps/docs/actions/workflows/ci.yml/badge.svg)](https://github.com/opalmedapps/docs/actions/workflows/ci.yml) [![Docs](https://img.shields.io/badge/docs-available-brightgreen.svg)](https://docs.opalmedapps.com)

Project for the Opal documentation site.

This project uses [MkDocs](https://www.mkdocs.org) and in particular the [Material for MkDocs](https://squidfunk.github.io/mkdocs-material/) theme.
Material for MkDocs makes use of [Python Markdown](https://python-markdown.github.io/) and the [Python Markdown Extensions](https://facelessuser.github.io/pymdown-extensions/).

In addition, we use the [PlantUML Markdown extension](https://github.com/mikitex70/plantuml-markdown) to render [PlantUML](https://plantuml.com) diagrams.

The documentation site is deployed to GitHub Pages at https://docs.opalmedapps.com.

## Contributing

All documentation is written in Markdown and located in the `docs/` directory.

The documentation is split into several parts:

- `user` contains the user guide
- `development` contains information about contributing to Opal
- `deploy` contains information about how to deploy and run Opal, and how to integrate the Opal services with a hospital

### Getting started

> [!NOTE]
> If you use [GitHub Codespaces](https://github.com/features/codespaces) or use a *Dev Container* extension, you do not need to do any of the below steps.
> They are run automatically on startup.

All you need is [`uv`](https://docs.astral.sh/uv) to set up your environment.

```shell
uv sync
```

If no matching Python installation can be found it will download it for you.

Install the [`pre-commit`](https://pre-commit.com/) hooks:

```shell
pre-commit install
```

Then, run the development server to serve the site locally:

```shell
uv run mkdocs serve -a localhost:8001
```

You can then access the site at: http://localhost:8001

When you make changes to the documentation, the server reloads automatically and the page is refreshed in the browser.

### Linting

The Markdown files are linted with [`markdownlint`](https://github.com/DavidAnson/markdownlint) via [markdownlint-cli2](https://github.com/DavidAnson/markdownlint-cli2).
If you are using Visual Studio Code, the [markdownlint vscode extension](https://marketplace.visualstudio.com/items?itemName=DavidAnson.vscode-markdownlint) ensures that you can see linting results in the editor as you type.

Linting is performed when you make a commit (via the `pre-commit` hooks) and in CI.

While we do not enforce [semantic line breaks](https://sembr.org), we strongly recommend to put each sentence on its own line.
This makes it easier to read in source and also easier to review changes to the text.

**Note:** This is an additional rule for `markdownlint`.
Due to a [limitation](https://github.com/DavidAnson/vscode-markdownlint/issues/336) with the vscode extension this rule is currently only enabled in CI.

### Adding a new page

When you add a new page, you must add it to the `nav` section in `mkdocs.yml` in order for it to appear in the navigation menu.

## License

Please refer to the `LICENSE` file in this repository for information about licensing.
