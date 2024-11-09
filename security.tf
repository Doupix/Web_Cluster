
resource "azurerm_subnet_network_security_group_association" "NSG" {
	subnet_id = azurerm_subnet.private.id
	network_security_group_id = azurerm_network_security_group.all.id
}

resource "azurerm_network_security_group" "all" {
  name                = "All_Connections"
  location            = azurerm_resource_group.web_cluster.location
  resource_group_name = azurerm_resource_group.web_cluster.name

  security_rule {
    name                       = "AllowedOutbound"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowedInbound"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
