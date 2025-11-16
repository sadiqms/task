resource "aws_wafv2_web_acl" "cf" {
  name        = var.name
  scope       = "CLOUDFRONT"
  description = "WAF for CloudFront with AWS managed core rules"

  default_action { allow {} }

  rule {
    name     = "AWSManagedRulesCommonRuleSet"
    priority = 1
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      sampled_requests_enabled   = true
      metric_name                = "awsmanaged-common"
    }
    override_action { none {} }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    sampled_requests_enabled   = true
    metric_name                = "cf-waf"
  }

  tags = var.tags
}

