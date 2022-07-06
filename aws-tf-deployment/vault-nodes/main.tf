############################################
#        Vault nodes resources             #
############################################
module "vault_node_resources" {
  source = "../../aws-tf-modules/module.vault-nodes"

  asg_health_check_grace_period = var.asg_health_check_grace_period
  asg_wait_for_elb_capacity     = var.asg_wait_for_elb_capacity
  default_cooldown              = var.default_cooldown
  default_region                = var.default_region
  environment                   = var.environment
  health_check_type             = var.health_check_type
  kms_key_arn                   = var.kms_key_arn
  max_price                     = var.max_price
  owner_team                    = var.owner_team
  resource_name_prefix          = var.resource_name_prefix
  secrets_manager_arn           = var.secrets_manager_arn
  termination_policies          = var.termination_policies
  wait_for_capacity_timeout     = var.wait_for_capacity_timeout
}
