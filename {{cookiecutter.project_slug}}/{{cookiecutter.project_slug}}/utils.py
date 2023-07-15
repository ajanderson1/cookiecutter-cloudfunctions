import os
import csv

import logging
log = logging.getLogger(__name__)


def running_in_gcp():
    " Determines if running in local development context or GCP context."
    try:
        if os.environ["RUNNING_IN_GCP"]:
            log.critical(f'Running in GCP')
            return True
        else:
            log.critical(f'Running in Locally')
            return False
    except KeyError as err:
        log.critical(f'Running in Locally')
        return False
