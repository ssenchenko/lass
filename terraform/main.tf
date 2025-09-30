terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "7.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 6.0"
    }
    random = {
      source = "hashicorp/random"
      version = "3.1.0"
    }
  }
}

# Configures the provider to use the resource block's specified project for quota checks.
provider "google-beta" {
  project               = var.gcp_project_id
  user_project_override = true
}

# Configures the provider to not use the resource block's specified project for quota checks.
# This provider should only be used during project creation and initializing services.
provider "google-beta" {
  alias                 = "no_user_project_override"
  project               = var.gcp_project_id
  user_project_override = false
}


provider "google" {
  project = var.gcp_project_id
  region  = "us-central1"
}

resource "random_string" "site_id_suffix" {
  length  = 8
  special = false
  upper   = false
}

resource "google_firebase_project" "default" {
  project = var.gcp_project_id
  provider = google-beta
}

# Ensures required APIs are enabled for the project.
resource "google_project_service" "default" {
  project  = var.gcp_project_id
  for_each = toset([
    "cloudbilling.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "firebase.googleapis.com",
    "serviceusage.googleapis.com",
    "secretmanager.googleapis.com",
    "firebaseapphosting.googleapis.com",
  ])
  service = each.key

  # Don't disable the service if the resource block is removed by accident.
  disable_on_destroy = false
}

resource "time_sleep" "wait_for_api_enablement" {
  depends_on = [google_project_service.default]
  create_duration = "30s"
}

# Describes your existing Firebase Web App.
# You will need to import it into Terraform's state.
resource "google_firebase_web_app" "default" {
  provider     = google-beta
  project      = var.gcp_project_id
  display_name = "web-editor"
}

resource "google_firebase_hosting_site" "default" {
  provider = google-beta
  project = var.gcp_project_id
  site_id = "web-editor-${random_string.site_id_suffix.result}"
}

resource "google_firebase_app_hosting_backend" "default" {
  depends_on = [time_sleep.wait_for_api_enablement]
  project = var.gcp_project_id
  location = "us-central1"
  backend_id = google_firebase_hosting_site.default.site_id
  display_name = "web-editor"
  serving_locality = "GLOBAL_ACCESS"
  app_id = google_firebase_web_app.default.app_id
  service_account = data.google_service_account.firebase_functions_sa.email
}

output "firebase_hosting_site_id" {
  value = google_firebase_hosting_site.default.site_id
}

output "github_actions_service_account_email" {
  value = google_service_account.github_actions_sa.email
}

output "workload_identity_provider" {
  value = google_iam_workload_identity_pool_provider.github_actions_provider.name
}

resource "google_artifact_registry_repository" "functions_repository" {
  project       = var.gcp_project_id
  location      = "us-central1"
  repository_id = "gcf-artifacts"
  format        = "DOCKER"
  description   = "Repository for Cloud Functions container images, managed by Terraform."

  cleanup_policies {
    id     = "keep-the-last-100-images"
    action = "KEEP"
    most_recent_versions {
      keep_count = 10
    }
  }
}
