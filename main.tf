terraform {

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
    random = {
      source = "hashicorp/random"
    }
  }

  backend "azurerm" {
    resource_group_name  = "tfstateteam2"
    storage_account_name = "tfstateteam2vgihack"
    container_name       = "tfstateteam2"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
}
