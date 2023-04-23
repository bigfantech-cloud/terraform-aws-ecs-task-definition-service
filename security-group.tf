resource "aws_security_group" "task_sg" {
  name        = "${module.this.id}-ecs-task"
  description = "Allow inbound access only from the LB"
  vpc_id      = var.vpc_id

  tags = merge(
    module.this.tags,
    {
      Name = "${module.this.id}-ecs-task"
    },
  )
}

resource "aws_security_group_rule" "egress" {

  security_group_id = aws_security_group.task_sg.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "ingress" {

  security_group_id        = aws_security_group.task_sg.id
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = var.ecs_lb_security_group_id
}

