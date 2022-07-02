####################################################
#        Vault cluster fixed resources             #
####################################################
module "vault_cluster_resources" {
  source = "../../aws-tf-modules/module.vault-cluster-fixed-resources"

  default_region = var.default_region
  environment    = var.environment
  owner_team     = var.owner_team

  component_name = var.component_name

  read_capacity  = var.read_capacity
  write_capacity = var.write_capacity

  private_key_algorithm = var.private_key_algorithm
  private_key_rsa_bits  = var.private_key_rsa_bits

  cluster_dns                 = var.cluster_dns
  domain                      = var.domain
  kms_key_deletion_window     = var.kms_key_deletion_window
  lb_subnets                  = var.lb_subnets
  lb_type                     = var.lb_type
  secrets_manager_arn         = var.secrets_manager_arn
  validity_period_hours       = var.validity_period_hours
  vault_cluster_sg_id         = var.vault_cluster_sg_id
  vault_license_filepath      = var.vault_license_filepath
  allowed_uses                = var.allowed_uses
  ca_allowed_uses             = var.ca_allowed_uses
  ca_common_name              = var.ca_common_name
  common_name                 = var.common_name
  dns_names                   = var.dns_names
  ip_addresses                = var.ip_addresses
  kms_key_id                  = var.kms_key_id
  organization_name           = var.organization_name
  recovery_window             = var.recovery_window
  user_supplied_iam_role_name = var.user_supplied_iam_role_name
  user_supplied_kms_key_arn   = var.user_supplied_kms_key_arn
}
