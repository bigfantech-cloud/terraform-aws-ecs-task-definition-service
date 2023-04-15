# Purpose:

To create ECS Task Definition, ECS Service.

## Variable Inputs:

#### REQUIRED:

```
- project_name              (ex: project name)
- environment               (ex: dev/prod)
- task_cpu                  CPU size (ex: 512)
- task_memory               Memory size (ex: 1024)
- container_definitions     module.container.cd_json
- ecs_service_name          Name the ECS Service
- cluster_id                module.ecs-cluster.cluster_id
- lb_target_group_arn       module.alb.alb_target_group_arn
- subnets                   module.network.public_subnet_ids
- container_port            Container port to associate with ALB Target Group. (ex: 80)
- container_name            Name of the container to associate with the load balancer.
- vpc_id                    module.network.vpc_id
- ecs_lb_security_group_id  module.alb.ecs_lb_security_group_id
```

#### OPTIONAL:

```
- capacity_provider_strategies                    List of ECS Service Capacity Provider Strategies.
- ecs_task_desired_count                          Number of ECS Task to run. Default = 1.
- ecs_exec_enabled                                Specifies whether to enable Amazon ECS Exec for the tasks within the service.
                                                  Adds required SSM permission to Task IAM Role. Default = true.
- td_skip_destroy                                 Whether to retain the old revision when the Task Definition is updated or
                                                  replacement is necessary. Default = true.
- additional_ecs_task_iam_permisssions            List of additional IAM permissions to attach to ECS Task IAM role
- additional_ecs_task_execution_iam_permisssions  List of additional IAM permissions to attach to ECS Task Execution IAM role
```

## Major resources created:

- aws_ecs_service
- aws_ecs_task_definition
- aws_security_group (allowing ingress fron ALB)
- aws_iam_policy: task_execution_policy, task_policy.
- aws_iam_role: task_execution_role, task_role.

# Steps to create the resources

1. Call the module from your tf code.
2. Specify variable inputs.

Example:

```
module "ecs-td-service" {
  source        = "bigfantech-cloud/ecs-task-definition-service/aws"
  version       = "1.0.0"
  project_name  = "abc"
  environment   = "dev"

  #td
  task_cpu              = 512
  task_memory           = 1024
  container_definitions = [module.container.cd_json_object, module.container2.cd_json_object]
  additional_ecs_task_iam_permisssions = [
    "s3:GetObject",
    "s3:ListBucket",
    "s3:PutObject",
    "s3:DeleteObject",
  ]

  #service
  ecs_service_name             = "nodeJs"
  cluster_id                   = module.ecs-cluster.cluster_id
  lb_target_group_arn          = module.alb.alb_target_group_arn
  subnets                      = module.network.public_subnet_ids
  container_port               = 80
  container_name               = "server"
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

  vpc_id                   = module.network.vpc_id
  ecs_lb_security_group_id = module.alb.ecs_lb_security_group_id

  depends_on = [
    module.ecs-cluster,
  ]
}
```

3. Apply: From terminal run following commands.

```
terraform init
```

```
terraform plan
```

```
terraform apply
```

---

##OUTPUTS

```

#-----
#TASK DEFINITION
#-----

task_definition_arn
  description = "ECS Task Definition ARN"

task_security_group_id
  description = "ID of security group attached to ECS Task. Allows ingress from the LB only, egress all port"

#-----
#SERVICE
#-----

ecs_serivce_name
  description = "ECS service name"

#-----
#TASK IAM
#-----

task_iam_role_name
  description = "Name of the IAM role for ECS Task."

#-----
#TASK EXECUTION IAM
#-----

task_execution_iam_role_name
  description = "Name of the IAM role for ECS Task Execution."


```
