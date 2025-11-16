# AWS Observability & SLOs (for Production)

## SLOs
1. **Monthly availability ≥ 99.9%** for the API (measured via ALB 5xx rate).
2. **P95 latency ≤ 300ms** on `/healthz` requests (measured via ALB TargetResponseTime).

## Dashboard
See `aws/dashboards/aws_cloudwatch_dashboard.json` for a CloudWatch dashboard stub with:
- ALB 5xx error rate (%)
- ALB TargetResponseTime p95 for `/healthz`

Deploy dashboard with:
```bash
aws cloudwatch put-dashboard \
  --dashboard-name prod-app \
  --dashboard-body file://aws/dashboards/aws_cloudwatch_dashboard.json

```
## Alerts

1. SLO -- CloudWatch alarm for SLO burn
2. error_rate -- CloudWatch alarm for short‑term error spikes (5‑min error‑rate > 2%).
3. daily_cost -- AWS Budgets alert for daily cost threshold.