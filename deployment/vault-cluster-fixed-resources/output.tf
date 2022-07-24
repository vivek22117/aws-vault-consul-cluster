output "lb_certificate_arn" {
  description = "ARN of ACM cert to use with Vault LB listener"
  value       = module.vault_cluster_resources.lb_certificate_arn
}

output "secrets_manager_arn" {
  description = "ARN of secrets_manager secret"
  value       = module.vault_cluster_resources.secrets_manager_arn
}

output "vault_instance_profile" {
  value = module.vault_cluster_resources.vault_instance_profile
}

output "kms_key_arn" {
  value = module.vault_cluster_resources.kms_key_arn
}

output "s3_bucket_vault_license_arn" {
  value = module.vault_cluster_resources.s3_bucket_vault_license_arn
}

output "s3_bucket_vault_license" {
  value = module.vault_cluster_resources.s3_bucket_vault_license
}

output "vault_license_name" {
  value = module.vault_cluster_resources.vault_license_name
}

output "vault_lb_sg" {
  value = module.vault_cluster_resources.vault_lb_sg
}

output "vault_cluster_sg" {
  value = module.vault_cluster_resources.vault_cluster_sg
}


output "vault_lb_target_group_arn" {
  value = module.vault_cluster_resources.vault_lb_target_group_arn
}

