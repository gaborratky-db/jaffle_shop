resource "databricks_job" "jaffle_shop_cluster" {
  name = "jaffle_shop_cluster"

  git_source {
    branch   = "main"
    provider = "github"
    url      = "https://github.com/gaborratky-db/jaffle_shop"
  }

  task {
    existing_cluster_id = var.existing_cluster_id
    task_key            = "jaffle_shop"

    dbt_task {
      commands = [
        "dbt deps",
        "dbt run",
        "dbt test"
      ]

      project_directory  = "."
      profiles_directory = "profiles"
      schema             = var.schema
    }

    library {
      pypi {
        package = "dbt-databricks>=1.0.0,<2.0.0"
      }
    }
  }
}
