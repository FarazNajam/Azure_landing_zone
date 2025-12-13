# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_version = ">= 1.6.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.1.0"
    }
  }
  # Backend: Azure Storage (remote state)
  backend "azurerm" {
    resource_group_name  = "rg-terraform-state-file-prod-01"
    storage_account_name = "terraformstatefileprod02"
    container_name       = "tfstate"
    key                  = "dev.tfstate"

    # Use Entra ID + OIDC from GitHub
    use_azuread_auth = true
    use_oidc         = true
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}
