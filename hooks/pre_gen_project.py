"""Module to check inputs before project generation."""
import re
import sys


MODULE_REGEX = r"^[_a-zA-Z][_a-zA-Z0-9]+$"

MODULE_NAME = "{{ cookiecutter.project_slug }}"

if not re.match(MODULE_REGEX, MODULE_NAME):
    print(
        f"ERROR: The project slug ({MODULE_NAME}) is not a valid Python module name. Please do not "
        f"use '-' and use '_' instead."
    )

    # Exit to cancel project
    sys.exit(1)


import os
import json

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

# Store the service account email in a Cookiecutter variable for use in the template.
cookiecutter_config = '{{ cookiecutter }}'
cookiecutter_config['gcp_service_account_email'] = gcp_service_account_email

# Save the updated Cookiecutter configuration back to the file.
with open('cookiecutter.json', 'w') as config_file:
    json.dump(cookiecutter_config, config_file)
