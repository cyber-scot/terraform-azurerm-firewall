output "firewall_data_public_ip_address" {
  description = "The address of the firewall public IP."
  value       = azurerm_public_ip.firewall_data_pip[0].ip_address
}

output "firewall_data_public_ip_fqdn" {
  description = "The Fully Qualified Domain Name (FQDN) of the firewall public IP."
  value       = azurerm_public_ip.firewall_data_pip[0].fqdn
}

output "firewall_data_public_ip_id" {
  description = "The ID of the firewall public IP."
  value       = azurerm_public_ip.firewall_data_pip[0].id
}

output "firewall_id" {
  description = "The ID of the firewall."
  value       = azurerm_firewall.firewall.id
}

output "firewall_ip_configuration" {
  description = "The IP configuration of the firewall."
  value       = azurerm_firewall.firewall.ip_configuration
}

output "firewall_management_ip_configuration" {
  description = "The management IP configuration of the firewall."
  value       = azurerm_firewall.firewall.management_ip_configuration
}

output "firewall_management_public_ip_address" {
  description = "The address of the firewall public IP."
  value       = azurerm_public_ip.firewall_management_pip[0].ip_address
}

output "firewall_management_public_ip_fqdn" {
  description = "The Fully Qualified Domain Name (FQDN) of the firewall public IP."
  value       = azurerm_public_ip.firewall_management_pip[0].fqdn
}

output "firewall_management_public_ip_id" {
  description = "The ID of the firewall public IP."
  value       = azurerm_public_ip.firewall_management_pip[0].id
}

output "firewall_management_subnet_id" {
  description = "The ID of the management firewall subnet."
  value       = azurerm_subnet.firewall_management_subnet[0].id
}

output "firewall_name" {
  description = "The name of the firewall."
  value       = azurerm_firewall.firewall.name
}

output "firewall_rg_name" {
  description = "The resource group name of the firewall."
  value       = azurerm_firewall.firewall.resource_group_name
}

output "firewall_subnet_id" {
  description = "The ID of the firewall subnet."
  value       = azurerm_subnet.firewall_subnet[0].id
}

output "firewall_tags" {
  description = "The tags of the firewall."
  value       = azurerm_firewall.firewall.tags
}

output "firewall_virtual_hub_configuration" {
  description = "The virtual hub configuration of the firewall."
  value       = azurerm_firewall.firewall.virtual_hub
}
