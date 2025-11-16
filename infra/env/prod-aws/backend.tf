terraform {
  required_version = ">= 1.6.0"
  backend "s3" {
    bucket  = "<your-tf-state-bucket>"
    key     = "prod-aws/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
    # dynamodb_table = "<optional-lock-table>"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}