resource "aws_security_group" "main" {
  name        = "${var.service_name}-sg"
  vpc_id      = var.vpc_id
  description = "Security group for ALB"


}

resource "aws_security_group_rule" "main" {
  for_each          = var.security_group_rules
  type              = each.value.type
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  cidr_blocks       = each.value.cidr_blocks
  security_group_id = aws_security_group.main.id
}

resource "aws_security_group_rule" "rule_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.main.id
  description       = "Allow all outbound traffic"
}