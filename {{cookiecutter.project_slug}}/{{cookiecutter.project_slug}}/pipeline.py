import dotenv
import logging

from .utils import running_in_gcp
if not running_in_gcp():
    dotenv.load_dotenv('.env.dev')

logging.basicConfig(level=logging.INFO)
log = logging.getLogger(__name__)


"""Main module."""

def main():
    """Main function."""
    pass
