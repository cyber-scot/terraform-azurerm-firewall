output "firewall_id" {
  description = "The ID of the Azure Firewall."
  value       = { for k, fw in azurerm_firewall.firewall : k => fw.id }
}

output "firewall_ip_configuration" {
  description = "The IP configuration of the Azure Firewall."
  value       = { for k, fw in azurerm_firewall.firewall : k => fw.ip_configuration }
}

output "firewall_name" {
  description = "The name of the Azure Firewall."
  value       = { for k, fw in azurerm_firewall.firewall : k => fw.name }
}

output "firewall_policy_id" {
  description = "The ID of the Firewall Policy associated with the Azure Firewall."
  value       = { for k, fw in azurerm_firewall.firewall : k => fw.firewall_policy_id }
}

output "firewall_public_ips" {
  description = "The list of public IP addresses associated with the Azure Firewall."
  value       = { for k, pip in azurerm_public_ip.firewall_pip : k => pip.ip_address }
}

output "firewall_sku_name" {
  description = "The SKU name of the Azure Firewall."
  value       = { for k, fw in azurerm_firewall.firewall : k => fw.sku_name }
}

output "firewall_sku_tier" {
  description = "The SKU tier of the Azure Firewall."
  value       = { for k, fw in azurerm_firewall.firewall : k => fw.sku_tier }
}

output "firewall_virtual_hub" {
  description = "The Virtual Hub configuration of the Azure Firewall."
  value       = { for k, fw in azurerm_firewall.firewall : k => fw.virtual_hub }
}

output "public_ip_id" {
  description = "The ID of the Public IP."
  value       = { for k, pip in azurerm_public_ip.firewall_pip : k => pip.id }
}

output "public_ip_name" {
  description = "The name of the Public IP."
  value       = { for k, pip in azurerm_public_ip.firewall_pip : k => pip.name }
}

output "subnet_id" {
  description = "The ID of the Subnet."
  value       = { for k, subnet in azurerm_subnet.firewall_subnet : k => subnet.id }
}

output "subnet_name" {
  description = "The name of the Subnet."
  value       = { for k, subnet in azurerm_subnet.firewall_subnet : k => subnet.name }
}
