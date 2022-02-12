# Python


## Code Style

* [PEP 8 — the Style Guide for Python Code](https://pep8.org/)
* [PEP 257 -- Docstring Conventions | Python.org](https://www.python.org/dev/peps/pep-0257/)
* Enforced by [flake8](https://github.com/pycqa/flake8)
* Consistent use of quotes: Single quotes (enforced by [flake8-quotes](https://github.com/zheller/flake8-quotes))
* Sort Imports (enforced by [isort](https://github.com/pycqa/isort) via [flake8-isort](https://github.com/gforcada/flake8-isort))
* Write type hints to help with static type checking through mypy
    * [Type Hints in Python — Everything You Need To Know In 5 Minutes](https://towardsdatascience.com/type-hints-in-python-everything-you-need-to-know-in-5-minutes-24e0bad06d0b)
    * [Type hints cheat sheet (Python 3) — Mypy documentation](https://mypy.readthedocs.io/en/stable/cheat_sheet_py3.html)
    * [Support for type hints — Python 3 documentation](https://docs.python.org/3/library/typing.html)


## Type Checking



* Static type checking is performed using [mypy](http://www.mypy-lang.org/)
* To fully leverage this, type hints should be added to all code (this is enforced by mypy)
* This also helps the IDE in providing appropriate help when writing code
* A lot of Python packages support type hints and provide mypy types declarations (e.g., there is a `types-requests` package for `requests`, mypy will warn about this when run)


## Unit Testing

Unit tests are executed using [pytest](https://github.com/pytest-dev/pytest) and coverage is checked using [coverage](https://github.com/pytest-dev/pytest).

Additionally, mocking can be done using the additional pytest plugin [pytest-mock](https://github.com/pytest-dev/pytest-mock/).

For complex migrations in Django that require Python code to run, there is the plugin [django-test-migrations](https://github.com/wemake-services/django-test-migrations) which allows to accomplish this.


## (Upgrading) Dependencies

If not already done by an automatic dependency checker (see above), dependencies can be upgraded via [pip-upgrader](https://github.com/simion/pip-upgrader).


## Django Migrations

When writing migrations in Django that require custom Python code to be executed (using the RunPython migration), forward and backward code needs to be provided to ensure that the database can be migrated in both directions without encountering any errors.

!!! todo "TBD"

    Have a checker check for this (pylint has a plugin)
