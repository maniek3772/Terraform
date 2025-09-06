resource "azurerm_virtual_network" "vnet" {
  name                = "${var.name}-vnet"
  address_space       = var.address_space
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "private_subnet" {
  for_each             = var.private_subnets
  name                 = each.key
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [each.value.address_prefix]
}

resource "azurerm_subnet" "public_subnet" {
  for_each             = var.public_subnets
  name                 = each.key
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [each.value.address_prefix]
}

resource "azurerm_subnet" "public_database_subnet" { # special subnet for the database
  for_each             = var.public_database_subnets
  name                 = each.key
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [each.value.address_prefix]

  delegation { # function allows assign a specific subnet to a specific resource. It provides segmentation and improves network security.
    name = "mysql-delegation"
    service_delegation {
      name = "Microsoft.DBforMySQL/flexibleServers" # subnet intended for the flexible servers service
      actions = [ # permissions granted to the service running in the subnet
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
}