data "databricks_current_user" "me" {
}

resource "databricks_notebook" "query_customers" {
  path     = "${data.databricks_current_user.me.home}/query_customers"
  language = "SQL"
  content_base64 = base64encode(<<-EOT
    -- created from ${abspath(path.module)}
    select * from ${var.schema}.customers
    EOT
  )
}

resource "databricks_job" "jaffle_shop_warehouse" {
  name = "jaffle_shop_warehouse"

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
      schema       = var.schema
      warehouse_id = var.sql_warehouse_id
    }

    library {
      pypi {
        package = "dbt-databricks>=1.0.0,<2.0.0"
      }
    }
  }

  task {
    existing_cluster_id = var.existing_cluster_id
    task_key            = "query_customers"

    depends_on {
      task_key = "jaffle_shop"
    }

    notebook_task {
      notebook_path = "notebooks/query_customers.sql"
    }
  }
}
