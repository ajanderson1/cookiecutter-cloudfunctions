{% set is_open_source = cookiecutter.open_source_license != 'Not open source' -%}
{% set project_github_link = cookiecutter.project_slug | replace("_", "-") -%}
# {{ cookiecutter.project_name }}

{%- if is_open_source %}
[![PyPI version](https://badge.fury.io/py/{{ project_github_link }}.svg)](https://badge.fury.io/py/{{ project_github_link }})
![versions](https://img.shields.io/pypi/pyversions/{{ project_github_link }}.svg)
[![GitHub license](https://img.shields.io/github/license/{{ cookiecutter.github_username }}/{{ project_github_link }}.svg)](https://github.com/{{ cookiecutter.github_username }}/{{ project_github_link }}/blob/main/LICENSE)
{%- endif %}
{% if cookiecutter.use_black %}
[![Code style: black](https://img.shields.io/badge/code%20style-black-000000.svg)](https://github.com/psf/black)
{%- endif %}

{{ cookiecutter.project_short_description }}

{%- if is_open_source %}
- Free software: {{ cookiecutter.open_source_license }}
- Documentation: https://{{ cookiecutter.github_username }}.github.io/{{ project_github_link }}.
{%- endif %}

## CI/CD Commands 
```sh
# Unit/coverage testing
poetry run pytest

# Styling
poetry run flake8 {{cookiecutter.project_slug}}/ tests/ main.py

# Formatting
poetry run black .

# Type hinting
poetry run mypy
```



*This project was created with [Cookiecutter](https://github.com/audreyr/cookiecutter) and [ajanderson1/cookiecutter-cloudfunctions](https://github.com/ajanderson1/cookiecutter-cloudfunctions.git) (forked from [audreyr/cookiecutter-pypackage](https://github.com/askarthur/cookiecutter-cloudfunctions.git)