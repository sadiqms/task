Infrastructure — Staging (Azure) and Production (AWS)

This repository contains Terraform code and pipeline definitions to provision and manage two environments:

- Azure Staging — lightweight Kubernetes environment for testing container builds and Helm chart deployments.
- AWS Production — full ECS Fargate + ALB + CloudFront + WAF setup for live workloads.

---

CI/CD Artifact Flow

Build (GitHub Actions — ci.yml)
- Builds Docker images:
  - ghcr.io/sadiqms/flask-app-acr (Azure staging)
  - ghcr.io/sadiqms/flask-app-ecr (AWS production)
- Packages Helm chart from helm/flask-app/ and pushes it to GHCR:
  - ghcr.io/sadiqms/flask-app:<run>-<sha>
- Publishes a tag.txt file as a Release asset containing the image/chart tag (<run>-<sha>).
- Runs Trivy scan on the built image to enforce security.

Deploy (Azure Pipeline — azure-pipeline.yml)
- Fetches the latest tag.txt from GitHub Releases.
- Logs in to GHCR and pulls the Helm chart (oci://ghcr.io/sadiqms/flask-app).
- Deploys to Kubernetes with Helm, setting the image repository and tag dynamically:
  - Staging uses ghcr.io/sadiqms/flask-app-ecr
  - Production uses ghcr.io/sadiqms/flask-app-acr
- Saves the last known-good tag for rollback.
- Rollback stage redeploys the previous chart/image if staging or production fails.

---

Azure Staging Deployment

Prerequisites
- Helm >= 3.7 (OCI support enabled by default)
- Azure CLI (az login)
- Kubernetes cluster configured and accessible
- Pipeline secret GHCR_PAT with read:packages scope

Deployment Flow
1. CI publishes Docker image, Helm chart, and tag.txt to GitHub Release + GHCR.
2. Azure Pipeline fetches tag.txt and pulls the Helm chart from GHCR.
3. Helm upgrades/installs the release in the default namespace:
   helm upgrade --install flask-app oci://ghcr.io/sadiqms/flask-app --version <TAG> \
     --namespace default \
     --set image.repository=ghcr.io/sadiqms/flask-app-acr \
     --set image.tag=<TAG>

---

AWS Production Deployment

Prerequisites
- Helm >= 3.7
- AWS CLI (aws configure)
- Kubernetes cluster configured (EKS or other)
- Pipeline secret GHCR_PAT with read:packages scope

Deployment Flow
1. CI publishes Docker image, Helm chart, and tag.txt to GitHub Release + GHCR.
2. Azure Pipeline fetches tag.txt and pulls the Helm chart from GHCR.
3. Helm upgrades/installs the release in the default namespace:
   helm upgrade --install flask-app oci://ghcr.io/sadiqms/flask-app --version <TAG> \
     --namespace default \
     --set image.repository=ghcr.io/sadiqms/flask-app-ecr \
     --set image.tag=<TAG>
4. Last known-good tag is saved for rollback.

---

Rollback

If staging or production deployment fails:
- Pipeline downloads the last known-good tag artifact.
- Helm redeploys the chart with the previous image tag:
  helm upgrade --install flask-app oci://ghcr.io/sadiqms/flask-app --version <GOOD_TAG> \
    --namespace default \
    --set image.repository=ghcr.io/sadiqms/flask-app-ecr \
    --set image.tag=$GOOD_TAG

---

Summary

- GitHub Actions CI builds/pushes Docker images and Helm charts to GHCR, and publishes tag.txt.
- Azure Pipeline CD consumes those artifacts, pulls the Helm chart from GHCR, and deploys to Kubernetes in staging and production.
- Rollback is supported via the last known-good tag.