terraform {
    required_version = ">= 0.11"
    backend "azurerm" {
        storage_account_name = "__tfstorageaccount__"
        container_name = "__tfcontainername__"
        key = "terraform.tfstate"
        access_key = "__storagekey__"
        features {}
    }
}
###############################
## Azure IaC Components      ##
###############################
provider "azurerm" {
    version = "= 2.0.0"
    features {}
}

resource "azurerm_resource_group" "mc-az-group" {
    name = "__rgname__"
    location = "__location__"
}

resource "azurerm_app_service_plan" "mc-az-plan" {
    name = "__appservicename__"
    kind = "Windows"
    location = "${azurerm_resource_group.mc-az-group.location}"
    resource_group_name = "${azurerm_resource_group.mc-az-group.name}"

    sku {
        tier = "Free"
        size = "F1"
    }
}

resource "azurerm_app_service" "mc-az-app" {
    name = "__backendname__"
    location = "${azurerm_resource_group.mc-az-group.location}"
    resource_group_name = "${azurerm_resource_group.mc-az-group.name}"
    app_service_plan_id = "${azurerm_app_service_plan.mc-az-plan.id}"
    
    site_config {
        dotnet_core_version = "V3.1"
    }
}