variable "alb_arn_suffix" {
  description = "ARN suffix of the Application Load Balancer (for CloudWatch metrics)"
  type        = string
}

variable "target_group_arn_suffix" {
  description = "ARN suffix of the Target Group (for CloudWatch metrics)"
  type        = string
}

variable "aws_region" {
  description = "AWS region for CloudWatch metrics"
  type        = string
  default     = "us-east-1"
}

variable "sns_topic_arn" {
  description = "SNS topic ARN for CloudWatch alarm notifications"
  type        = string
}

variable "daily_cost_limit" {
  description = "Daily cost budget limit in USD"
  type        = number
  default     = 20
}

variable "alert_email" {
  description = "Email address for AWS Budgets notifications"
  type        = string
}

variable "tags" {
  description = "Common tags to apply to observability resources"
  type        = map(string)
  default     = {}
}

