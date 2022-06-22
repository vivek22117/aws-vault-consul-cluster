resource "aws_security_group" "vault_cluster_sg" {
  name   = "${var.component_name}-sg"
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id

  tags = merge(local.common_tags, tomap({ "Name" = "${var.component_name}-sg" }))
}

resource "aws_security_group_rule" "vault_internal_api" {
  description       = "Allow Vault nodes to reach other on port 8200 for API"
  security_group_id = aws_security_group.vault_cluster_sg.id

  type      = "ingress"
  protocol  = "tcp"
  from_port = 8200
  to_port   = 8200
  self      = true
}

resource "aws_security_group_rule" "vault_ssh_inbound" {
  description       = "Allow specified CIDRs SSH access to Vault nodes"
  security_group_id = aws_security_group.vault_cluster_sg.id

  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = data.terraform_remote_state.vpc.outputs.vpc_cidr_block
}

resource "aws_security_group_rule" "vault_application_lb_inbound" {
  description       = "Allow load balancer to reach Vault nodes on port 8200"
  security_group_id = aws_security_group.vault_cluster_sg.id

  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 8200
  to_port                  = 8200
  source_security_group_id = data.terraform_remote_state.vault_resources.outputs.vault_lb_sg
}

resource "aws_security_group_rule" "vault_internal_raft" {
  description       = "Allow Vault nodes to communicate on port 8201 for replication traffic, request forwarding, and Raft gossip"
  security_group_id = aws_security_group.vault_cluster_sg.id

  type      = "ingress"
  protocol  = "tcp"
  from_port = 8201
  to_port   = 8201
  self      = true
}

resource "aws_security_group_rule" "vault_outbound" {
  description       = "Allow Vault nodes to send outbound traffic"
  security_group_id = aws_security_group.vault_cluster_sg.id

  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

