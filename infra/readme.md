# Terraform DevOps Project

Production‑grade DevOps setup using:
- Terraform
- AWS
- GitHub Actions
- OIDC (no long‑lived credentials)

## Environments
- dev
- stage
- prod

## Features
- PR-based Terraform plans
- Manual approval for prod
- Security scanning (tfsec, checkov)
- Canary deployments