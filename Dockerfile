FROM squidfunk/mkdocs-material:9.6.9

COPY --from=ghcr.io/astral-sh/uv:0.6.6 /uv /uvx /bin/

RUN --mount=type=bind,source=uv.lock,target=uv.lock \
    --mount=type=bind,source=pyproject.toml,target=pyproject.toml \
    uv export --output-file /tmp/requirements.txt && uv pip install --system --no-cache-dir -r /tmp/requirements.txt
