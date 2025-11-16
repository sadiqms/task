output "alb_dns"           { value = module.app.alb_dns_name }
output "ecr_url"           { value = module.ecr.repository_url }
output "cloudfront_domain" { value = module.static.cloudfront_domain }
output "deploy_role_arn"   { value = module.deploy_role.deploy_role_arn }