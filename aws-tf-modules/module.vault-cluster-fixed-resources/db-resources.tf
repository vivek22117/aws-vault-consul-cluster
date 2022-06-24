resource "aws_dynamodb_table" "vault_backend_table" {
  name = "${var.environment}-vault-backend-${var.default_region}"

  read_capacity  = var.read_capacity
  write_capacity = var.write_capacity

  hash_key  = "Path"
  range_key = "Key"

  attribute {
    name = "Path"
    type = "S"
  }
  attribute {
    name = "Key"
    type = "S"
  }

  lifecycle {
    prevent_destroy = false
  }

  tags = merge(local.common_tags, tomap({ "Name" = "${var.environment}-vault-consul-db" }))
}
