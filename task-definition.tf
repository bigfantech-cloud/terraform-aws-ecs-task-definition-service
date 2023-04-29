resource "aws_ecs_task_definition" "td" {
  family                   = module.this.id
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.task_cpu
  memory                   = var.task_memory

  task_role_arn      = aws_iam_role.task_role.arn
  execution_role_arn = aws_iam_role.task_execution_role.arn

  skip_destroy          = true
  container_definitions = jsonencode(var.container_definitions)

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  depends_on = [
    aws_iam_role.task_execution_role,
    aws_iam_role.task_role,
  ]
}
