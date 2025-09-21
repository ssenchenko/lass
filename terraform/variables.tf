variable "gcp_project_id" {
  description = "Your Google Cloud Project ID"
  type        = string
}

variable "github_repository" {
  description = "The GitHub repository in the format <owner>/<repo>"
  type        = string
}

variable "google_api_key_value" {
  description = "The actual value of your Google API Key"
  type        = string
  sensitive   = true
}

variable "google_cse_id_value" {
  description = "The actual value of your Google Custom Search Engine ID"
  type        = string
  sensitive   = true
}
