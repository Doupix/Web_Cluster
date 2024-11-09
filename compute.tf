data "azurerm_client_config" "current" {}

# Définit l'image_id de notre VM custom préconfiguré
locals {
  image_id = "/subscriptions/${var.subscription_id}/resourceGroups/VM_Builder/providers/Microsoft.Compute/galleries/Gallery/images/nginx"
}

# Récupère le mot de passe admin du vault
data "azurerm_key_vault" "keyvault" {
  name                = "vlt-ihvfcnyduevvctzssz"
  resource_group_name = "VM_Builder"
}

data "azurerm_key_vault_secret" "rootpasswd" {
  name         = "passwd"
  key_vault_id = data.azurerm_key_vault.keyvault.id
}

resource "azurerm_orchestrated_virtual_machine_scale_set" "vmss_web" {
  name                        = "vmss-web"
  resource_group_name         = azurerm_resource_group.web_cluster.name
  location                    = azurerm_resource_group.web_cluster.location
  sku_name                    = "Standard_D2as_v4"
  instances                   = 2
  platform_fault_domain_count = 1
  zones                       = ["1", "2"]

  os_profile {
    linux_configuration {
      computer_name_prefix            = "vm"
      admin_username                  = "plouf"
      disable_password_authentication = false
      admin_password                  = data.azurerm_key_vault_secret.rootpasswd.value
    }
  }
  source_image_id = local.image_id

  network_interface {
    name                          = "nic"
    primary                       = true
    enable_accelerated_networking = false
    network_security_group_id     = azurerm_network_security_group.all.id

    ip_configuration {
      name                                   = "ipconfig"
      primary                                = true
      subnet_id                              = azurerm_subnet.private.id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.pool.id]
    }
  }
}
