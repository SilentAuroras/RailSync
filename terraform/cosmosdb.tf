// CosmosDb account
resource "azurerm_cosmosdb_account" "railsyncCosmos" {
	name = "railsynccosmos"

	// Define rg and location
	location = var.location
	resource_group_name = azurerm_resource_group.railsyncRg.name
	automatic_failover_enabled = false

	// Set cosmosdb type and policies
	offer_type = "Standard"
	kind = "GlobalDocumentDB"
	geo_location {
		location = var.location
		failover_priority = 0
	}
	consistency_policy {
		consistency_level = "Session"
		max_interval_in_seconds = 300
		max_staleness_prefix = 100000
	}

	// Wait for RG
	depends_on = [ 
		azurerm_resource_group.railsyncRg
	]
}

// CosmosDB table - Speed
resource "azurerm_cosmosdb_table" "railsyncSpeed" {
  name = "railsyncSpeed"
  resource_group_name = azurerm_resource_group.railsyncRg.name
  account_name = azurerm_cosmosdb_account.railsyncCosmos.name
  throughput = 400

  // Wait for cosmos account
  depends_on = [ azurerm_cosmosdb_account.railsyncCosmos ]
}