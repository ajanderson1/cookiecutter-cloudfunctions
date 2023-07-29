resource "google_cloudfunctions_function" "function" {
  name                  = "{{cookiecutter.function_entry_point}}"
  description           = "{{cookiecutter.function_description}}"
  runtime               =  "python310"
  {% if cookiecutter.function_trigger_type == "http" %}
  function_entry_point           = "{{cookiecutter.function_entry_point}}"
  {% elif cookiecutter.function_trigger_type == "cloud storage" %}
  function_entry_point           = "{{cookiecutter.function_entry_point}}"
  {% elif cookiecutter.function_trigger_type == "pub/sub" %}
  function_entry_point           = "{{cookiecutter.function_entry_point}}"
  {% elif cookiecutter.function_trigger_type == "firestore" %}
  function_entry_point           = "{{cookiecutter.function_entry_point}}"
  {% endif %}
  source_archive_bucket = google_storage_bucket.bucket.name
  source_archive_object = google_storage_bucket_object.object.name

  timeout               = {{cookiecutter.function_timeout}}
  service_account_email = google_service_account.sa.email
  available_memory_mb   = {{cookiecutter.function_memory}}

  {% if cookiecutter.function_trigger_type == "http" %}
  trigger_http = true
  {% endif %}
}