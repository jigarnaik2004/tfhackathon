resource "azurerm_resource_group" "team2_rg" {
  name = var.rg_name
  location = var.location
}

resource "azurerm_storage_account" "team2storage" {
  name =  "${var.sa_name}${random_string.suffix.result}"
  resource_group_name = azurerm_resource_group.team2_rg.name
  location = azurerm_resource_group.team2_rg.location
  account_tier = "Standard"
  account_replication_type = var.geoRedundancy == true ? "GRS"  : "LRS"
  tags = {
    environment = "devhack"
  }
}

resource "azurerm_storage_container" "team2storageContainer" {
  name                  = var.scontainer_name
  storage_account_name  = azurerm_storage_account.team2storage.name
  container_access_type = "private"
}

resource "random_string" "suffix" {  
length = 4
upper = false
special = false
}

resource "azurerm_storage_container" "storageContainer1" {
  count = 3 
  name = "${var.scontainer_prefix}${count.index}"
  storage_account_name  = azurerm_storage_account.team2storage.name
  container_access_type = "private"
}
resource "azurerm_storage_container" "storageContainer2" {
  for_each = toset(var.scontainer_suffixlist)
  name = "scontainerblob${each.key}"
  storage_account_name  = azurerm_storage_account.team2storage.name
  container_access_type = "blob"
}

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "vault" {
  name = "team2vault${random_string.suffix.result}"
  location = azurerm_resource_group.team2_rg.location
  resource_group_name = azurerm_resource_group.team2_rg.name
  sku_name = "standard"
  tenant_id = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    # object_id = data.azurerm_client_config.current.object_id
    object_id = "84e95c03-d3db-427d-b3f3-5574eea7fa93"
    secret_permissions = [
      "Get", "Set"
    ]
  }
   access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    # object_id = data.azurerm_client_config.current.object_id
    object_id = "ec683de5-0315-4679-ad1a-33fdf7601748"
    secret_permissions = [
      "Get", "Set"
    ]
  }
   access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    # object_id = data.azurerm_client_config.current.object_id
    object_id = "9ba5258c-c914-453f-9a36-cadbb5264984"
    secret_permissions = [
      "Get", "Set"
    ]
  }
}

resource "random_password" "password" {
  length           = 16
  special          = true
}

resource "azurerm_key_vault_secret" "hack" {
  name         = "mysecret"
  value        = random_password.password.result
  key_vault_id = azurerm_key_vault.vault.id
}