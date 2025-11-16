output "frontdoor_hostname" { value = azurerm_frontdoor.fd.frontend_endpoints[0].host_name }

