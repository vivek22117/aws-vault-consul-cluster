output "lb_certificate_arn" {
  description = "ARN of ACM cert to use with Vault LB listener"
  value       = aws_acm_certificate.vault_cluster_certificate.arn
}

output "secrets_manager_arn" {
  description = "ARN of secrets_manager secret"
  value       = aws_secretsmanager_secret.vault_tls.arn
}

output "vault_instance_profile" {
  value = aws_iam_instance_profile.vault_instance_profile.name
}

output "kms_key_arn" {
  value = var.user_supplied_kms_key_arn != null ? var.user_supplied_kms_key_arn : aws_kms_key.vault_cluster_key[0].arn
}

output "s3_bucket_vault_license_arn" {
  value = aws_s3_bucket.vault_license_bucket.arn
}

output "s3_bucket_vault_license" {
  value = aws_s3_bucket.vault_license_bucket.id
}

output "vault_license_name" {
  value = var.vault_license_name
}

output "vault_lb_sg" {
  value = aws_security_group.vault_lb[0].id
}

output "vault_cluster_sg" {
  value = aws_security_group.vault_cluster_sg.id
}


output "vault_lb_target_group_arn" {
  value = aws_lb_target_group.vault_alb_default_target_group.arn
}
