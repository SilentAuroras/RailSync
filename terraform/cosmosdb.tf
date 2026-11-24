// CosmosDb account
resource "azurerm_cosmosdb_account" "railsyncCosmos" {
  name = "railsynccosmos"

  // Define rg and location
  location                   = var.location
  resource_group_name        = azurerm_resource_group.railsyncRg.name
  automatic_failover_enabled = false

  // Enable free tier
  free_tier_enabled = true

  // Set cosmosdb type and policies
  offer_type = "Standard"
  kind       = "GlobalDocumentDB"

  // Location
  geo_location {
    location          = var.location
    failover_priority = 0
  }
  consistency_policy {
    consistency_level       = "Session"
    max_interval_in_seconds = 300
    max_staleness_prefix    = 100000
  }

  // Wait for RG
  depends_on = [
    azurerm_resource_group.railsyncRg
  ]
}

// CosmosDB database
resource "azurerm_cosmosdb_sql_database" "railsyncDB" {
  name                = "railsyncDB"
  account_name        = azurerm_cosmosdb_account.railsyncCosmos.name
  resource_group_name = azurerm_resource_group.railsyncRg.name

  // Wait for cosmos account
  depends_on = [azurerm_cosmosdb_account.railsyncCosmos]
}

// CosmosDB container
resource "azurerm_cosmosdb_sql_container" "railsyncContainer" {
  name                  = "railsyncContainer"
  account_name          = azurerm_cosmosdb_account.railsyncCosmos.name
  database_name         = azurerm_cosmosdb_sql_database.railsyncDB.name
  resource_group_name   = azurerm_resource_group.railsyncRg.name
  partition_key_paths   = ["/definition/id"]
  partition_key_version = 1

  // Wait for cosmos account
  depends_on = [azurerm_cosmosdb_account.railsyncCosmos]
}