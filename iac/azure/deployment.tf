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
    https_only = true

    site_config {
        use_32_bit_worker_process = true
    }
}

resource "azurerm_template_deployment" "netcoreruntime" {
    name = "extension"
    resource_group_name = "${azurerm_resource_group.mc-az-group.name}"
    template_body = "${file("extension.json")}"
    deployment_mode = "Incremental"
    
    parameters = {
      "siteName" = "${azurerm_app_service.mc-az-app.name}"
      "extensionName" = "Microsoft.AspNetCore.AzureAppServices.SiteExtension"
      "extensionVersion" = "3.1.7"
    }
}