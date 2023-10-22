resource "azurerm_subnet" "firewall_subnet" {
  count                = var.create_firewall_subnet == true ? 1 : 0
  name                 = var.firewall_subnet_name != null ? var.firewall_subnet_name : "AzureFirewallSubnet"
  resource_group_name  = var.vnet_rg_name != null ? var.vnet_rg_name : var.rg_name
  virtual_network_name = var.vnet_name
  address_prefixes     = var.firewall_subnet_prefixes
}

resource "azurerm_subnet" "firewall_management_subnet" {
  count                = var.create_firewall_management_subnet == true ? 1 : 0
  name                 = var.firewall_management_subnet_name != null ? var.firewall_management_subnet_name : "AzureFirewallManagementSubnet"
  resource_group_name  = var.vnet_rg_name != null ? var.vnet_rg_name : var.rg_name
  virtual_network_name = var.vnet_name
  address_prefixes     = var.firewall_management_subnet_prefixes
}

resource "azurerm_public_ip" "firewall_management_pip" {
  count = var.create_firewall_management_public_ip == true ? 1 : 0

  name                = var.pip_name != null ? var.pip_name : "pip-mgmt-${var.name}"
  location            = var.location
  resource_group_name = var.rg_name
  allocation_method   = var.pip_allocation_method
  domain_name_label   = var.pip_custom_dns_label
  sku                 = var.pip_sku

  lifecycle {
    ignore_changes        = [domain_name_label]
    create_before_destroy = true
  }
}

resource "azurerm_public_ip" "firewall_data_pip" {
  count = var.create_firewall_data_public_ip == true ? 1 : 0

  name                = var.pip_name != null ? var.pip_name : "pip-data-${var.name}"
  location            = var.location
  resource_group_name = var.rg_name
  allocation_method   = var.pip_allocation_method
  domain_name_label   = var.pip_custom_dns_label
  sku                 = var.pip_sku

  lifecycle {
    ignore_changes        = [domain_name_label]
    create_before_destroy = true
  }
}

resource "azurerm_firewall" "firewall" {
  name                = var.name
  location            = var.location
  resource_group_name = var.rg_name
  sku_name            = var.firewall_sku_name
  sku_tier            = title(var.firewall_sku_tier)
  firewall_policy_id  = var.firewall_policy_id
  dns_servers         = toset(var.firewall_dns_servers)
  private_ip_ranges   = var.firewall_snat_addresses
  threat_intel_mode   = title(var.firewall_threat_intel_mode)
  zones               = toset(var.firewall_availability_zones)
  tags                = var.tags

  dynamic "ip_configuration" {
    for_each = var.ip_configuration != null ? [var.ip_configuration] : []
    content {
      name                 = ip_configuration.value.name != null ? ip_configuration.value.name : "ipconfig-${var.name}"
      subnet_id            = ip_configuration.value.subnet_id != null ? ip_configuration.value.subnet_id : azurerm_subnet.firewall_subnet[0].id
      public_ip_address_id = ip_configuration.value.public_ip_address_id != null ? ip_configuration.value.public_ip_address_id : azurerm_public_ip.firewall_data_pip[0].id
    }
  }

  dynamic "management_ip_configuration" {
    for_each = var.management_ip_configuration != null ? [var.management_ip_configuration] : []
    content {
      name                 = management_ip_configuration.value.name != null ? management_ip_configuration.value.name : "ipconfig-mgmt-${var.name}"
      subnet_id            = management_ip_configuration.value.subnet_id != null ? management_ip_configuration.value.subnet_id : azurerm_subnet.firewall_management_subnet[0].id
      public_ip_address_id = management_ip_configuration.value.public_ip_address_id != null ? management_ip_configuration.value.public_ip_address_id : azurerm_public_ip.firewall_management_pip[0].id
    }
  }

  dynamic "virtual_hub" {
    for_each = var.virtual_hub != null ? [var.virtual_hub] : []
    content {
      virtual_hub_id  = virtual_hub.value.virtual_hub_id
      public_ip_count = virtual_hub.value.public_ip_count
    }
  }
}
