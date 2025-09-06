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
  ])
  service = each.key

  # Don't disable the service if the resource block is removed by accident.
  disable_on_destroy = false
}

# Describes your existing Firebase Web App.
# You will need to import it into Terraform's state.
resource "google_firebase_web_app" "default" {
  provider     = google-beta
  project      = var.gcp_project_id
  display_name = "web-editor"
}



