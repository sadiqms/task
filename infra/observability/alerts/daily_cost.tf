resource "aws_budgets_budget" "daily_cost" {
  name              = "prod-daily-cost"
  budget_type       = "COST"
  time_unit         = "DAILY"
  limit_amount      = var.daily_cost_limit
  limit_unit        = "USD"

  cost_types { include_support = true }

  notification {
    comparison_operator = "GREATER_THAN"
    threshold           = 80
    threshold_type      = "PERCENTAGE"
    notification_type   = "FORECASTED"
    subscriber_email_addresses = [var.alert_email]
  }

  notification {
    comparison_operator = "GREATER_THAN"
    threshold           = 80
    threshold_type      = "PERCENTAGE"
    notification_type   = "ACTUAL"
    subscriber_email_addresses = [var.alert_email]
  }

  tags = var.tags
}

