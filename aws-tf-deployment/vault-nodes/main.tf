############################################
#        Vault nodes resources             #
############################################
module "vault_node_resources" {
  source = "../../aws-tf-modules/module.vault-nodes"

  asg_health_check_grace_period = ""
  asg_wait_for_elb_capacity     = ""
  default_cooldown              = 0
  default_region                = ""
  environment                   = ""
  health_check_type             = ""
  kms_key_arn                   = ""
  max_price                     = ""
  owner_team                    = ""
  resource_name_prefix          = ""
  secrets_manager_arn           = ""
  termination_policies          = []
  wait_for_capacity_timeout     = ""
}
