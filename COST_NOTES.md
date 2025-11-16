# Cost & Performance Notes (Production)

This document summarizes cost/performance trade‑offs and practical defaults for the small service.

---

## ALB vs API Gateway vs CloudFront‑only

### Application Load Balancer (ALB)
- **Pros:**  
  - Native integration with ECS/Fargate and AWS WAF.  
  - Supports path‑based routing and target groups.  
  - Predictable pricing model (per‑hour + per‑LCU).  
- **Cons:**  
  - Higher fixed baseline cost compared to API Gateway or CloudFront.  
  - Limited built‑in features for authentication or throttling.  
- **Typical Cost (small scale):** Around $20–30/month baseline plus usage.

---

### API Gateway
- **Pros:**  
  - Rich features: built‑in authentication, throttling, caching.  
  - Fully serverless, scales automatically.  
  - Pay‑per‑request pricing, no fixed hourly cost.  
- **Cons:**  
  - Higher latency compared to ALB.  
  - More expensive per request at scale.  
  - Overkill for simple health checks or lightweight APIs.  
- **Typical Cost (small scale):** About $3.50 per million requests.

---

### CloudFront‑only
- **Pros:**  
  - Cheapest option for static assets.  
  - Global CDN with edge caching.  
  - HTTPS redirect supported; integrates with S3 Origin Access Control.  
- **Cons:**  
  - Limited to static content unless paired with Lambda@Edge.  
  - No dynamic routing or API features.  
- **Typical Cost (small scale):** ~$0.085 per GB of data transfer.
---

## Default Autoscaling Policy

- **ECS Service Autoscaling:**
  - Target tracking policy on `CPUUtilization` at 80%.
  - Min tasks: 2 (HA baseline).
  - Max tasks: 4 (guardrail).

---


## Caching Strategy (Static Assets)

- **CloudFront:**
  - Default TTL: 1 hour.
  - Max TTL: 24 hours.
  - Cache key: path only (no query string).
- **S3 Origin Access Control:** Public access blocked; CloudFront handles caching and HTTPS.

---

## Daily Budget Guardrail

- **AWS Budgets:**
  - Daily limit: $x USD. (defined in the alerts)
  - Alerts:
    - Forecasted spend > 80% of limit.
    - Actual spend > 80% of limit.
- **Pipeline Toggle:**
  - we can set CI/CD pipeline checks budget status before deploy.
  - If budget exceeded, pipeline halts prod deploy step.

---

## Near‑Term Optimizations

1. Analyse traffic pattern and decide on ALB vs API Gateway vs CloudFront‑only and ECS/Kubernetes
2. fine tune ECS Autoscaling.

--