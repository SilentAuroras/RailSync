// AKS cluster
resource "azurerm_kubernetes_cluster" "railsyncAKS" {
	name = "railsyncAKS"
	dns_prefix = "railsyncAKS-"

	// Set location and rg
	location = var.location
	resource_group_name = azurerm_resource_group.railsyncRg.name
	
	// Identity
	identity {
		type = "SystemAssigned"
	}

	// Node settings
	default_node_pool {
	  name = "default"
	  node_count = 2
	  vm_size = "Standard_F4s_v2"
	}

	// Auto enabled
	node_provisioning_profile {
	  mode = "Auto"
	}
}

// Client cert for cluster
output "railsyncClientCert" {
	value = azurerm_kubernetes_cluster.railsyncAKS.kube_config[0].client_certificate
	sensitive = true
}

// Kube config
output "railsynKubeConfig" {
	value = azurerm_kubernetes_cluster.railsyncAKS.kube_config_raw
	sensitive = true
}