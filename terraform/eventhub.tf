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

// Pull current user info for role assignment (azure cli)
data "azurerm_client_config" "current" {}

// Assign the Eventhub Data Sender role to the current user for the Eventhub
resource "azurerm_role_assignment" "eventhub_test_sender" {
  role_definition_name = "Azure Event Hubs Data Sender"
  principal_id         = data.azurerm_client_config.current.object_id
  scope                = azurerm_eventhub.railsyncEventHub.id
}

// Output the event hub name for tests and endpoints
output "EVENT_HUB_NAME" {
  value = azurerm_eventhub.railsyncEventHub.name
}

// Output the event hub fqdn for tests and endpoints
output "EVENT_HUB_FQDN" {
  value = "${azurerm_eventhub.railsyncEventHub.name}.servicebus.windows.net"
}