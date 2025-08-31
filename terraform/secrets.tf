# secrets.tf
resource "google_secret_manager_secret" "google_api_key_secret" {
  project   = var.gcp_project_id
  secret_id = "GOOGLE_API_KEY" # Name of the secret in Secret Manager

  replication {
    auto {} # Replicate the secret automatically across regions
  }
}

resource "google_secret_manager_secret_version" "google_api_key_secret_version" {
  secret      = google_secret_manager_secret.google_api_key_secret.id
  secret_data = var.google_api_key_value # Value from Terraform variable
}

resource "google_secret_manager_secret" "google_cse_id_secret" {
  project   = var.gcp_project_id
  secret_id = "GOOGLE_CSE_ID" # Name of the secret in Secret Manager

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "google_cse_id_secret_version" {
  secret      = google_secret_manager_secret.google_cse_id_secret.id
  secret_data = var.google_cse_id_value # Value from Terraform variable
}
