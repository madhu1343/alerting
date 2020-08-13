provider "azurerm" {
  # Whilst version is optional, we /strongly recommend/ using it to pin the version of the Provider being used
  version = "=2.4.0"

  subscription_id = "82fdc964-8810-4ad3-afd9-ca0b2e88838d"
  client_id       = "38f4fbc3-1b1d-4e22-aade-7a5f02e45264"
  client_secret   = "ko2_095l-2C9C9QH3.NHOQ2-ucxEs0rg8F"
  tenant_id       = "8fec6141-ef27-495f-8044-0a1a6eea3392"

  features {}
}
resource "azurerm_resource_group" "main" {
  name     = "example-resources"
  location = "West US"
}

resource "azurerm_storage_account" "to_monitor" {
  name                     = "examplesa20200813"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_monitor_action_group" "main" {
  name                = "example-actiongroup"
  resource_group_name = azurerm_resource_group.main.name
  short_name          = "exampleact"

  webhook_receiver {
    name        = "callmyapi"
    service_uri = "http://example.com/alert"
  }
}

resource "azurerm_monitor_metric_alert" "example" {
  name                = "example-metricalert"
  resource_group_name = azurerm_resource_group.main.name
  scopes              = [azurerm_storage_account.to_monitor.id]
  description         = "Action will be triggered when Transactions count is greater than 50."

  criteria {
    metric_namespace = "Microsoft.Storage/storageAccounts"
    metric_name      = "Transactions"
    aggregation      = "Total"
    operator         = "GreaterThan"
    threshold        = 50

    dimension {
      name     = "ApiName"
      operator = "Include"
      values   = ["*"]
    }
  }

  action {
    action_group_id = azurerm_monitor_action_group.main.id
  }
}
