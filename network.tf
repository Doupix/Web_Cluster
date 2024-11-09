resource "azurerm_virtual_network" "global" {
	name = "Global_Network"
	location = azurerm_resource_group.web_cluster.location
	resource_group_name = azurerm_resource_group.web_cluster.name
	address_space = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "private"{
  name                 = "Private"
  resource_group_name  = azurerm_resource_group.web_cluster.name
  virtual_network_name = azurerm_virtual_network.global.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "lb" {
	name = "LB_Public_IP"
	resource_group_name = azurerm_resource_group.web_cluster.name
	location = azurerm_resource_group.web_cluster.location
	allocation_method = "Static"
}
