
```hcl
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
| [azurerm_public_ip.firewall_data_pip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_public_ip.firewall_management_pip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_subnet.firewall_management_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet.firewall_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_firewall_data_public_ip"></a> [create\_firewall\_data\_public\_ip](#input\_create\_firewall\_data\_public\_ip) | Boolean flag to control whether a firewall public IP is created. | `bool` | `true` | no |
| <a name="input_create_firewall_management_public_ip"></a> [create\_firewall\_management\_public\_ip](#input\_create\_firewall\_management\_public\_ip) | Boolean flag to control whether a firewall public IP is created. | `bool` | `true` | no |
| <a name="input_create_firewall_management_subnet"></a> [create\_firewall\_management\_subnet](#input\_create\_firewall\_management\_subnet) | Boolean flag to control whether a firewall subnet is created. | `bool` | `false` | no |
| <a name="input_create_firewall_subnet"></a> [create\_firewall\_subnet](#input\_create\_firewall\_subnet) | Boolean flag to control whether a firewall subnet is created. | `bool` | `false` | no |
| <a name="input_firewall_availability_zones"></a> [firewall\_availability\_zones](#input\_firewall\_availability\_zones) | The availability zones for the firewall. | `set(string)` | `null` | no |
| <a name="input_firewall_dns_servers"></a> [firewall\_dns\_servers](#input\_firewall\_dns\_servers) | The DNS servers for the firewall. | `set(string)` | `null` | no |
| <a name="input_firewall_management_subnet_name"></a> [firewall\_management\_subnet\_name](#input\_firewall\_management\_subnet\_name) | The name of the firewall subnet. | `string` | `"AzureFirewallManagementSubnet"` | no |
| <a name="input_firewall_management_subnet_prefixes"></a> [firewall\_management\_subnet\_prefixes](#input\_firewall\_management\_subnet\_prefixes) | The address prefixes for the firewall subnet. | `set(string)` | `null` | no |
| <a name="input_firewall_policy_id"></a> [firewall\_policy\_id](#input\_firewall\_policy\_id) | The ID of the firewall policy. | `string` | `null` | no |
| <a name="input_firewall_sku_name"></a> [firewall\_sku\_name](#input\_firewall\_sku\_name) | The SKU name of the firewall. | `string` | `"AZFW_VNet"` | no |
| <a name="input_firewall_sku_tier"></a> [firewall\_sku\_tier](#input\_firewall\_sku\_tier) | The SKU tier of the firewall. | `string` | `"Standard"` | no |
| <a name="input_firewall_snat_addresses"></a> [firewall\_snat\_addresses](#input\_firewall\_snat\_addresses) | The SNAT addresses for the firewall. | `any` | `null` | no |
| <a name="input_firewall_subnet_name"></a> [firewall\_subnet\_name](#input\_firewall\_subnet\_name) | The name of the firewall subnet. | `string` | `"AzureFirewallSubnet"` | no |
| <a name="input_firewall_subnet_prefixes"></a> [firewall\_subnet\_prefixes](#input\_firewall\_subnet\_prefixes) | The address prefixes for the firewall subnet. | `set(string)` | `null` | no |
| <a name="input_firewall_threat_intel_mode"></a> [firewall\_threat\_intel\_mode](#input\_firewall\_threat\_intel\_mode) | The threat intelligence mode for the firewall. | `string` | `"Alert"` | no |
| <a name="input_ip_configuration"></a> [ip\_configuration](#input\_ip\_configuration) | Configuration for IP settings. | <pre>object({<br>    name                 = optional(string)<br>    subnet_id            = optional(string)<br>    public_ip_address_id = optional(string)<br>  })</pre> | `null` | no |
| <a name="input_ip_configuration_name"></a> [ip\_configuration\_name](#input\_ip\_configuration\_name) | The name of the IP configuration. | `string` | `null` | no |
| <a name="input_ip_configuration_public_ip_address_id"></a> [ip\_configuration\_public\_ip\_address\_id](#input\_ip\_configuration\_public\_ip\_address\_id) | The public IP address ID of the IP configuration. | `string` | `null` | no |
| <a name="input_ip_configuration_subnet_id"></a> [ip\_configuration\_subnet\_id](#input\_ip\_configuration\_subnet\_id) | The subnet ID of the IP configuration. | `string` | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | The location where resources will be created. | `string` | n/a | yes |
| <a name="input_management_ip_configuration"></a> [management\_ip\_configuration](#input\_management\_ip\_configuration) | Configuration for management IP settings. | <pre>object({<br>    name                 = optional(string)<br>    subnet_id            = optional(string)<br>    public_ip_address_id = optional(string)<br>  })</pre> | `null` | no |
| <a name="input_management_ip_configuration_name"></a> [management\_ip\_configuration\_name](#input\_management\_ip\_configuration\_name) | The name of the management IP configuration. | `string` | `null` | no |
| <a name="input_management_ip_configuration_public_ip_address_id"></a> [management\_ip\_configuration\_public\_ip\_address\_id](#input\_management\_ip\_configuration\_public\_ip\_address\_id) | The public IP address ID of the management IP configuration. | `string` | `null` | no |
| <a name="input_management_ip_configuration_subnet_id"></a> [management\_ip\_configuration\_subnet\_id](#input\_management\_ip\_configuration\_subnet\_id) | The subnet ID of the management IP configuration. | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the firewall. | `string` | n/a | yes |
| <a name="input_pip_allocation_method"></a> [pip\_allocation\_method](#input\_pip\_allocation\_method) | The allocation method for the public IP. | `string` | `"Static"` | no |
| <a name="input_pip_custom_dns_label"></a> [pip\_custom\_dns\_label](#input\_pip\_custom\_dns\_label) | The custom DNS label for the public IP. | `string` | `null` | no |
| <a name="input_pip_name"></a> [pip\_name](#input\_pip\_name) | The name of the public IP. | `string` | `null` | no |
| <a name="input_pip_sku"></a> [pip\_sku](#input\_pip\_sku) | The SKU of the public IP. | `string` | `"Standard"` | no |
| <a name="input_public_ip_count"></a> [public\_ip\_count](#input\_public\_ip\_count) | The number of public IPs for the virtual hub. | `number` | `1` | no |
| <a name="input_rg_name"></a> [rg\_name](#input\_rg\_name) | The name of the resource group. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources. | `map(string)` | `{}` | no |
| <a name="input_virtual_hub"></a> [virtual\_hub](#input\_virtual\_hub) | Configuration for virtual hub settings. | <pre>object({<br>    virtual_hub_id  = optional(string)<br>    public_ip_count = optional(number)<br>  })</pre> | `null` | no |
| <a name="input_virtual_hub_id"></a> [virtual\_hub\_id](#input\_virtual\_hub\_id) | The ID of the virtual hub. | `string` | `null` | no |
| <a name="input_vnet_name"></a> [vnet\_name](#input\_vnet\_name) | The name of the virtual network. | `string` | `null` | no |
| <a name="input_vnet_rg_name"></a> [vnet\_rg\_name](#input\_vnet\_rg\_name) | The name of the resource group for the virtual network. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_firewall_data_public_ip_fqdn"></a> [firewall\_data\_public\_ip\_fqdn](#output\_firewall\_data\_public\_ip\_fqdn) | The Fully Qualified Domain Name (FQDN) of the firewall public IP. |
| <a name="output_firewall_data_public_ip_id"></a> [firewall\_data\_public\_ip\_id](#output\_firewall\_data\_public\_ip\_id) | The ID of the firewall public IP. |
| <a name="output_firewall_id"></a> [firewall\_id](#output\_firewall\_id) | The ID of the firewall. |
| <a name="output_firewall_ip_configuration"></a> [firewall\_ip\_configuration](#output\_firewall\_ip\_configuration) | The IP configuration of the firewall. |
| <a name="output_firewall_management_ip_configuration"></a> [firewall\_management\_ip\_configuration](#output\_firewall\_management\_ip\_configuration) | The management IP configuration of the firewall. |
| <a name="output_firewall_management_public_ip_fqdn"></a> [firewall\_management\_public\_ip\_fqdn](#output\_firewall\_management\_public\_ip\_fqdn) | The Fully Qualified Domain Name (FQDN) of the firewall public IP. |
| <a name="output_firewall_management_public_ip_id"></a> [firewall\_management\_public\_ip\_id](#output\_firewall\_management\_public\_ip\_id) | The ID of the firewall public IP. |
| <a name="output_firewall_name"></a> [firewall\_name](#output\_firewall\_name) | The name of the firewall. |
| <a name="output_firewall_subnet_id"></a> [firewall\_subnet\_id](#output\_firewall\_subnet\_id) | The ID of the firewall subnet. |
| <a name="output_firewall_virtual_hub_configuration"></a> [firewall\_virtual\_hub\_configuration](#output\_firewall\_virtual\_hub\_configuration) | The virtual hub configuration of the firewall. |
