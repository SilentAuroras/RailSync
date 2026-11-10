// Eventhub namespace
resource "azurerm_eventhub_namespace" "railsyncEventNamespace" {
  name                = "railsyncEventNamespace"
  resource_group_name = azurerm_resource_group.railsyncRg.name
  location            = var.location
  sku                 = "Basic"
}

// Eventhub for IoTHub
resource "azurerm_eventhub" "railsyncEventHub" {
  name              = "railsyncEventHub"
  namespace_id      = azurerm_eventhub_namespace.railsyncEventNamespace.id
  partition_count   = 2
  message_retention = 1
}

// Eventhub auth rule
resource "azurerm_eventhub_authorization_rule" "railsyncAuth" {
  name                = "railsyncAuth"
  send                = true
  resource_group_name = azurerm_resource_group.railsyncRg.name
  namespace_name      = azurerm_eventhub_namespace.railsyncEventNamespace.name
  eventhub_name       = azurerm_eventhub.railsyncEventHub.name
}