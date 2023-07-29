resource "google_cloudfunctions_function" "function" {
  name                  = "{{cookiecutter.function_name}}"
  description           = "{{cookiecutter.function_description}}"
  runtime               =  "python310"
# Code for custom runtimes
#   {% if cookiecutter.gcp_python_runtime == "3.11" %}
#   runtime               = "python311"
#   {% elif cookiecutter.gcp_python_runtime == "3.10" %}
#   runtime               = "python310"
#   {% elif cookiecutter.gcp_python_runtime == "3.9" %}
#   runtime               = "python39"
#   {% elif cookiecutter.gcp_python_runtime == "3.8" %}
#   runtime               = "python38"
#   {% elif cookiecutter.gcp_python_runtime == "3.7" %}
#   runtime               = "python37"
#   {% endif %}
  {% if cookiecutter.function_trigger == "http" %}
  function_entry_point           = "{{cookiecutter.function_entry_point}}"
  {% elif cookiecutter.function_trigger == "cloud storage" %}
  function_entry_point           = "{{cookiecutter.function_entry_point}}"
  {% elif cookiecutter.function_trigger == "pub/sub" %}
  function_entry_point           = "{{cookiecutter.function_entry_point}}"
  {% elif cookiecutter.function_trigger == "firestore" %}
  function_entry_point           = "{{cookiecutter.function_entry_point}}"
  {% endif %}
  source_archive_bucket = google_storage_bucket.bucket.name
  source_archive_object = google_storage_bucket_object.object.name

  timeout               = {{cookiecutter.function_timeout}}
  service_account_email = google_service_account.sa.email
  available_memory_mb   = {{cookiecutter.function_memory}}

  {% if cookiecutter.function_trigger == "http" %}
  trigger_http = true
  {% endif %}
}