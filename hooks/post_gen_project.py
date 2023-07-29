"""Module to cleanup generate repository post generation."""

import os
import json

PROJECT_DIRECTORY = os.path.realpath(os.path.curdir)


def remove_file(filepath: str) -> None:
    """Remove file at given filepath."""
    os.remove(os.path.join(PROJECT_DIRECTORY, filepath))

def get_service_account_email(credentials_file_path):
    """Get the service account email from the credentials file."""
    with open(credentials_file_path, 'r') as json_file:
        data = json.load(json_file)

    if 'client_email' in data:
        return data['client_email']
    else:
        raise ValueError("Invalid credentials file. Could not find 'client_email' field.")


if __name__ == "__main__":
    # AUTHORS
    if "{{ cookiecutter.create_author_file }}" != "y":
        remove_file("AUTHORS.md")

    # LICENSE
    if "{{ cookiecutter.open_source_license }}" == "Not open source":
        remove_file("LICENSE")

    # GitHub Actions
    if "{{ cookiecutter.use_github_actions_for_ci }}" != "y":
        remove_file(".github/workflows/code_quality_checks.yml")

    # CI Checks
    if "{{ cookiecutter.use_flake8 }}" != "y":
        remove_file(".flake8")

    if "{{ cookiecutter.use_mypy }}" != "y":
        remove_file("mypy.ini")

    if "{{ cookiecutter.use_yamllint }}" != "y":
        remove_file("yamllint-config.yml")

    if "{{ cookiecutter.use_terraform }}" != "y":
        remove_file("terraform")

    
    # Path to the credentials JSON file provided by the user during Cookiecutter instantiation.
    credentials_file_path = '{{ cookiecutter.path_to_gcp_credentials }}'
    gcp_service_account_email = get_service_account_email(credentials_file_path)

    # modify the cookiecutter.json file to add the service account email

    cookiecutter_json_path = os.path.join(PROJECT_DIRECTORY, "cookiecutter.json")
    with open(cookiecutter_json_path, 'r') as json_file:
        data = json.load(json_file)

    data['gcp_service_account_email'] = gcp_service_account_email

    with open(cookiecutter_json_path, 'w') as json_file:
        json.dump(data, json_file, indent=4)
        
    