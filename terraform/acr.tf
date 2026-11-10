// Identity for ACR
resource "azurerm_user_assigned_identity" "railsyncACRIdentity" {
  name = "railsyncACRIdentity"
  resource_group_name = azurerm_resource_group.railsyncRg.name
  location            = var.location
}

// ACR for docker images
resource "azurerm_container_registry" "railsyncACR" {
  name                = "railsyncACR"
  location            = var.location
  resource_group_name = azurerm_resource_group.railsyncRg.name
  sku                 = "Basic"
  
  // Identity
  identity {
    type = "UserAssigned"
      identity_ids = [
        azurerm_user_assigned_identity.railsyncACRIdentity.id
      ]
    }
}