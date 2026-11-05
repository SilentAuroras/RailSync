// Storage account for IoT Hub
resource "azurerm_storage_account" "railsyncStorageAccount" {
  name = "railsyncstorage"
  account_tier = "Standard"
  account_replication_type = "LRS"
  resource_group_name = azurerm_resource_group.railsyncRg.name
  location = var.location
}

// Storage for IoT Hub
resource "azurerm_storage_container" "railsyncStorageContainer" {
  name = "railsynccontainer"
  storage_account_id = azurerm_storage_account.railsyncStorageAccount.id
  container_access_type = "private"
}