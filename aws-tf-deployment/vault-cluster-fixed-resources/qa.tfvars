default_region = "us-east-1"
owner_team     = "DD-Team"


component_name = "vault-cluster"

write_capacity = 5
read_capacity  = 5

private_key_algorithm = "RSA"
private_key_rsa_bits  = "2048"

validity_period_hours = "755"
ca_common_name        = "vault.server.in"
organization_name     = "DoubleDigit Solutions"

ca_allowed_uses = [
  "cert_signing",
  "key_encipherment",
  "digital_signature",
]

ip_addresses = [
  "127.0.0.1"
]

common_name = "vault.server.in"
dns_names = [
  "cloud-interview.in",
  "localhost"
]
allowed_uses = [
  "client_auth",
  "digital_signature",
  "key_agreement",
  "key_encipherment",
  "server_auth",
]

kms_key_id                  = null
recovery_window             = 0
kms_key_deletion_window     = 7
user_supplied_kms_key_arn   = null
user_supplied_iam_role_name = null



