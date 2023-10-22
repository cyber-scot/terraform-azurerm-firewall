
```hcl
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
  firewall_policy_id = each.value.firewall_policy_id
  dns_servers       = toset(each.value.firewall_dns_servers)
  private_ip_ranges = each.value.firewall_snat_addresses
  threat_intel_mode = title(each.value.firewall_threat_intel_mode)
  zones             = toset(each.value.firewall_availability_zones)

  dynamic "ip_configuration" {
    for_each = each.value.ip_configuration != null ? [each.value.ip_configuration] : []
    content {
      name = ip_configuration.value.name != null ? ip_configuration.value.name : "ipconfig-${each.value.name}"
      subnet_id = ip_configuration.value.subnet_id != null ? ip_configuration.value.subnet_id : azurerm_subnet.firewall_subnet[each.key].id
      public_ip_address_id = ip_configuration.value.public_ip_address_id != null ? ip_configuration.value.public_ip_address_id : azurerm_public_ip.firewall_pip[each.key].id
    }
  }

  dynamic "management_ip_configuration" {
    for_each = each.value.management_ip_configuration != null ? [each.value.management_ip_configuration] : []
    content {
        name = management_ip_configuration.value.name != null ? management_ip_configuration.value.name : "ipconfig-${each.value.name}"
      subnet_id = management_ip_configuration.value.subnet_id != null ? management_ip_configuration.value.subnet_id : azurerm_subnet.firewall_subnet[each.key].id
      public_ip_address_id = management_ip_configuration.value.public_ip_address_id != null ? management_ip_configuration.value.public_ip_address_id : azurerm_public_ip.firewall_pip[each.key].id
    }
  }

  dynamic "virtual_hub" {
    for_each = each.value.virtual_hub != null ? [each.value.virtual_hub] : []
    content {
      virtual_hub_id = virtual_hub.value.virtual_hub_id
      public_ip_count = virtual_hub.value.public_ip_count
    }
  }
}
```
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_firewall.firewall](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall) | resource |
| [azurerm_public_ip.firewall_pip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_subnet.firewall_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_firewall"></a> [firewall](#input\_firewall) | The firewall variable, used to add properties to the firewall resource | <pre>object({<br>    location                    = string<br>    name                        = string<br>    rg_name                     = string<br>    tags                        = map(string)<br>    create_firewall_subnet      = optional(bool, false)<br>    firewall_vnet_name          = optional(string)<br>    firewall_subnet_name        = optional(string, "AzureFirewallSubnet")<br>    firewall_subnet_prefixes    = optional(set(string))<br>    create_firewall_public_ip   = optional(bool, true)<br>    pip_custom_dns_label        = optional(string)<br>    pip_name                    = optional(string)<br>    pip_sku                     = optional(string, "Standard")<br>    pip_allocation_method       = optional(string, "Static")<br>    firewall_sku_name           = optional(string, "AZFW_VNet")<br>    firewall_sku_tier           = optional(string, "Standard")<br>    firewall_policy_id          = optional(string)<br>    firewall_dns_servers        = optional(set(string), [])<br>    firewall_snat_addresses     = optional(any)<br>    firewall_availability_zones = optional(set(string))<br>    firewall_threat_intel_mode  = optional(string, "Alert")<br>    ip_configuration = optional(object({<br>      name                 = optional(string, null)<br>      subnet_id            = optional(string, null)<br>      public_ip_address_id = optional(string, null)<br>    }))<br>    management_ip_configuration = optional(object({<br>      name                 = optional(string, null)<br>      subnet_id            = optional(string, null)<br>      public_ip_address_id = optional(string, null)<br>    }))<br>    virtual_hub = optional(object({<br>      virtual_hub_id  = optional(string)<br>      public_ip_count = optional(number, 1)<br>    }))<br>  })</pre> | n/a | yes |

## Outputs

No outputs.
