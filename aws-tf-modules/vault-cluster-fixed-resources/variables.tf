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
  type = number
  description = "RCU for dynamoDB table"
}

variable "write_capacity" {
  type = number
  description = "RCU for dynamoDB table"
}

#####========================Secret Key Variables==============================#####
variable "private_key_algorithm" {
  type = string
  description = "The name of the algorithm to use for private keys. Must be one of: RSA or ECDSA."
  default     = "RSA"
}

variable "private_key_rsa_bits" {
  type = string
  description = "The size of the generated RSA key in bits. Should only be used if var.private_key_algorithm is RSA."
  default     = "2048"
}

variable "validity_period_hours" {
  type = number
  description = "Number of hours the CA certificate is valid"
}


variable "ca_common_name" {
  type = string
  description = "CA cert common name"
}

variable "organization_name" {
  type = string
  description = "Organization name for the CA cert"
}

## https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/self_signed_cert#allowed_uses
variable "ca_allowed_uses" {
  description = "List of keywords from RFC5280 describing a use that is permitted for the issued certificate."
  type        = "list"

  default = [
    "cert_signing",
    "key_encipherment",
    "digital_signature",
  ]
}

variable "ca_public_key_file_path" {
  type = string
  description = "Write the PEM-encoded CA certificate public key to this path (e.g. /etc/tls/ca.crt.pem)."
  default = "tls/ca.crt.pem"
}

variable "public_key_file_path" {
  type = string
  description = "Write the PEM-encoded certificate public key to this path (e.g. /etc/tls/vault.crt.pem)."
  default = "tls/vault.crt.pem"
}

variable "private_key_file_path" {
  type = string
  description = "Write the PEM-encoded certificate private key to this path (e.g. /etc/tls/vault.key.pem)."
  default = "tls/vault.key.pem"
}

variable "permissions" {
  type = string
  description = "The Unix file permission to assign to the cert files (e.g. 0600)."
  default     = "0600"
}

variable "owner" {
  description = "The OS user who should be given ownership over the certificate files."
  default = "vivekm"
}

variable "ip_addresses" {
  description = "List of IP addresses for which the certificate will be valid (e.g. 127.0.0.1)."
  type        = "list"
  default = [
    "127.0.0.1"
  ]
}

variable "common_name" {
  description = "The common name to use in the subject of the certificate (e.g. acme.co cert)."
  default = "doubledigit-solutions cert"
}


variable "dns_names" {
  description = "List of DNS names for which the certificate will be valid (e.g. vault.service.consul, foo.example.com)."
  type        = "list"
  default = [
    "doubledigit-solutions.com"
  ]
}

variable "allowed_uses" {
  description = "List of keywords from RFC5280 describing a use that is permitted for the issued certificate. For more info and the list of keywords, see https://www.terraform.io/docs/providers/tls/r/self_signed_cert.html#allowed_uses."
  type        = "list"

  default = [
    "client_auth",
    "digital_signature",
    "key_agreement",
    "key_encipherment",
    "server_auth",
  ]
}

#####==============Local variables======================#####
locals {
  common_tags = {
    Team        = var.owner_team
    Environment = var.environment
    Component   = var.component_name
  }
}
