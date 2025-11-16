output "app_url"         { value = module.container_host.app_url }
output "frontdoor_host"  { value = module.frontdoor.frontdoor_hostname }
output "storage_account" { value = module.static_site.storage_account_name }

