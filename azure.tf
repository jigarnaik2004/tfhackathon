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

resource "random_string" "suffix" {  
length = 4
upper = false
special = false
}