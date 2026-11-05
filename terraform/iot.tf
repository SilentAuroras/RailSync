// IOT hub and routes
resource "azurerm_iothub" "railsyncIoTHub" {
	name = "railsyncIoTHub"

	// Set location and rg
	resource_group_name = azurerm_resource_group.railsyncRg.name
	location = var.location
	local_authentication_enabled = false
	
	// SKU
	sku {
		name     = "S1"
		capacity = "1"
	}

	// IoT Endpoint config
	endpoint {
		type = "AzureIotHub.StorageContainer"
		connection_string = azurerm_storage_account.railsyncStorageAccount.primary_connection_string
		name = "export"
		batch_frequency_in_seconds = 60
		max_chunk_size_in_bytes = 10485760
		container_name = azurerm_storage_container.railsyncStorageContainer.name
		encoding = "Avro"
		file_name_format = "{iothub}/{partition}_{YYYY}_{MM}_{DD}_{HH}_{mm}"
	}

	// Define endpoint
	endpoint {
		type = "AzureIotHub.EventHub"
		connection_string = azurerm_eventhub_authorization_rule.railsyncAuth.primary_connection_string
		name = "railsync"
	}

	// Route - speed
	route {
		name = "export"
		source = "DeviceMessages"
		condition = "true"
		endpoint_names = ["export"]
		enabled = true
	}

	// Define settings for cloud->device messages
	cloud_to_device {
		max_delivery_count = 30
		default_ttl = "PT1H"
		feedback {
			time_to_live = "PT1H10M"
			max_delivery_count = 15
			lock_duration = "PT30S"
		}
	}
}