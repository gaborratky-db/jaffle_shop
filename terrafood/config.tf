terraform {
  required_providers {
    databricks = {
      source  = "databricks/databricks"
      version = "1.2.0"
    }
  }
}

provider "databricks" {
  profile = "e2-dogfood"
}
