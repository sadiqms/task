locals {
  common_tags = merge(var.tags, { env = "staging", owner = "platform" })
}

