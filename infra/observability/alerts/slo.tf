resource "aws_cloudwatch_metric_alarm" "slo_burn_fast" {
  alarm_name          = "prod-slo-burn-fast"
  comparison_operator = "GreaterThanThreshold"
  threshold           = 1
  evaluation_periods  = 6   # 6 x 5min = 30min
  period              = 300
  treat_missing_data  = "notBreaching"

  metric_query {
    id = "req"
    metric {
      namespace  = "AWS/ApplicationELB"
      metric_name= "RequestCount"
      dimensions = { LoadBalancer = var.alb_arn_suffix }
      stat       = "Sum"
      period     = 300
    }
  }
  metric_query {
    id = "err5xx"
    metric {
      namespace  = "AWS/ApplicationELB"
      metric_name= "HTTPCode_Target_5XX_Count"
      dimensions = { LoadBalancer = var.alb_arn_suffix }
      stat       = "Sum"
      period     = 300
    }
  }
  metric_query {
    id          = "rate"
    expression  = "IF(req>0,100*err5xx/req,0)"
    label       = "5xx%"
    return_data = true
  }

  alarm_description   = "SLO burn fast: ALB 5xx% > 1% for 30min"
  alarm_actions       = [var.sns_topic_arn]
  ok_actions          = [var.sns_topic_arn]
  tags                = var.tags
}

