terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.8.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.3"
    }
  }
  # On affecte comment backend une Storage Account AZure
  backend "azurerm" {
    resource_group_name  = "VM_Builder"
    storage_account_name = "storagehzvtevxyevcxyez"
    container_name       = "state"
    key                  = "Web_cluster.terraform.tfstate"
  }
}

variable "subscription_id" {
  type = string
}

provider "azurerm" {
  subscription_id = var.subscription_id
  features {}
}

resource "azurerm_resource_group" "web_cluster" {
  name     = "Web_Cluster"
  location = "Canada Central"
}
