locals {
  ecs_service_name = var.ignore_task_definition_change ? aws_ecs_service.ignore_task_definition_change[0].name : aws_ecs_service.service[0].name
}

data "aws_region" "current" {}

resource "aws_cloudwatch_log_group" "service_connect" {
  count = var.service_connect_configuration.enabled ? 1 : 0

  name              = "/ecs/service-connect/${module.this.id}/${var.container_name}"
  retention_in_days = 90

  tags = module.this.tags
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

  dynamic "service_connect_configuration" {
    for_each = coalesce(var.service_connect_configuration.enabled, false) ? [1] : []

    content {
      enabled   = true
      namespace = var.service_connect_configuration.namespace

      log_configuration = {
        log_driver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.service_connect[0].name
          awslogs-region        = data.aws_region.current.name
          awslogs-stream-prefix = "ecs-service-connect"
        }
      }

      dynamic "service" {
        for_each = coalesce(var.service_connect_configuration.services, [])

        content {
          port_name             = service.value["port_name"]
          discovery_name        = service.value["discovery_name"]
          ingress_port_override = service.value["ingress_port_override"]
          client_alias {
            dns_name = service.value["client_alias_dns_name"]
            port     = service.value["client_alias_port"]
          }
        }
      }
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
    security_groups  = [aws_security_group.default.id]
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

  dynamic "service_connect_configuration" {
    for_each = coalesce(var.service_connect_configuration.enabled, false) ? [1] : []

    content {
      enabled   = true
      namespace = var.service_connect_configuration.namespace

      log_configuration = {
        log_driver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.service_connect[0].name
          awslogs-region        = data.aws_region.current.name
          awslogs-stream-prefix = "ecs-service-connect"
        }
      }

      dynamic "service" {
        for_each = coalesce(var.service_connect_configuration.services, [])

        content {
          port_name             = service.value["port_name"]
          discovery_name        = service.value["discovery_name"]
          ingress_port_override = service.value["ingress_port_override"]
          client_alias {
            dns_name = service.value["client_alias_dns_name"]
            port     = service.value["client_alias_port"]
          }
        }
      }
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
    security_groups  = [aws_security_group.default.id]
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
