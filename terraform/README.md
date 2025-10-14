# Terraform Bootstrap Instructions

This document outlines the one-time setup steps required to configure the service account that runs the Terraform workflows for this project.

## Prerequisites

1.  You have the `gcloud` CLI installed and authenticated.
2.  You have a Google Cloud project created.
3.  You have a Cloud Storage bucket created to be used as the Terraform backend.

## Step 1: Set Environment Variables

Replace the placeholder values with your actual project details.

```bash
export GCP_PROJECT_ID="your-gcp-project-id"
export TERRAFORM_SERVICE_ACCOUNT_EMAIL="github-actions-sa@${GCP_PROJECT_ID}.iam.gserviceaccount.com"
export TERRAFORM_BACKEND_BUCKET="your-terraform-backend-bucket-name"
```

## Step 2: Create the Custom Role

This command creates a custom IAM role with the minimum necessary permissions for the Terraform service account to do its job.

```bash
gcloud iam roles create terraformExecutor --project=${GCP_PROJECT_ID} --file=role-definition.yaml
```

## Step 3: Grant Permissions to the Service Account

These commands grant the newly created custom role and other necessary roles to the Terraform service account.

```bash
# Grant the custom Terraform Executor role
gcloud projects add-iam-policy-binding ${GCP_PROJECT_ID} \
    --member="serviceAccount:${TERRAFORM_SERVICE_ACCOUNT_EMAIL}" \
    --role="projects/${GCP_PROJECT_ID}/roles/terraformExecutor"

# Grant the Storage Object Admin role for the Terraform backend bucket
gcloud storage buckets add-iam-policy-binding gs://${TERRAFORM_BACKEND_BUCKET} \
    --member="serviceAccount:${TERRAFORM_SERVICE_ACCOUNT_EMAIL}" \
    --role="roles/storage.objectAdmin"
```

## Step 4: Apply Terraform

After completing the above steps, you can now run `terraform apply` to create and manage the rest of the infrastructure.

```bash
terraform apply
```
