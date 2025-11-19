# Infrastructure — Staging (Azure) and Production (AWS)

This repository contains Terraform code to provision and manage two environments:

- **Azure Staging** — lightweight environment for testing container builds and static assets.
- **AWS Production** — full ECS Fargate + ALB + CloudFront + WAF setup for live workloads.

---

## CI/CD Artifact Flow

- **Build (GitHub Actions):**
  - Builds Docker images:
    - `ghcr.io/sadiqms/flask-app-acr` (Azure staging)
    - `ghcr.io/sadiqms/flask-app-ecr` (AWS prod)
  - Publishes a `tag.txt` file as a Release asset containing the image tag (`<run>-<sha>`).

- **Deploy (Terraform via CI/CD):**
  - Pipelines fetch the latest `tag.txt` from GitHub Releases.
  - Pass the tag into Terraform as `-var="image_tag=$TF_TAG"`.
  - Terraform updates the container runtime (App Service in Azure, ECS in AWS).

---

## Azure Staging Deployment

### Prerequisites
- Terraform >= 1.5
- Azure CLI (`az login`)
- Remote state backend: Azure Storage Account + container created manually

### Commands
```bash
cd infra/envs/staging-azure
terraform init

# Fetch latest image tag from GitHub Release
TF_TAG=$(
  curl -s https://api.github.com/repos/sadiqms/task/releases/latest \
    | jq -r '.assets[] | select(.name=="tag.txt") | .browser_download_url' \
    | xargs curl -sL | tr -d '\n'
)
echo "Using image tag: $TF_TAG"

# Plan
terraform plan \
  -var="location=westeurope" \
  -var="image_tag=$TF_TAG" \
  -var='tags={"project"="flask-app-acr","env"="staging"}'

# Apply
terraform apply -auto-approve \
  -var="location=westeurope" \
  -var="image_tag=$TF_TAG" \
  -var='tags={"project"="flask-app-acr","env"="staging"}'


##  AWS Production Deployment

### Prerequisites
- Terraform >= 1.5
- AWS CLI (`aws configure`)
- Remote state backend: S3 bucket (+ DynamoDB table for locking optional)

cd infra/envs/prod-aws
terraform init

# Fetch latest image tag from GitHub Release
TF_TAG=$(
  curl -s https://api.github.com/repos/sadiqms/task/releases/latest \
    | jq -r '.assets[] | select(.name=="tag.txt") | .browser_download_url' \
    | xargs curl -sL | tr -d '\n'
)
echo "Using image tag: $TF_TAG"

# Plan
terraform plan \
  -var="aws_region=us-east-1" \
  -var="image_tag=$TF_TAG" \
  -var="github_org=sadiqms" \
  -var="github_repo=flask-app-ecr" \
  -var="branch=main" \
  -var='tags={"project"="flask-app-ecr","env"="prod"}'

# Apply
terraform apply -auto-approve \
  -var="aws_region=us-east-1" \
  -var="image_tag=$TF_TAG" \
  -var="github_org=sadiqms" \
  -var="github_repo=flask-app-ecr" \
  -var="branch=main" \
  -var='tags={"project"="flask-app-ecr","env"="prod"}'