"""Module to check inputs before project generation."""
import re
import sys
import os
import json


MODULE_REGEX = r"^[_a-zA-Z][_a-zA-Z0-9]+$"

MODULE_NAME = "{{ cookiecutter.project_slug }}"

if not re.match(MODULE_REGEX, MODULE_NAME):
    print(
        f"ERROR: The project slug ({MODULE_NAME}) is not a valid Python module name. Please do not "
        f"use '-' and use '_' instead."
    )

    # Exit to cancel project
    sys.exit(1)


def get_service_account_email(credentials_file_path):
    with open(credentials_file_path, 'r') as json_file:
        data = json.load(json_file)

    if 'client_email' in data:
        return data['client_email']
    else:
        raise ValueError("Invalid credentials file. Could not find 'client_email' field.")

# Path to the credentials JSON file provided by the user during Cookiecutter instantiation.
credentials_file_path = '{{ cookiecutter.path_to_gcp_credentials }}'
gcp_service_account_email = get_service_account_email(credentials_file_path)


from cookiecutter.main import cookiecutter

from datetime import datetime

cookiecutter(
    'cookiecutter-cloudfunctions',
    extra_context={'cookiecutter_created': datetime.utcnow().isoformat()}
)
cookiecutter(
    'cookiecutter-cloudfunctions',
    extra_context={'gcp_service_account_email': gcp_service_account_email}
)