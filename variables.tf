variable "create_firewall_data_public_ip" {
  description = "Boolean flag to control whether a firewall public IP is created."
  type        = bool
  default     = true
}

variable "create_firewall_management_public_ip" {
  description = "Boolean flag to control whether a firewall public IP is created."
  type        = bool
  default     = true
}

variable "create_firewall_management_subnet" {
  description = "Boolean flag to control whether a firewall subnet is created."
  type        = bool
  default     = false
}

variable "create_firewall_subnet" {
  description = "Boolean flag to control whether a firewall subnet is created."
  type        = bool
  default     = false
}

variable "firewall_availability_zones" {
  description = "The availability zones for the firewall."
  type        = set(string)
  default     = null
}

variable "firewall_dns_servers" {
  description = "The DNS servers for the firewall."
  type        = set(string)
  default     = null
}

variable "firewall_management_subnet_name" {
  description = "The name of the firewall subnet."
  type        = string
  default     = "AzureFirewallManagementSubnet"
}

variable "firewall_management_subnet_prefixes" {
  description = "The address prefixes for the firewall subnet."
  type        = set(string)
  default     = null
}

variable "firewall_policy_id" {
  description = "The ID of the firewall policy."
  type        = string
  default     = null
}

variable "firewall_sku_name" {
  description = "The SKU name of the firewall."
  type        = string
  default     = "AZFW_VNet"
}

variable "firewall_sku_tier" {
  description = "The SKU tier of the firewall."
  type        = string
  default     = "Standard"
}

variable "firewall_snat_addresses" {
  description = "The SNAT addresses for the firewall."
  type        = any
  default     = null
}

variable "firewall_subnet_name" {
  description = "The name of the firewall subnet."
  type        = string
  default     = "AzureFirewallSubnet"
}

variable "firewall_subnet_prefixes" {
  description = "The address prefixes for the firewall subnet."
  type        = set(string)
  default     = null
}

variable "firewall_threat_intel_mode" {
  description = "The threat intelligence mode for the firewall."
  type        = string
  default     = "Alert"
}

variable "ip_configuration" {
  description = "Configuration for IP settings."
  type = object({
    name                 = optional(string)
    subnet_id            = optional(string)
    public_ip_address_id = optional(string)
  })
  default = null
}

variable "ip_configuration_name" {
  description = "The name of the IP configuration."
  type        = string
  default     = null
}

variable "ip_configuration_public_ip_address_id" {
  description = "The public IP address ID of the IP configuration."
  type        = string
  default     = null
}

variable "ip_configuration_subnet_id" {
  description = "The subnet ID of the IP configuration."
  type        = string
  default     = null
}

variable "location" {
  description = "The location where resources will be created."
  type        = string
}

variable "management_ip_configuration" {
  description = "Configuration for management IP settings."
  type = object({
    name                 = optional(string)
    subnet_id            = optional(string)
    public_ip_address_id = optional(string)
  })
  default = null
}

variable "management_ip_configuration_name" {
  description = "The name of the management IP configuration."
  type        = string
  default     = null
}

variable "management_ip_configuration_public_ip_address_id" {
  description = "The public IP address ID of the management IP configuration."
  type        = string
  default     = null
}

variable "management_ip_configuration_subnet_id" {
  description = "The subnet ID of the management IP configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "The name of the firewall."
  type        = string
}

variable "pip_allocation_method" {
  description = "The allocation method for the public IP."
  type        = string
  default     = "Static"
}

variable "pip_custom_dns_label" {
  description = "The custom DNS label for the public IP."
  type        = string
  default     = null
}

variable "pip_name" {
  description = "The name of the public IP."
  type        = string
  default     = null
}

variable "pip_sku" {
  description = "The SKU of the public IP."
  type        = string
  default     = "Standard"
}

variable "public_ip_count" {
  description = "The number of public IPs for the virtual hub."
  type        = number
  default     = 1
}

variable "rg_name" {
  description = "The name of the resource group."
  type        = string
}

variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}

variable "virtual_hub" {
  description = "Configuration for virtual hub settings."
  type = object({
    virtual_hub_id  = optional(string)
    public_ip_count = optional(number)
  })
  default = null
}

variable "virtual_hub_id" {
  description = "The ID of the virtual hub."
  type        = string
  default     = null
}

variable "vnet_name" {
  description = "The name of the virtual network."
  type        = string
  default     = null
}

variable "vnet_rg_name" {
  description = "The name of the resource group for the virtual network."
  type        = string
  default     = null
}
