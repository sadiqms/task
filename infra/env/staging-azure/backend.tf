terraform {
  required_version = ">= 1.5.0"
  backend "azurerm" {
    resource_group_name  = "<state-rg>"
    storage_account_name = "<state-storage>"
    container_name       = "tfstate"
    key                  = "staging-azure/terraform.tfstate"
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.100"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }
}

