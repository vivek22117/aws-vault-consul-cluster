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

  allowed_uses = [var.ca_allowed_uses]


  # Store the CA public key in a file.
  provisioner "local-exec" {
    command = "echo '${tls_self_signed_cert.vault_ca_cert.cert_pem}' > '${var.ca_public_key_file_path}' && chmod ${var.permissions} '${var.ca_public_key_file_path}' && chown ${var.owner} '${var.ca_public_key_file_path}'"
  }
}


####################################################################
# Generate another private key. This one will be used              #
# To create the certs on your Vault nodes                          #
####################################################################
resource "tls_private_key" "vault_node_key" {
  algorithm   = var.private_key_algorithm
  rsa_bits    = var.private_key_rsa_bits

  # Store the certificate's private key in a file.
  provisioner "local-exec" {
    command = "echo '${tls_private_key.vault_node_key.private_key_pem}' > '${var.private_key_file_path}' && chmod ${var.permissions} '${var.private_key_file_path}' && chown ${var.owner} '${var.private_key_file_path}'"
  }
}

resource "tls_cert_request" "vault_node_cert" {
  key_algorithm   = tls_private_key.vault_node_key.algorithm
  private_key_pem = tls_private_key.vault_node_key.private_key_pem

  dns_names    = [var.dns_names]
  ip_addresses = [var.ip_addresses]

  subject {
    common_name  = var.common_name
    organization = var.organization_name
  }
}


resource "tls_locally_signed_cert" "vault_node_cert" {
  cert_request_pem = tls_cert_request.vault_node_cert.cert_request_pem

  ca_key_algorithm   = tls_private_key.vault_ca.algorithm
  ca_private_key_pem = tls_private_key.vault_ca.private_key_pem
  ca_cert_pem        = tls_self_signed_cert.vault_ca_cert.cert_pem

  validity_period_hours = var.validity_period_hours
  allowed_uses          = [var.allowed_uses]

  # Store the certificate's public key in a file.
  provisioner "local-exec" {
    command = "echo '${tls_locally_signed_cert.vault_node_cert.cert_pem}' > '${var.public_key_file_path}' && chmod ${var.permissions} '${var.public_key_file_path}' && chown ${var.owner} '${var.public_key_file_path}'"
  }
}
