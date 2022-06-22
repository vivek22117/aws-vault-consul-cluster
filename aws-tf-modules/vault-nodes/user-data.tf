locals {
  vault_user_data = templatefile("${path.module}/templates/install_vault.sh.tpl",
    {
      region                = var.default_region
      name                  = var.resource_name_prefix
      vault_version         = var.vault_version
      kms_key_arn           = data.terraform_remote_state.vault_resources.outputs.kms_key_arn
      secrets_manager_arn   = data.terraform_remote_state.vault_resources.outputs.secrets_manager_arn
      leader_tls_servername = var.leader_tls_servername
    }
  )
}
