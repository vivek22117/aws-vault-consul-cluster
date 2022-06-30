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
