// IOT hub and routes
resource "azurerm_iothub" "railsyncIoTHub" {
  name = "railsyncIoTHub"

  // Set location and rg
  resource_group_name          = azurerm_resource_group.railsyncRg.name
  location                     = var.location
  local_authentication_enabled = false
  event_hub_partition_count    = 2

  // SKU
  sku {
    name     = "F1"
    capacity = "1"
  }

  // IoT Endpoint config - Storage container for avro backups
  endpoint {
    type                       = "AzureIotHub.StorageContainer"
    connection_string          = azurerm_storage_account.railsyncStorageAccount.primary_connection_string
    name                       = "export"
    batch_frequency_in_seconds = 60
    max_chunk_size_in_bytes    = 10485760
    container_name             = azurerm_storage_container.railsyncStorageContainer.name
    encoding                   = "Avro"
    file_name_format           = "{iothub}/{partition}_{YYYY}_{MM}_{DD}_{HH}_{mm}"
  }

  // Route - speed
  route {
    name           = "speed"
    source         = "DeviceMessages"
    condition      = "true"
    endpoint_names = ["export"]
    enabled        = true
  }

  // Define settings for cloud->device messages
  cloud_to_device {
    max_delivery_count = 30
    default_ttl        = "PT1H"
    feedback {
      time_to_live       = "PT1H10M"
      max_delivery_count = 15
      lock_duration      = "PT30S"
    }
  }
}

// IoT endpoint - Route directly to CosmosDB
resource "azurerm_iothub_endpoint_cosmosdb_account" "railsyncIoTCosmos" {
  name                = "railsyncIoTCosmos"
  iothub_id           = azurerm_iothub.railsyncIoTHub.id
  resource_group_name = azurerm_resource_group.railsyncRg.name
  endpoint_uri        = azurerm_cosmosdb_account.railsyncCosmos.endpoint
  database_name       = azurerm_cosmosdb_sql_database.railsyncDB.name
  container_name      = azurerm_cosmosdb_sql_container.railsyncContainer.name
}