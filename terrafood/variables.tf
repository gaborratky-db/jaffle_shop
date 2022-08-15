
variable "existing_cluster_id" {
  description = "Existing Cluster ID"
  type        = string
}

variable "sql_warehouse_id" {
  description = "SQL Warehouse ID"
  type        = string
}

variable "schema" {
  description = "Schema"
  default     = "gabor_jaffle_shop"
  type        = string
}
