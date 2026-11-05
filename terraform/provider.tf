// Required providers
terraform {
	required_providers {
		azurerm = {
			source  = "hashicorp/azurerm"
			version = "=5.0.0"
		}
	}
}

// Azure provider
provider "azurerm" {
	features {}
}

// Location variable - pull from tfvars
variable "location" {}

// Resource group for project
resource "azurerm_resource_group" "railsyncRg" {
	name     = "railsyncRg"
	location = var.location
}