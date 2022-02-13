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
