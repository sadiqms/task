resource "random_string" "rand" {
  length  = 6
  upper   = false
  special = false
}

module "container_host" {
  source         = "../../modules/azure_container_host"
  resource_group = "rg-staging"
  location       = var.location
  app_name       = "flask-staging"
  image_repo     = "ghcr.io/sadiqms/flask-app-acr"
  image_tag      = var.image_tag
  tags           = local.common_tags
}

module "static_site" {
  source         = "../../modules/azure_static_site"
  storage_name   = "stgstatic${random_string.rand.result}"
  resource_group = "rg-staging"
  location       = var.location
  tags           = local.common_tags
}

module "frontdoor" {
  source         = "../../modules/azure_cdn_frontdoor"
  fd_name        = "fd-staging-flask"
  resource_group = "rg-staging"
  backend_host   = module.container_host.app_url
  tags           = local.common_tags
}

