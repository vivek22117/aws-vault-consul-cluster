#####=================Global Variables==============#####
variable "default_region" {
  type        = string
  description = "AWS region to deploy our resources"
}

variable "environment" {
  type        = string
  description = "Environment to be configured 'dev', 'qa', 'prod'"
}

variable "owner_team" {
  type        = string
  description = "Name of owner team"
}

variable "component_name" {
  type        = string
  description = "Component name for resources"
  default     = "vault-cluster"
}

#####==================================================User Data Variables=================================#####
variable "kms_key_arn" {
  type        = string
  description = "KMS Key ARN used for Vault auto-unseal"
}

variable "leader_tls_servername" {
  type        = string
  description = "One of the shared DNS SAN used to create the certs use for mTLS"
  default     = "vault-server.in"
}

variable "resource_name_prefix" {
  type        = string
  description = "Resource name prefix used for tagging and naming AWS resources"
}

variable "secrets_manager_arn" {
  type        = string
  description = "Secrets manager ARN where TLS cert info is stored"
}

variable "vault_version" {
  type        = string
  description = "Vault version"
  default     = "1.8.2"
}


#####=============================================Vault Node Config Variables================================#####
variable "user_supplied_ami_id" {
  type        = string
  description = "AMI ID to use with Vault instances"
  default     = null
}



#####==============Local variables======================#####
locals {
  common_tags = {
    Team        = var.owner_team
    Environment = var.environment
    Component   = var.component_name
  }
}

