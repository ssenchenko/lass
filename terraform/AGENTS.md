# terraform/AGENTS.md — IaC rules

## Safety
- Minimal changes, no broad refactors.
- Be explicit about what resources will change.
- Never hardcode secret values in `.tf` files.
- Use variables and Secret Manager resources only.
- Avoid changing backend config (`backend.tf`) unless explicitly requested.
- Avoid broad IAM role expansion without justification.

## Commands (run from the relevant module dir)
- `terraform fmt -recursive`
- `terraform validate`

## State & secrets
- Never modify remote state configuration unless required.
- Never commit secrets; use variables and secret managers.
