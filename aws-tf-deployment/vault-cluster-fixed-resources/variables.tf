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
}

#####======================DynamoDB Table Variables=========================#####
variable "read_capacity" {
  type        = number
  description = "RCU for dynamoDB table"
}

variable "write_capacity" {
  type        = number
  description = "RCU for dynamoDB table"
}

#####========================Secret Key Variables==============================#####
variable "private_key_algorithm" {
  type        = string
  description = "The name of the algorithm to use for private keys. Must be one of: RSA or ECDSA."
}

variable "private_key_rsa_bits" {
  type        = string
  description = "The size of the generated RSA key in bits. Should only be used if var.private_key_algorithm is RSA."
}

variable "validity_period_hours" {
  type        = number
  description = "Number of hours the CA certificate is valid"
}

variable "ca_common_name" {
  type        = string
  description = "CA cert common name"
  default     = "vault.server.in"
}

variable "organization_name" {
  type        = string
  description = "Organization name for the CA cert"
  default     = "DoubleDigit Solutions"
}

## https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/self_signed_cert#allowed_uses
variable "ca_allowed_uses" {
  description = "List of keywords from RFC5280 describing a use that is permitted for the issued certificate."
  type        = list(string)

  default = [
    "cert_signing",
    "key_encipherment",
    "digital_signature",
  ]
}

variable "ca_public_key_file_path" {
  type        = string
  description = "Write the PEM-encoded CA certificate public key to this path (e.g. /etc/tls/ca.crt.pem)."
  default     = "tls/ca.crt.pem"
}

variable "public_key_file_path" {
  type        = string
  description = "Write the PEM-encoded certificate public key to this path (e.g. /etc/tls/vault.crt.pem)."
  default     = "tls/vault.crt.pem"
}

variable "private_key_file_path" {
  type        = string
  description = "Write the PEM-encoded certificate private key to this path (e.g. /etc/tls/vault.key.pem)."
  default     = "tls/vault.key.pem"
}

variable "permissions" {
  type        = string
  description = "The Unix file permission to assign to the cert files (e.g. 0600)."
  default     = "0600"
}

variable "owner" {
  description = "The OS user who should be given ownership over the certificate files."
  default     = "vivekm"
}

variable "ip_addresses" {
  description = "List of IP addresses for which the certificate will be valid (e.g. 127.0.0.1)."
  type        = list(string)
  default = [
    "127.0.0.1"
  ]
}

variable "common_name" {
  description = "The common name to use in the subject of the certificate (e.g. acme.co cert)."
  default     = "vault.server.in"
}


variable "dns_names" {
  description = "List of DNS names for which the certificate will be valid (e.g. vault.service.consul, foo.example.com)."
  type        = list(string)
  default = [
    "cloud-interview.in",
    "localhost"
  ]
}

variable "allowed_uses" {
  description = "List of keywords from RFC5280 describing a use that is permitted for the issued certificate. For more info and the list of keywords, see https://www.terraform.io/docs/providers/tls/r/self_signed_cert.html#allowed_uses."
  type        = list(string)

  default = [
    "client_auth",
    "digital_signature",
    "key_agreement",
    "key_encipherment",
    "server_auth",
  ]
}

variable "kms_key_id" {
  type        = string
  description = "Specifies the ARN or ID of the AWS KMS customer master key (CMK) to be used to encrypt the secret values"
  default     = null
}


variable "recovery_window" {
  type        = number
  description = "Specifies the number of days that AWS Secrets Manager waits before it can delete the secret"
  default     = 0
}

#####=======================================KMS Key Variables===========================#####
variable "kms_key_deletion_window" {
  type        = number
  description = "Duration in days after which the key is deleted after destruction of the resource (must be between 7 and 30 days)."
}

variable "user_supplied_kms_key_arn" {
  type        = string
  description = "(OPTIONAL) User-provided KMS key ARN. Providing this will disable the KMS submodule from generating a KMS key used for Vault auto-unseal"
  default     = null
}


#####==============================================IAM Variables====================================#####
variable "user_supplied_iam_role_name" {
  type        = string
  description = "This will be used for the instance profile provided to the AWS launch configuration. The minimum permissions must match the defaults generated by the IAM submodule for cloud auto-join and auto-unseal."
  default     = null
}

variable "aws_bucket_vault_license_arn" {
  type        = string
  description = "ARN of S3 bucket with Vault license"
}

variable "secrets_manager_arn" {
  type        = string
  description = "Secrets manager ARN where TLS cert info is stored"
}

#####=============================================Route53 Config=======================================#####
variable "domain" {
  type        = string
  description = "Domain name registered with AWS Route 53"
}

variable "cluster_dns" {
  type        = string
  description = "DNS name for the cluster"
}


#####===============================================S3 Bucket Variables=================================#####
variable "vault_license_filepath" {
  type        = string
  description = "Absolute filepath to location of Vault license file"
}

variable "vault_license_name" {
  type        = string
  description = "Filename for Vault license file"
  default     = "vault.hclic"
}

#####==========================================Vault LB=======================================#####
variable "lb_type" {
  type        = string
  description = "The type of load balancer to provision: network or application."
}

variable "allowed_inbound_cidrs" {
  type        = list(string)
  description = "List of CIDR blocks to permit inbound traffic from to load balancer"
  default     = null
}

variable "vault_cluster_sg_id" {
  type        = string
  description = "Security group ID of Vault cluster"
}

variable "lb_subnets" {
  type        = list(string)
  description = "Subnets where load balancer will be deployed"
}

variable "lb_health_check_path" {
  type        = string
  description = "The endpoint to check for Vault's health status."
  default     = "/v1/sys/health?activecode=200&standbycode=200&sealedcode=200&uninitcode=200"
}

variable "ssl_policy" {
  type        = string
  default     = "ELBSecurityPolicy-TLS-1-2-2017-01"
  description = "SSL policy to use on LB listener"
}

#####==============Local variables======================#####
locals {
  common_tags = {
    Team        = var.owner_team
    Environment = var.environment
    Component   = var.component_name
  }
}
