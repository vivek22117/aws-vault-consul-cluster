###################################################################
# Generate a private key so you can create a CA cert with it      #
###################################################################
resource "tls_private_key" "vault_ca" {
  algorithm = var.private_key_algorithm
  rsa_bits  = var.private_key_rsa_bits
}

###################################################################
# Create a CA cert with the private key you just generated.       #
###################################################################
resource "tls_self_signed_cert" "vault_ca_cert" {
  key_algorithm   = tls_private_key.vault_ca.algorithm
  private_key_pem = tls_private_key.vault_ca.private_key_pem
  is_ca_certificate = true

  subject {
    common_name = var.ca_common_name
    organization = var.organization_name
  }

  validity_period_hours = var.validity_period_hours

  allowed_uses = [
    "cert_signing",
    "crl_signing",
  ]


  # Store the CA public key in a file.
  provisioner "local-exec" {
    command = "echo '${tls_self_signed_cert.vault_ca_cert.cert_pem}' > '${var.ca_public_key_file_path}' && chmod ${var.permissions} '${var.ca_public_key_file_path}' && chown ${var.owner} '${var.ca_public_key_file_path}'"
  }
}
