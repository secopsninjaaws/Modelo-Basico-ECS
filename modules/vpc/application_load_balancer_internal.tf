resource "aws_alb" "internal" {
  count              = var.alb_internal == "true" ? 1 : 0
  name               = "${var.project_name}-alb-internal"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.internal_alb[0].id]
  subnets            = element(["${aws_subnet.private_subnets[*].id}"], var.subnets_count)

  enable_deletion_protection = false
  enable_http2               = true
  enable_waf_fail_open       = false


}

resource "aws_alb_listener" "internal_listiner_80" {
  count             = var.alb_internal == "true" ? 1 : 0
  load_balancer_arn = aws_alb.internal[0].arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Hello, World!"
      status_code  = "200"
    }
  }

}

##################################################### Security Group #####################################################

resource "aws_security_group" "internal_alb" {
  count       = var.alb_internal == "true" ? 1 : 0
  name        = "${var.project_name}-alb-public-sg"
  vpc_id      = aws_vpc.main.id
  description = "Security group for ALB"


}

resource "aws_security_group_rule" "rule_http_internal" {
  count             = var.alb_internal == "true" ? 1 : 0
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "TCP"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.internal_alb[0].id
  description       = "Allow HTTP traffic"
}
resource "aws_security_group_rule" "rule_egress_internal" {
  count             = var.alb_internal == "true" ? 1 : 0
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.internal_alb[0].id
  description       = "Allow all outbound traffic"
}