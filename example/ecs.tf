module "network" {
  source = "bigfantech-cloud/network/aws"

  project_name = "abc"
  cidr_block   = "10.0.0.0/16"
}

module "ecs_alb" {
  source = "bigfantech-cloud/alb-ecs/aws"

  #...
  #...... module attributes
  #.........
}

resource "aws_ecs_cluster" "default" {
  name = "thecluster"
}

resource "aws_ecs_cluster_capacity_providers" "custom" {
  cluster_name       = aws_ecs_cluster.default.name
  capacity_providers = ["FARGATE", "FARGATE_SPOT"]
}

module "ecs_container_definition" {
  source = "bigfantech-cloud/ecs-container-definition/aws"

  #...
  #...... module attributes
  #.........
}

module "ecs_td_service" {
  source  = "bigfantech-cloud/ecs-task-definition-service/aws"
  version = "1.0.0"

  project_name             = "abc"
  environment              = "dev"
  vpc_id                   = module.network.vpc_id
  ecs_lb_security_group_id = module.ecs_alb.ecs_lb_security_group_id
  subnets                  = "module.network.public_subnet_ids"
  lb_target_group_arn      = module.ecs_alb.alb_target_group_arn_map["server"]

  #td
  task_cpu              = 512
  task_memory           = 1024
  container_definitions = [module.ecs_container_definition.cd_json_object]
  additional_ecs_task_iam_permisssions = [
    "s3:GetObject",
  ]

  #service
  ecs_service_name = "server"
  cluster_id       = aws_ecs_cluster.default.id
  container_port   = 80
  container_name   = "server"
  capacity_provider_strategies = [
    {
      capacity_provider = FARGATE_SPOT
      weight            = 50
      base              = 1
    },
    {
      capacity_provider = FARGATE
      weight            = 50
      base              = 0
    }
  ]
}
