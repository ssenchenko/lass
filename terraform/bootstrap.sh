#!/bin/bash

# This script bootstraps a new project by creating a custom IAM role and granting the necessary permissions to the Terraform service account.

# Exit immediately if a command exits with a non-zero status.
set -e

# Source the environment variables
if [ -f .env ]; then
  export $(cat .env | sed 's/#.*//g' | xargs)
fi

# Check that the required environment variables are set
if [ -z "${GCP_PROJECT_ID}" ] || [ -z "${TERRAFORM_BACKEND_BUCKET}" ]; then
  echo "Error: Please create a .env file from the .env.example template and set the required environment variables."
  exit 1
fi

# Set the Terraform service account email
TERRAFORM_SERVICE_ACCOUNT_EMAIL="github-actions-sa@${GCP_PROJECT_ID}.iam.gserviceaccount.com"

# Create the custom IAM role
if ! gcloud iam roles describe terraformExecutor --project=${GCP_PROJECT_ID} > /dev/null 2>&1; then
  echo "Creating custom IAM role..."
  gcloud iam roles create terraformExecutor --project=${GCP_PROJECT_ID} --file=role-definition.yaml
else
  echo "Custom role already exists. Updating..."
  gcloud iam roles update terraformExecutor --project=${GCP_PROJECT_ID} --file=role-definition.yaml
fi

# Grant the custom Terraform Executor role
echo "Granting custom Terraform Executor role..."
gcloud projects add-iam-policy-binding ${GCP_PROJECT_ID} \
    --member="serviceAccount:${TERRAFORM_SERVICE_ACCOUNT_EMAIL}" \
    --role="projects/${GCP_PROJECT_ID}/roles/terraformExecutor" \
    --condition=None

# Grant the Storage Object Admin role for the Terraform backend bucket
echo "Granting Storage Object Admin role for the Terraform backend bucket..."
gcloud storage buckets add-iam-policy-binding gs://${TERRAFORM_BACKEND_BUCKET} \
    --member="serviceAccount:${TERRAFORM_SERVICE_ACCOUNT_EMAIL}" \
    --role="roles/storage.objectAdmin" \
    --condition=None

echo "Bootstrap complete."
