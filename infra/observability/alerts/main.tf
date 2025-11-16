########################################
# Observability Module — AWS
########################################

# Import variables
# (alb_arn_suffix, target_group_arn_suffix, aws_region, sns_topic_arn, daily_cost_limit, alert_email, tags)

# SLO Burn Alert
module "slo_burn" {
  source = "./slo.tf"
}

# Error Rate Alert
module "error_rate" {
  source = "./error_rate.tf"
}

# Daily Cost Alert
module "daily_cost" {
  source = "./daily_cost.tf"
}
