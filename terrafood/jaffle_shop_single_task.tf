resource "databricks_job" "jaffle_shop_single_task" {
  name = "jaffle_shop_single_task"

  existing_cluster_id = var.existing_cluster_id

  git_source {
    branch   = "main"
    provider = "github"
    url      = "https://github.com/gaborratky-db/jaffle_shop"
  }

  dbt_task {
    commands = [
      "dbt deps",
      "dbt run",
      "dbt test"
    ]

    project_directory = "."
    warehouse_id      = var.sql_warehouse_id
  }

  library {
    pypi {
      package = "dbt-databricks>=1.0.0,<2.0.0"
    }
  }
}
