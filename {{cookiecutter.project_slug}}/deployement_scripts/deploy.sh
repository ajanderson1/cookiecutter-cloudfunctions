#!/usr/bin/env bash

# Generate requirements.txt file
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
ENV_YAML_FILE="{{cookiecutter.prod_env_file}}"
if [ ! -f "$ENV_YAML_FILE" ]; then
  echo "Missing $ENV_YAML_FILE file - please create one from template before trying again"
  exit 1
fi

# Upload source code to the GCP
echo "Deploying to GCP..."
gcloud functions deploy \
  {{cookiecutter.project_slug}} \
  --project "{{cookiecutter.gcp_project_id}}" \
  --region "{{cookiecutter.gcp_region}}" \
  --entry-point=run_pipeline \
  --runtime=python310 \
  --memory=1G \
  --timeout=9m \
  --env-vars-file="{{cookiecutter.prod_env_file}}" \
  --allow-unauthenticated \
  {% if cookiecutter.trigger_type == 'HTTP' -%}--trigger-http \{% endif -%}
  {% if cookiecutter.trigger_type == 'Cloud Pub/Sub' -%}--trigger-topic="{{ cookiecutter.project_slug }}" \{% endif -%}
  {% if (cookiecutter.trigger_type == 'Cloud Storage') or (cookiecutter.trigger_type == 'Cloud Firestore') -%}
  --trigger-resource=YOUR_TRIGGER_RESOURCE \
  --trigger-event=YOUR_TRIGGER_EVENT \
  {% endif -%}
--build-env-vars-file="{{cookiecutter.build_env_file}}"
