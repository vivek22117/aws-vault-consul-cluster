resource "aws_security_group" "vault_lb" {
  count = var.lb_type == "application" ? 1 : 0

  name        = "${var.component_name}-lb-sg"
  description = "Security group for the Vault ALB"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  tags = merge(local.common_tags, tomap({ "Name" = "${var.environment}-${var.component_name}-lb-sg" }))
}

resource "aws_security_group_rule" "vault_lb_inbound" {
  count = var.lb_type == "application" && var.allowed_inbound_cidrs != null ? 1 : 0

  security_group_id = aws_security_group.vault_lb[0].id
  description       = "Allow specified CIDRs access to load balancer on port 8200"

  type        = "ingress"
  protocol    = "tcp"
  from_port   = 8200
  to_port     = 8200
  cidr_blocks = var.allowed_inbound_cidrs
}

resource "aws_security_group_rule" "vault_lb_outbound" {
  count = var.lb_type == "application" ? 1 : 0

  description       = "Allow outbound traffic from load balancer to Vault nodes on port 8200"
  security_group_id = aws_security_group.vault_lb[0].id

  type                     = "egress"
  protocol                 = "tcp"
  from_port                = 8200
  to_port                  = 8200
  source_security_group_id = var.vault_cluster_sg_id
}


locals {
  lb_security_groups = var.lb_type == "network" ? null : [aws_security_group.vault_lb[0].id]
  lb_protocol        = var.lb_type == "network" ? "TCP" : "HTTPS"
}

resource "aws_alb" "vault_alb" {
  name = "${var.component_name}-lb"

  drop_invalid_header_fields = var.lb_type == "application" ? true : null
  load_balancer_type         = var.lb_type
  security_groups            = local.lb_security_groups
  enable_http2               = "true"
  idle_timeout               = 600
  internal                   = true
  subnets                    = data.terraform_remote_state.vpc.outputs.vault_consul_subnets

  tags = merge(local.common_tags, tomap({ "Name" = "${var.environment}-lb" }))
}

resource "aws_lb_target_group" "vault_alb_default_target_group" {
  name = "${var.component_name}-vault-tg-${var.environment}"

  port        = 8200
  protocol    = local.lb_protocol
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id
  target_type = "instance"

  tags = {
    name = "${var.component_name}-tg"
  }

  health_check {
    enabled             = true
    protocol            = "HTTPS"
    port                = "traffic-port"
    healthy_threshold   = 5
    unhealthy_threshold = 5
    timeout             = 5
    interval            = 30
    path                = var.lb_health_check_path
    matcher             = "200,301,302"
  }
}

resource "aws_lb_listener" "vault_lb_listener" {
  load_balancer_arn = aws_alb.vault_alb.id
  port              = 8200
  protocol          = local.lb_protocol
  ssl_policy        = local.lb_protocol == "HTTPS" ? var.ssl_policy : null
  certificate_arn   = local.lb_protocol == "HTTPS" ? aws_acm_certificate.vault_cluster_certificate.arn : null

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.vault_alb_default_target_group.arn
  }
}
