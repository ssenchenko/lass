# Get the default App Engine service account (used by Firebase Functions)
data "google_service_account" "firebase_functions_sa" {
  account_id = "${var.gcp_project_id}@appspot.gserviceAccount.com"
  project    = var.gcp_project_id
}

# Grant the service account access to the GOOGLE_API_KEY secret
resource "google_secret_manager_secret_iam_member" "google_api_key_access" {
  project   = google_secret_manager_secret.google_api_key_secret.project
  secret_id = google_secret_manager_secret.google_api_key_secret.secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${data.google_service_account.firebase_functions_sa.email}"
}

# Grant the service account access to the GOOGLE_CSE_ID secret
resource "google_secret_manager_secret_iam_member" "google_cse_id_access" {
  project   = google_secret_manager_secret.google_cse_id_secret.project
  secret_id = google_secret_manager_secret.google_cse_id_secret.secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${data.google_service_account.firebase_functions_sa.email}"
}
