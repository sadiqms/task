resource "aws_cloudwatch_metric_alarm" "error_rate_5min" {
  alarm_name          = "prod-error-rate-gt-2"
  comparison_operator = "GreaterThanThreshold"
  threshold           = 2
  evaluation_periods  = 1
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

  alarm_description   = "5-min ALB 5xx% > 2%"
  alarm_actions       = [var.sns_topic_arn]
  ok_actions          = [var.sns_topic_arn]
  tags                = var.tags
}

