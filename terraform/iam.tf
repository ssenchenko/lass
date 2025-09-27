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

# Service account for GitHub Actions
resource "google_service_account" "github_actions_sa" {
  account_id   = "github-actions-sa"
  display_name = "GitHub Actions Service Account"
}

# Grant the GitHub Actions service account the Firebase Hosting Admin role
resource "google_project_iam_member" "github_actions_firebase_hosting_admin" {
  project = var.gcp_project_id
  role    = "roles/firebasehosting.admin"
  member  = "serviceAccount:${google_service_account.github_actions_sa.email}"
}

# Grant the GitHub Actions service account the Service Account User role
resource "google_project_iam_member" "github_actions_service_account_user" {
  project = var.gcp_project_id
  role    = "roles/iam.serviceAccountUser"
  member  = "serviceAccount:${google_service_account.github_actions_sa.email}"
}

# Grant the GitHub Actions service account the Firebase Extensions Viewer role
resource "google_project_iam_member" "github_actions_firebase_extensions_viewer" {
  project = var.gcp_project_id
  role    = "roles/firebaseextensions.viewer"
  member  = "serviceAccount:${google_service_account.github_actions_sa.email}"
}

# Grant the GitHub Actions service account the Cloud Functions Admin role
resource "google_project_iam_member" "github_actions_cloud_functions_admin" {
  project = var.gcp_project_id
  role    = "roles/cloudfunctions.admin"
  member  = "serviceAccount:${google_service_account.github_actions_sa.email}"
}

# Grant the GitHub Actions service account the Cloud Run Admin role
resource "google_project_iam_member" "github_actions_cloud_run_admin" {
  project = var.gcp_project_id
  role    = "roles/run.admin"
  member  = "serviceAccount:${google_service_account.github_actions_sa.email}"
}
