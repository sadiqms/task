locals {
  common_tags = merge(var.tags, { env = "prod", owner = "platform" })
}

