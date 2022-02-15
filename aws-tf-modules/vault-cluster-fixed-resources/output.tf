output "ca_public_key_file_path" {
  value = var.ca_public_key_file_path
}

output "public_key_file_path" {
  value = var.public_key_file_path
}

output "private_key_file_path" {
  value = var.private_key_file_path
}

output "lb_certificate_arn" {
  description = "ARN of ACM cert to use with Vault LB listener"
  value       = aws_acm_certificate.vault.arn
}


output "secrets_manager_arn" {
  description = "ARN of secrets_manager secret"
  value       = aws_secretsmanager_secret.vault_tls.arn
}


output "kms_key_arn" {
  value = var.user_supplied_kms_key_arn != null ? var.user_supplied_kms_key_arn : aws_kms_key.vault_key[0].arn
}
