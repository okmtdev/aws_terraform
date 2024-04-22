module "dynamodb_table" {
  source = "../../modules/dynamodb"

  table_name    = "basic-dynamodb-table-sample"
  partition_key = "UserId"
  sort_key      = "GameTitle"
  attributes    = var.attributes
  ttl_enabled   = true
}
