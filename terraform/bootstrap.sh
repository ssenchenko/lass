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
echo ""
echo "--- GitHub Connection Setup ---"

echo "Initializing Terraform..."
terraform init -upgrade

echo "Applying the initial GitHub connection..."
echo "This will create the connection resource in a pending state."
terraform apply -target=google_developer_connect_connection.my-connection -auto-approve

echo ""
echo "ACTION REQUIRED: Authorize the GitHub App"
echo "----------------------------------------"
echo "Terraform has created a pending connection to GitHub. You must now authorize it."
echo "1. Copy the following URL and open it in your web browser:"
echo ""

# Get the JSON output
ACTION_JSON=$(terraform output -json next_steps)

# Check if jq is installed
if ! command -v jq &> /dev/null
then
    echo "Error: 'jq' is not installed. It is required to parse the Terraform output."
    echo "Please install 'jq' (e.g., 'sudo apt-get install jq' on Debian/Ubuntu, 'brew install jq' on macOS) and run the script again."
    echo ""
    echo "Alternatively, manually extract the 'action_uri' from the JSON below:"
    echo "$ACTION_JSON"
    exit 1 # Exit the script as we cannot proceed automatically
fi

# Parse the action_uri using jq
AUTH_URL=$(echo "$ACTION_JSON" | jq -r '.[0].action_uri')

if [[ -n "$AUTH_URL" ]]; then # Check if AUTH_URL is not empty
    echo "   ${AUTH_URL}"
else
    echo "Could not automatically extract the authorization URL."
    echo "Please find the 'next_steps' output in the apply log above and locate the 'action_uri'."
    echo "$ACTION_JSON" # Print the full JSON for manual inspection
fi

echo ""
echo "2. Follow the instructions in your browser to authorize the 'Google Cloud Firebase App Hosting' app."
echo "3. After authorization is complete, run the full 'terraform apply' from within the 'terraform' directory to finish the setup."
echo ""
echo "GitHub connection bootstrap step complete."

