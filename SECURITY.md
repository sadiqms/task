# Security Baselines (Production)

This document describes practical hardening controls applied to the production environment, enforcement points, and next steps.

---

## IAM Least Privilege

- **GitHub OIDC → AWS IAM Role**
  - Deploy role created with trust policy for GitHub Actions OIDC provider.

- **Next Steps:** Periodic IAM Access Analyzer review.

---

## Secrets Management

- **AWS Secrets Manager**
  - Application secrets (DB credentials, API keys) can be stored in Secrets Manager.
  - No secrets in Terraform state or GitHub Actions environment.

- **Next Steps:** Enable periodic rotation for db/app credentials.
---

## Image Scanning

- **Trivy in CI**
  - Container images scanned during build pipeline (github actions).
  - ECR also configured to scan images on push.

- **Next Steps:** Add policy to block deployment of non‑compliant images(with vulnerabilities)

---

## HTTPS Everywhere

- **CloudFront Distribution**
  - `viewer_protocol_policy = "redirect-to-https"` ensures all HTTP requests are redirected to HTTPS.
  - CloudFront default certificate enforces TLS for all clients.
- **S3 Origin Access Control**
  - Public access blocked at the S3 bucket (`aws_s3_bucket_public_access_block`).

- **Next Steps:** review access when needed/periodically.

---

## WAF Managed Rules

- **AWS WAF**
  - Web ACL attached to CloudFront distribution.
  - Managed rule groups enabled:
    - AWSManagedRulesCommonRuleSet

- **Next Steps:** Monitor WAF logs in CloudWatch; tune exclusions based on analysis.

---
