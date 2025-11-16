module "ecr" {
  source    = "../../modules/aws_ecr"
  repo_name = "flask-app-ecr"
  tags      = local.common_tags
}

module "static" {
  source      = "../../modules/aws_static_site"
  bucket_name = "prod-static-site-${var.github_repo}"
  tags        = local.common_tags
}

module "waf" {
  source = "../../modules/aws_waf"
  name   = "prod-cloudfront-waf"
  tags   = local.common_tags
}

module "app" {
  source           = "../../modules/aws_app"
  vpc_cidr         = "10.10.0.0/16"
  public_subnet_a  = "10.10.1.0/24"
  public_subnet_b  = "10.10.2.0/24"
  az_a             = "us-east-1a"
  az_b             = "us-east-1b"

  cluster_name     = "flask-prod"
  alb_name         = "flask-prod-alb"
  task_family      = "flask-prod-task"
  cpu              = "256"
  memory           = "512"

  image_repo       = module.ecr.repository_url
  image_tag        = var.image_tag

  service_name     = "flask-prod-svc"
  desired_count    = 2

  env_vars         = []
  tags             = local.common_tags
}

module "deploy_role" {
  source      = "../../modules/aws_oidc_role"
  role_name   = "github-oidc-deploy"
  github_org  = var.github_org
  github_repo = var.github_repo
  branch      = var.branch
  tags        = local.common_tags
}
