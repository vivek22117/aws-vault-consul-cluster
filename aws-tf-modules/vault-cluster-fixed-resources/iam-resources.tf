data "aws_iam_policy_document" "vault_instance_role_doc" {
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "vault_instance_role" {
  count = var.user_supplied_iam_role_name != null ? 0 : 1

  name_prefix        = "${var.environment}-${var.component_name}-role"
  assume_role_policy = data.aws_iam_policy_document.vault_instance_role_doc.json
}

resource "aws_iam_instance_profile" "vault_instance_profile" {
  name_prefix = "${var.environment}-${var.component_name}-instance-profile"
  role        = var.user_supplied_iam_role_name != null ? var.user_supplied_iam_role_name : aws_iam_role.vault_instance_role[0].name
}

################################################################################
#          Add IAM Policies to Vault Instance Role                             #
################################################################################
data "aws_iam_policy_document" "cloud_auto_join_policy_doc" {
  statement {
    effect = "Allow"

    actions = [
      "ec2:DescribeInstances",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "cloud_auto_join" {
  count = var.user_supplied_iam_role_name != null ? 0 : 1

  name   = "${var.component_name}-auto-join-policy"
  role   = aws_iam_role.vault_instance_role[0].id
  policy = data.aws_iam_policy_document.cloud_auto_join_policy_doc.json
}


resource "aws_iam_role_policy" "auto_unseal_s3_license" {
  count = var.user_supplied_iam_role_name != null ? 0 : 1

  name   = "${var.component_name}-vault-auto-unseal-policy"
  role   = aws_iam_role.vault_instance_role[0].id
  policy = data.aws_iam_policy_document.auto_unseal_s3_license_policy_doc.json
}

data "aws_iam_policy_document" "auto_unseal_s3_license_policy_doc" {
  statement {
    effect = "Allow"

    actions = [
      "kms:DescribeKey",
      "kms:Encrypt",
      "kms:Decrypt",
    ]

    resources = [
      aws_kms_key.vault_key.arn,
    ]
  }
}

resource "aws_iam_role_policy" "session_manager" {
  count = var.user_supplied_iam_role_name != null ? 0 : 1

  name   = "${var.component_name}-vault-ssm-policy"
  role   = aws_iam_role.vault_instance_role[0].id
  policy = data.aws_iam_policy_document.session_manager_policy_doc.json
}

data "aws_iam_policy_document" "session_manager_policy_doc" {
  statement {
    effect = "Allow"

    actions = [
      "ssm:UpdateInstanceInformation",
      "ssmmessages:CreateControlChannel",
      "ssmmessages:CreateDataChannel",
      "ssmmessages:OpenControlChannel",
      "ssmmessages:OpenDataChannel"
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_role_policy" "secrets_manager" {
  count = var.user_supplied_iam_role_name != null ? 0 : 1

  name   = "${var.component_name}-vault-secrets-manager-policy"
  role   = aws_iam_role.vault_instance_role[0].id
  policy = data.aws_iam_policy_document.session_manager_policy_doc.json
}

data "aws_iam_policy_document" "secrets_manager_policy_doc" {
  statement {
    effect = "Allow"

    actions = [
      "secretsmanager:GetSecretValue",
    ]

    resources = [
      var.secrets_manager_arn,
    ]
  }
}

resource "aws_iam_role_policy" "s3_bucket_vault_license" {
  count = var.user_supplied_iam_role_name != null ? 0 : 1

  name   = "${var.component_name}-vault-license-s3-policy"
  role   = aws_iam_role.vault_instance_role[0].id
  policy = data.aws_iam_policy_document.s3_bucket_vault_license_policy_doc.json
}

data "aws_iam_policy_document" "s3_bucket_vault_license_policy_doc" {
  statement {
    effect = "Allow"

    actions = [
      "s3:Get*",
      "s3:List*",
    ]

    resources = [
      var.aws_bucket_vault_license_arn,
      "${var.aws_bucket_vault_license_arn}/*",
    ]
  }
}
