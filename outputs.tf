output "storageid" {
  value = azurerm_storage_account.team2storage.id  
}

output "storageaccountname" {
  value = azurerm_storage_account.team2storage.name
}

output "blobprimaryendpoint" {
  value = azurerm_storage_account.team2storage.primary_blob_endpoint  
}