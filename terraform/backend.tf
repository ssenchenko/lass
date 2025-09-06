terraform {
  backend "gcs" {
    bucket  = "learning-assistant-poc-tfstate"
    prefix  = "terraform/state"
  }
}
