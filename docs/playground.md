# Playground

For full documentation visit:

* [MkDocs](https://www.mkdocs.org)
* [Material for MkDocs](https://squidfunk.github.io/mkdocs-material/)
* [Python Markdown](https://python-markdown.github.io/)
* [Python Markdown Extensions](https://facelessuser.github.io/pymdown-extensions/)

## Commands

* `mkdocs new [dir-name]` - Create a new project.
* `mkdocs serve` - Start the live-reloading docs server.
* `mkdocs build` - Build the documentation site.
* `mkdocs -h` - Print help message and exit.

## Project layout

    mkdocs.yml    # The configuration file.
    docs/
        index.md  # The documentation homepage.
        ...       # Other markdown pages, images and other files.

## Footnotes

Lorem ipsum[^1] dolor sit amet, consectetur adipiscing elit[^2].
Nulla et euismod nulla.
Curabitur feugiat, tortor non consequat finibus, justo purus auctor
massa, nec semper lorem quam in massa.

## Code blocks

```python title="test.py" linenums="1" hl_lines="2"
import markdown
md = markdown.Markdown(extensions=['pymdownx.highlight'])
```

The `#!python range()` function is used to generate a sequence of numbers.

## Keys

++ctrl+alt+del++

## Tabbed Content

=== "Mac"

    ```bash
    python3.9 -m venv .venv
    source .venv/bin/activate
    ```

=== "Windows"

    ```shell
    python3.exe -m venv .venv
    exec .venv/bin/activate
    ```

## Tasklist

* [x] Task 1
* [ ] Task 2
    * [x] Subtask 1
    * [ ] Subtask 2
* [ ] Task 3

## Tables

| Method      | Description                          |
| ----------- | ------------------------------------ |
| `GET`       | :material-check:     Fetch resource  |
| `PUT`       | :material-check-all: Update resource |
| `DELETE`    | :material-close:     Delete resource |

## Admonition

!!! note "Example"

    Lorem ipsum dolor sit amet, consectetur adipiscing elit.
    Nulla et euismod nulla.
    Curabitur feugiat, tortor non consequat finibus, justo purus auctor
    massa, nec semper lorem quam in massa.

???+ note "Example"

    Lorem ipsum dolor sit amet, consectetur adipiscing elit.
    Nulla et euismod
    nulla.
    Curabitur feugiat, tortor non consequat finibus, justo purus auctor
    massa, nec semper lorem quam in massa.

!!! info inline end

    Lorem ipsum dolor sit amet, consectetur adipiscing elit.
    Nulla et euismod
    nulla.
    Curabitur feugiat, tortor non consequat finibus, justo purus auctor
    massa, nec semper lorem quam in massa.

Lorem ipsum dolor sit amet, consectetur adipiscing elit.
Nulla et euismod nulla.
Curabitur feugiat, tortor non consequat finibus, justo purus auctor
massa, nec semper lorem quam in massa.

[^1]: Lorem ipsum dolor sit amet, consectetur adipiscing elit.

[^2]:
    Lorem ipsum dolor sit amet, consectetur adipiscing elit.
    Nulla et euismod nulla.
    Curabitur feugiat, tortor non consequat finibus, justo purus auctor
    massa, nec semper lorem quam in massa.
