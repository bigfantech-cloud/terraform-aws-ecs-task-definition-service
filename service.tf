locals {
  ecs_service_name = var.ignore_task_definition_change ? aws_ecs_service.ignore_task_definition_change[0].name : aws_ecs_service.service[0].name
}

resource "aws_ecs_service" "service" {
  count = !var.ignore_task_definition_change ? 1 : 0

  name                   = var.ecs_service_name
  cluster                = var.cluster_id
  task_definition        = aws_ecs_task_definition.td.arn
  desired_count          = var.ecs_task_desired_count
  enable_execute_command = var.ecs_exec_enabled

  dynamic "capacity_provider_strategy" {
    for_each = var.capacity_provider_strategies
    content {
      capacity_provider = capacity_provider_strategy.value.capacity_provider
      weight            = capacity_provider_strategy.value.weight
      base              = capacity_provider_strategy.value.base
    }
  }

  load_balancer {
    target_group_arn = var.lb_target_group_arn
    container_name   = var.container_name
    container_port   = var.container_port
  }

  network_configuration {
    subnets          = var.subnets
    assign_public_ip = true
    security_groups  = [aws_security_group.task_sg.id]
  }

  lifecycle {
    ignore_changes = [
      desired_count
    ]
  }

  depends_on = [
    aws_ecs_task_definition.td,
  ]

  tags = module.this.tags
}


resource "aws_ecs_service" "ignore_task_definition_change" {
  count = var.ignore_task_definition_change ? 1 : 0

  name                   = var.ecs_service_name
  cluster                = var.cluster_id
  task_definition        = aws_ecs_task_definition.td.arn
  desired_count          = var.ecs_task_desired_count
  enable_execute_command = var.ecs_exec_enabled

  dynamic "capacity_provider_strategy" {
    for_each = var.capacity_provider_strategies
    content {
      capacity_provider = capacity_provider_strategy.value.capacity_provider
      weight            = capacity_provider_strategy.value.weight
      base              = capacity_provider_strategy.value.base
    }
  }

  load_balancer {
    target_group_arn = var.lb_target_group_arn
    container_name   = var.container_name
    container_port   = var.container_port
  }

  network_configuration {
    subnets          = var.subnets
    assign_public_ip = true
    security_groups  = [aws_security_group.task_sg.id]
  }

  lifecycle {
    ignore_changes = [
      desired_count,
      task_definition,
    ]
  }

  depends_on = [
    aws_ecs_task_definition.td,
  ]

  tags = module.this.tags
}
