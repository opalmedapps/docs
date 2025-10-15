# SPDX-FileCopyrightText: Copyright (C) 2022 Opal Health Informatics Group at the Research Institute of the McGill University Health Centre <john.kildea@mcgill.ca>
#
# SPDX-License-Identifier: MIT

FROM squidfunk/mkdocs-material:9.6.22

COPY --from=ghcr.io/astral-sh/uv:0.9.3 /uv /uvx /bin/

RUN --mount=type=bind,source=uv.lock,target=uv.lock \
    --mount=type=bind,source=pyproject.toml,target=pyproject.toml \
    uv export --output-file /tmp/requirements.txt && uv pip install --system --no-cache-dir -r /tmp/requirements.txt
