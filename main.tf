resource "azurerm_subnet" "firewall_subnet" {
  for_each             = { for fw in var.firewall : fw.name => fw if fw.create_firewall_subnet == true }
  name                 = each.value.firewall_subnet_name
  resource_group_name  = each.value.rg_name
  virtual_network_name = each.value.target_firewall_vnet_name
  address_prefixes     = each.value.firewall_subnet_prefixes
}

resource "azurerm_public_ip" "firewall_pip" {
  for_each = { for fw in var.firewall : fw.name => fw if fw.create_firewall_public_ip == true }

  name                = each.value.pip_name != null ? each.value.pip_name : "pip-${each.value.name}"
  location            = each.value.location
  resource_group_name = each.value.rg_name
  allocation_method   = each.value.pip_allocation_method
  domain_name_label   = try(each.value.pip_custom_dns_label, each.value.computer_name, null)
  sku                 = each.value.pip_sku

  lifecycle {
    ignore_changes        = [domain_name_label]
    create_before_destroy = true
  }
}

resource "azurerm_firewall" "firewall" {
  for_each            = { for fw in var.firewall : fw.name => fw if fw.create_firewall_public_ip == true }
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.rg_name
  sku_name            = each.value.firewall_sku
  sku_tier            = title(each.value.firewall_sku_tier)
  firewall_policy_id  = each.value.firewall_policy_id
  dns_servers         = toset(each.value.firewall_dns_servers)
  private_ip_ranges   = each.value.firewall_snat_addresses
  threat_intel_mode   = title(each.value.firewall_threat_intel_mode)
  zones               = toset(each.value.firewall_availability_zones)

  dynamic "ip_configuration" {
    for_each = each.value.ip_configuration != null ? [each.value.ip_configuration] : []
    content {
      name                 = ip_configuration.value.name != null ? ip_configuration.value.name : "ipconfig-${each.value.name}"
      subnet_id            = ip_configuration.value.subnet_id != null ? ip_configuration.value.subnet_id : azurerm_subnet.firewall_subnet[each.key].id
      public_ip_address_id = ip_configuration.value.public_ip_address_id != null ? ip_configuration.value.public_ip_address_id : azurerm_public_ip.firewall_pip[each.key].id
    }
  }

  dynamic "management_ip_configuration" {
    for_each = each.value.management_ip_configuration != null ? [each.value.management_ip_configuration] : []
    content {
      name                 = management_ip_configuration.value.name != null ? management_ip_configuration.value.name : "ipconfig-${each.value.name}"
      subnet_id            = management_ip_configuration.value.subnet_id != null ? management_ip_configuration.value.subnet_id : azurerm_subnet.firewall_subnet[each.key].id
      public_ip_address_id = management_ip_configuration.value.public_ip_address_id != null ? management_ip_configuration.value.public_ip_address_id : azurerm_public_ip.firewall_pip[each.key].id
    }
  }

  dynamic "virtual_hub" {
    for_each = each.value.virtual_hub != null ? [each.value.virtual_hub] : []
    content {
      virtual_hub_id  = virtual_hub.value.virtual_hub_id
      public_ip_count = virtual_hub.value.public_ip_count
    }
  }
}
