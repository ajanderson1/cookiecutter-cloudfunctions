provider "google" {
  project = var.gcp_project_id
  region  = var.gcp_region
}

# Associate the project with billing
resource "google_project_service" "billing" {
  project = google_project.new_project.project_id
  service = "cloudbilling.googleapis.com"
}

# Add the "Owner" role to the service account
resource "google_project_iam_member" "service_account_owner" {
  project = google_project.new_project.project_id
  role    = "roles/owner"
  member  = "serviceAccount:${google_service_account.service_account.email}"
}

# Add a repository to Cloud Source Repositories
resource "google_sourcerepo_repository" "repository" {
  name     = "my-repo"
  project  = google_project.new_project.project_id
}

# Create a trigger to build the repository on push
resource "google_cloudbuild_trigger" "trigger" {
  name                 = "{{cookiecutter.project_slug}}-trigger}}"
  description          = "Cloud build trigger for {{cookiecutter.project_slug}}."
  project              = google_project.new_project.project_id
  trigger_template {
    branch_name       = "main"
    repo_name         = google_sourcerepo_repository.repository.name
  }
  build {
    tag_name          = "v1.0.0"
    substitutions = {
      _TAG            = "v1.0.0"
    }
    steps {
      name             = "gcr.io/cloud-builders/docker"
      args             = ["build", "-t", "gcr.io/${google_project.new_project.project_id}/my-app:${_TAG}", "."]
    }
  }
}


output "function_url" {
  description = "URL to trigger the deployed Google Cloud Function."
  value       = google_cloudfunctions_function.function.https_trigger_url
}

# Add other outputs as needed...
