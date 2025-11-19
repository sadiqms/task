# Backups, Disaster Recovery, and On‑Call (Production)

This document outlines backup strategy, disaster recovery (DR) concepts, and the on‑call runbook for production.

---

## Backups (if Database Exists)

- **Frequency:**  
  - Full backup in off peak hours(once a day).

- **Retention:**  
  - Full backups to be retained for 180 days.  

- **Restore Procedure:**  
  1. Identify latest healthy snapshot in AWS RDS or equivalent(the latest backup).  
  2. Restore snapshot to a new DB instance(same/similar DB instance type).  
  3. Point ECS service to restored DB via updated secret in AWS Secrets Manager.  
  4. Validate application health before resuming traffic.  

---

## Disaster Recovery (DR) Concept

- **CloudFront Origin Failover:**  
  - Primary origin: S3 bucket with OAC.  
  - Secondary origin: Backup S3 bucket in another region.  
  - CloudFront origin failover configured to route traffic to secondary if primary is unhealthy.  

- **State Considerations:**  
  - Static assets: replicated across regions (S3 cross‑region replication).  
  - Dynamic state (DB): requires RDS Multi‑AZ or cross‑region read replica.  
  - Failover procedure: switch DNS or CloudFront origin to secondary region, update ECS tasks to point to replica DB.  

---

### Rollback Steps
- If deploy caused incident:  
  1. Roll back ECS tasks to last known good image(the good tag).  
  2. Confirm rollback passes health checks. 
  4. Resume traffic. 

## On‑Call Runbook

### First 15 Minutes Checklist
1. **Acknowledge alert** in PagerDuty/Slack Groups.  
2. **Check dashboards:** ALB error rate, latency, ECS task health, DB health.  
3. **Check logs:** CloudWatch Logs Insights for error spikes.  
4. **Communicate:** Post initial status in #incident channel and contact on-call folks. 

### Comms Template
[Incident Start] 
Service: <name> 
Impact: <users affected, symptoms> 
Start Time: <UTC> 
Current Status: <investigating / mitigated> 
Next Update: <time>

## Lightweight Incident Template
[Incident Report]

Incident ID: <auto‑generated> (pagerduty)
Service: <affected service> 
Severity: <SEV‑1/2/3> 
Start Time: <UTC> 
Status: <open/closed>
Summary: <short description>
Actions Taken:

. Bullet points about actions taken
..........

Next Steps:

. Next steps (Rollback/DR)
. RCA reports/analysis

