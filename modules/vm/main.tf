data "azurerm_subnet" "public_subnet" {
  name    = "prod-public-subnet-01"
  virtual_network_name = var.network_name
  resource_group_name  = var.resource_group_name 
}
resource "azurerm_public_ip" "public_ip" {
  for_each            = var.vm_config
  name                = "${each.key}-public-ip"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "main" {
  for_each            = var.vm_config
  name                = "${each.key}-nic"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "${each.key}-ip-config"
    subnet_id                     = data.azurerm_subnet.public_subnet.id 
    private_ip_address_allocation = "Dynamic"

    public_ip_address_id = azurerm_public_ip.public_ip[each.key].id
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  for_each            = var.vm_config
  name                = each.key
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  size                = each.value.machine_type
  admin_username      = "matr"
  admin_ssh_key {
    username   = "matr"
    public_key = file("${path.module}/ssh/matr_vm.pub")
  }

  network_interface_ids = [azurerm_network_interface.main[each.key].id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Debian"
    offer     = "debian-11"
    sku       = "11"
    version   = "latest"
  }

  custom_data = base64encode(<<-EOF
              #!/bin/bash
              # Update packages
              apt-get update -y
              apt-get upgrade -y
              # Install net-tools
              apt-get install -y net-tools
              # Install pip for python 3.9
              apt-get update -y && apt-get install -y python3-pip
              ln -s /usr/bin/pip3 /usr/local/bin/pip3
            EOF
  )

  tags = {
    Environment = var.environment
    Description = each.value.machine_description
  }
}

resource "azurerm_network_security_group" "nsg" {
  name                = "${var.network_name}-nsg"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  dynamic "security_rule" {
    for_each = var.firewall_rules
    content {
      name                       = "${var.network_name}-${security_rule.key}"
      priority                   = security_rule.value.priority
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = security_rule.value.protocol
      source_port_range          = "*"
      destination_port_range     = security_rule.value.protocol == "Icmp" ? "*" : join(",", security_rule.value.ports)
      source_address_prefix      = join(",", security_rule.value.source_address_prefix)
      destination_address_prefix = "*"
      description                = security_rule.value.description
    }
  }
}

resource "azurerm_network_interface_security_group_association" "nsg_association" {
  for_each                    = var.vm_config
  network_interface_id        = azurerm_network_interface.main[each.key].id
  network_security_group_id    = azurerm_network_security_group.nsg.id
}
