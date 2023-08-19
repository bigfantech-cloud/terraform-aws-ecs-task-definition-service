resource "aws_security_group" "default" {
  name        = "${module.this.id}-ecs-service"
  description = "Allow inbound access only from the LB"
  vpc_id      = var.vpc_id

  tags = merge(
    module.this.tags,
    {
      Name = "${module.this.id}-ecs-service"
    },
  )
}

resource "aws_security_group_rule" "egress" {

  security_group_id = aws_security_group.default.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "ingress" {

  security_group_id        = aws_security_group.default.id
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = var.lb_security_group_id
}

