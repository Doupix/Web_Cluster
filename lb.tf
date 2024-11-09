resource "azurerm_lb" "lb" {
  name                = "Main_LB"
  location            = azurerm_resource_group.web_cluster.location
  resource_group_name = azurerm_resource_group.web_cluster.name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "Public"
    public_ip_address_id = azurerm_public_ip.lb.id
  }
}

resource "azurerm_lb_backend_address_pool" "pool" {
  loadbalancer_id = azurerm_lb.lb.id
  name            = "BackEndAddressPool"
}

# Forward les requetes sur les port 443 (HTTPS) et 80 (HTTP)
resource "azurerm_lb_rule" "https" {
  loadbalancer_id                = azurerm_lb.lb.id
  name                           = "HTTPS"
  protocol                       = "Tcp"
  frontend_port                  = 443
  backend_port                   = 443
  frontend_ip_configuration_name = "Public"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.pool.id]
  probe_id                       = azurerm_lb_probe.https.id
}

resource "azurerm_lb_rule" "http" {
  loadbalancer_id                = azurerm_lb.lb.id
  name                           = "HTTP"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "Public"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.pool.id]
  probe_id                       = azurerm_lb_probe.http.id
}

# Sonde la santé des VM
resource "azurerm_lb_probe" "http" {
  loadbalancer_id = azurerm_lb.lb.id
  name            = "http"
  protocol        = "Http"
  request_path    = "/"
  port            = 80

}

resource "azurerm_lb_probe" "https" {
  loadbalancer_id = azurerm_lb.lb.id
  name            = "https"
  protocol        = "Https"
  request_path    = "/"
  port            = 443
}
