terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = ">= 1.0.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.29.0"
    }
    databricks = {
      source  = "databrickslabs/databricks"
      version = ">= 0.2.8"
    }
    http = {
      source = "hashicorp/http"
    }
    local = {
      source = "hashicorp/local"
    }
    null = {
      source = "hashicorp/null"
    }
    random = {
      source = "hashicorp/random"
    }
  }
  required_version = ">= 0.13.5"
}