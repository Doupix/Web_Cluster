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
  backend "azurerm" {
    resource_group_name  = "VM_Builder"                    # Can be passed via `-backend-config=`"resource_group_name=<resource group name>"` in the `init` command.
    storage_account_name = "storage-hzvtevxyevcxyezjvz"    # Can be passed via `-backend-config=`"storage_account_name=<storage account name>"` in the `init` command.
    container_name       = "state"                         # Can be passed via `-backend-config=`"container_name=<container name>"` in the `init` command.
    key                  = "Web_cluster.terraform.tfstate" # Can be passed via `-backend-config=`"key=<blob key name>"` in the `init` command.
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
