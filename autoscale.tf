resource "azurerm_monitor_autoscale_setting" "autoscale" {
  name                = "autoscale"
  location            = azurerm_resource_group.web_cluster.location
  resource_group_name = azurerm_resource_group.web_cluster.name
  target_resource_id  = azurerm_orchestrated_virtual_machine_scale_set.vmss_web.id
  enabled             = true
  profile {
    name = "autoscale"
    capacity {
      default = 2
      minimum = 2
      maximum = 4
    }


    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_orchestrated_virtual_machine_scale_set.vmss_web.id
        operator           = "LessThan"
        statistic          = "Average"
        time_aggregation   = "Average"
        time_window        = "PT2M"
        time_grain         = "PT1M"
        threshold          = 10
      }
      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }
    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_orchestrated_virtual_machine_scale_set.vmss_web.id
        operator           = "GreaterThan"
        statistic          = "Average"
        time_aggregation   = "Average"
        time_window        = "PT5M"
        time_grain         = "PT1M"
        threshold          = 50
      }
      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }

  }
}
