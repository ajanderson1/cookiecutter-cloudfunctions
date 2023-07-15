import os
import dotenv
import logging

from .utils import running_in_gcp
if not running_in_gcp():
    dotenv.load_dotenv('.env.dev')

logging.basicConfig(level=logging.INFO)
log = logging.getLogger(__name__)


def main():
    """Main function."""
    log.info(f"{{cookiecutter.project_slug}}: {{cookiecutter.project_short_description}} is running...")
    log.info(f"These are the environment variables: {os.environ}")
    return "Success.", 200