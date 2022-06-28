####################################################
#        Vault cluster fixed resources             #
####################################################
module "vault_cluster_resources" {
  source = "../../aws-tf-modules/module.vault-cluster-fixed-resources"

  default_region = ""
  environment    = ""
  owner_team     = ""

  component_name = var.component_name

  read_capacity  = var.read_capacity
  write_capacity = var.write_capacity

  private_key_algorithm = var.private_key_algorithm
  private_key_rsa_bits  = var.private_key_rsa_bits

  cluster_dns                 = ""
  domain                      = ""
  kms_key_deletion_window     = var.kms_key_deletion_window
  lb_subnets                  = []
  lb_type                     = ""
  secrets_manager_arn         = ""
  validity_period_hours       = 0
  vault_cluster_sg_id         = ""
  vault_license_filepath      = ""
  allowed_uses                = []
  ca_allowed_uses             = []
  ca_common_name              = ""
  common_name                 = ""
  dns_names                   = []
  ip_addresses                = []
  kms_key_id                  = ""
  organization_name           = ""
  recovery_window             = 0
  user_supplied_iam_role_name = ""
  user_supplied_kms_key_arn   = ""
}
