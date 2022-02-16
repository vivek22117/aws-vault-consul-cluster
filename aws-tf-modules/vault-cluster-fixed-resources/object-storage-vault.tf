resource "aws_s3_bucket" "vault_license_bucket" {
  bucket_prefix = "${var.component_name}-license-${data.aws_caller_identity.current.account_id}-${var.default_region}"
  acl           = "private"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.vault_key.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  force_destroy = true

  tags = merge(local.common_tags, tomap({"Name"= "${var.environment}-vault-license"}))
}
