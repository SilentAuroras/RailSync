// AKS cluster
resource "azurerm_kubernetes_cluster" "railsyncAKS" {
  name       = "railsyncAKS"
  dns_prefix = "railsyncAKS"

  // Set location and rg
  location            = var.location
  resource_group_name = azurerm_resource_group.railsyncRg.name
  sku_tier            = "Free"

  // Identity
  identity {
    type = "SystemAssigned"
  }

  // Node settings
  default_node_pool {
    name            = "default"
    node_count      = 1
    vm_size         = "Standard_D4s_v4"
    os_disk_size_gb = 30
  }

  node_provisioning_profile {
    mode = "Manual"
  }
}

// Client cert for cluster
output "railsyncClientCert" {
  value     = azurerm_kubernetes_cluster.railsyncAKS.kube_config[0].client_certificate
  sensitive = true
}

// Kube config
output "railsynKubeConfig" {
  value     = azurerm_kubernetes_cluster.railsyncAKS.kube_config_raw
  sensitive = true
}