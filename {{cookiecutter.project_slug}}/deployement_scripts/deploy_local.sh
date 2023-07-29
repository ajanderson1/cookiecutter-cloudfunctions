#!/usr/bin/env bash

# USAGE:
# from project root:
# > ./deployment_scripts/deploy_local.sh
#
# This will run the function locally using functions_framework, this can be tested using:
# > curl -X POST \                                         
#   -H "Content-type:application/json" \
#   -d  '{<message body here>}' \
#   -w '\n' \
#   http://localhost:8080

# # Generate requirements.txt file  -  ORIGINAL VERSION
echo "Generating requirements.txt..."
poetry install --no-interaction 
poetry export --no-interaction --without-hashes --format requirements.txt --output requirements.txt


# Remove all instances of '@HEAD' from the input file and save the result in the output file
# Create a temporary file to store modified content
temp_file=$(mktemp)
# Remove all instances of '@HEAD' from requirements.txt and save the result in the temporary file
sed 's/@HEAD//' requirements.txt > "$temp_file"
# Overwrite the original requirements.txt with the content from the temporary file
mv "$temp_file" requirements.txt
echo "Instances of '@HEAD' removed."


# Check existence of file with environment variables
ENV_DEV_FILE={{cookiecutter.dev_env_file}}
if [ ! -f "$ENV_DEV_FILE" ]; then
  echo "WARNING: Missing $ENV_DEV_FILE file - please create one from template before trying again"
  exit 1
fi

# Upload source code to the GCP
echo "Deploying locally using functions_framework..."

echo "WARNING: This is only for HTTP triggers, not tested with Pub/Sub or Storage triggers"

python3 -m functions_framework \
--port 8080 \
--target {{cookiecutter.function_entry_point}} \
--signature-type http \
--source main.py \
--debug