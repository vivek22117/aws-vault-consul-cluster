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

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
  default     = "m5.xlarge"
}

variable "key_name" {
  type        = string
  description = "key pair to use for SSH access to instance"
  default     = null
}

variable "max_price" {
  type        = string
  description = "Spot price for EC2 instance"
}

variable "node_count" {
  type        = number
  description = "Number of Vault nodes to deploy in ASG"
  default     = 5
}

variable "termination_policies" {
  description = "A list of policies to decide how the instances in the auto scale group should be terminated"
  type        = list(string)
}

variable "wait_for_capacity_timeout" {
  description = "A maximum duration that Terraform should wait for ASG instances to be healthy before timing out"
  type        = string
}

variable "asg_health_check_grace_period" {
  type        = string
  description = "ASG health check grace period"
}

variable "health_check_type" {
  type        = string
  description = "ASG health check type"
}


variable "asg_wait_for_elb_capacity" {
  type        = string
  description = "ASG wait for ELB capacity"
}

variable "default_cooldown" {
  type        = number
  description = "Cool-down value of ASG"
}

#####=============ASG Standards Tags===============#####
variable "custom_tags" {
  description = "Custom tags to set on the Instances in the ASG"
  type        = map(string)
  default = {
    owner      = "Vivek"
    team       = "LearningTF"
    tool       = "Terraform"
    monitoring = "true"
    Name       = "vault-consul-cluster"
    Project    = "Security-Automation"
  }
}

#####==============Local variables======================#####
locals {
  common_tags = {
    Team        = var.owner_team
    Environment = var.environment
    Component   = var.component_name
  }
}

