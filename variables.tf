variable "firewall" {
  type = object({
    location                    = string
    name                        = string
    rg_name                     = string
    tags                        = map(string)
    create_firewall_subnet      = optional(bool, false)
    firewall_vnet_name          = optional(string)
    firewall_subnet_name        = optional(string, "AzureFirewallSubnet")
    firewall_subnet_prefixes    = optional(set(string))
    create_firewall_public_ip   = optional(bool, true)
    pip_custom_dns_label        = optional(string)
    pip_name                    = optional(string)
    pip_sku                     = optional(string, "Standard")
    pip_allocation_method       = optional(string, "Static")
    firewall_sku_name           = optional(string, "AZFW_VNet")
    firewall_sku_tier           = optional(string, "Standard")
    firewall_policy_id          = optional(string)
    firewall_dns_servers        = optional(set(string), [])
    firewall_snat_addresses     = optional(any)
    firewall_availability_zones = optional(set(string))
    firewall_threat_intel_mode  = optional(string, "Alert")
    ip_configuration = optional(object({
      name                 = optional(string, null)
      subnet_id            = optional(string, null)
      public_ip_address_id = optional(string, null)
    }))
    management_ip_configuration = optional(object({
      name                 = optional(string, null)
      subnet_id            = optional(string, null)
      public_ip_address_id = optional(string, null)
    }))
    virtual_hub = optional(object({
      virtual_hub_id  = optional(string)
      public_ip_count = optional(number, 1)
    }))
  })
  description = "The firewall variable, used to add properties to the firewall resource"
}
