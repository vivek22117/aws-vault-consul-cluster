data "aws_ami" "ubuntu_ami" {
  count       = var.user_supplied_ami_id != null ? 0 : 1
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

###################################################
# Fetch remote state vault fixed resources        #
###################################################
data "terraform_remote_state" "vault_resources" {
  backend = "s3"

  config = {
    bucket = "${var.environment}-tfstate-${data.aws_caller_identity.current.account_id}-${var.default_region}"
    key    = "state/${var.environment}/vault-resources/terraform.tfstate"
    region = var.default_region
  }
}

data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = "${var.environment}-tfstate-${data.aws_caller_identity.current.account_id}-${var.default_region}"
    key    = "state/${var.environment}/vpc/terraform.tfstate"
    region = var.default_region
  }
}

# used for accessing Account ID and ARN
data "aws_caller_identity" "current" {}
