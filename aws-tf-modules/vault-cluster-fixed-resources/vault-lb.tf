resource "aws_security_group" "vault_lb" {
  count       = var.lb_type == "application" ? 1 : 0

  description = "Security group for the application load balancer"
  name        = "${var.component_name}-vault-lb-sg"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  tags = merge(local.common_tags, tomap({"Name"= "${var.environment}-lb-sg"}))
}

resource "aws_security_group_rule" "vault_lb_inbound" {
  count             = var.lb_type == "application" && var.allowed_inbound_cidrs != null ? 1 : 0

  description       = "Allow specified CIDRs access to load balancer on port 8200"
  security_group_id = aws_security_group.vault_lb[0].id

  type              = "ingress"
  from_port         = 8200
  to_port           = 8200
  protocol          = "tcp"
  cidr_blocks       = var.allowed_inbound_cidrs
}

resource "aws_security_group_rule" "vault_lb_outbound" {
  count                    = var.lb_type == "application" ? 1 : 0

  description              = "Allow outbound traffic from load balancer to Vault nodes on port 8200"
  security_group_id        = aws_security_group.vault_lb[0].id
  type                     = "egress"
  from_port                = 8200
  to_port                  = 8200
  protocol                 = "tcp"
  source_security_group_id = var.vault_cluster_sg_id
}
