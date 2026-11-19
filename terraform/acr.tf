// Identity for ACR
resource "azurerm_user_assigned_identity" "railsyncACRIdentity" {
  name                = "railsyncACRIdentity"
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

// Assign permissions to allow AKS to pull containers from ACR
resource "azurerm_role_assignment" "railsyncACRPull" {
  role_definition_name = "AcrPull"
  scope                = azurerm_container_registry.railsyncACR.id
  principal_id         = azurerm_kubernetes_cluster.railsyncAKS.kubelet_identity[0].object_id
}