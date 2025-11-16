resource "azurerm_frontdoor" "fd" {
  name                = var.fd_name
  resource_group_name = var.resource_group
  location            = "Global"

  routing_rule {
    name               = "default"
    accepted_protocols = ["Https"]
    frontend_endpoints = [azurerm_frontdoor_frontend_endpoint.fd_fe.name]
    patterns_to_match  = ["/*"]

    forwarding_configuration {
      forwarding_protocol = "HttpsOnly"
      backend_pool_name   = azurerm_frontdoor_backend_pool.fd_bp.name
    }
  }

  backend_pool {
    name = "pool"
    backend {
      host_header = var.backend_host
      address     = var.backend_host
      http_port   = 80
      https_port  = 443
    }
  }

  frontend_endpoint {
    name      = "fe"
    host_name = "${var.fd_name}.azurefd.net"
  }

  tags = var.tags
}

