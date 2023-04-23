# BigFantech-Cloud

We automate your infrastructure.
You will have full control of your infrastructure, including Infrastructure as Code (IaC).

To hire, email: `bigfantech@yahoo.com`

# Purpose of this code

> Terraform module

- Create ECS Task Definition
- Create ECS Service

## Required Providers

| Name                | Description |
| ------------------- | ----------- |
| aws (hashicorp/aws) | >= 4.47     |

## Variables

### Required Variables

| Name                     | Description                                                 |
| ------------------------ | ----------------------------------------------------------- |
| project_name             | (ex: project name)                                          |
| environment              | (ex: dev/prod)                                              |
| task_cpu                 | CPU size (ex: 512)                                          |
| task_memory              | Memory size (ex: 1024)                                      |
| container_definitions    | module.container.cd_json                                    |
| ecs_service_name         | Name the ECS Service                                        |
| cluster_id               | ECS Cluster ID                                              |
| lb_target_group_arn      | ALB target group to add ECS Service target                  |
| subnets                  | List of subnets to create Service/Tasks in                  |
| container_port           | Container port to associate with ALB Target Group. (ex: 80) |
| container_name           | Name of the container to associate with the load balancer   |
| vpc_id                   | VPC IS                                                      |
| ecs_lb_security_group_id | ALB secuirty group ID                                       |

### OPTIONAL:

| Name                                             | Description                                                                                                        |
| ------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------ |
| `capacity_provider_strategies`                   | List of ECS Service Capacity Provider Strategies                                                                   |
| `ignore_task_definition_change`                  | Whether to ignore updating ECS Service when new Task Definition is created through Terraform. Default = false      |
| `ecs_task_desired_count`                         | Number of ECS Task to run. Default = 1                                                                             |
| `ecs_exec_enabled`                               | Specifies whether to enable Amazon ECS Exec for the tasks within the service. Default = true                       |
| `td_skip_destroy`                                | Whether to retain the old revision when the Task Definition is updated or replacement is necessary. Default = true |
| `additional_ecs_task_iam_permisssions`           | List of additional IAM permissions to attach to ECS Task IAM role                                                  |
| `additional_ecs_task_execution_iam_permisssions` | List of additional IAM permissions to attach to ECS Task Execution IAM role                                        |

### Example config

> Check the `example` folder in this repo

### Outputs

| Name                         | Description                                                                                 |
| ---------------------------- | ------------------------------------------------------------------------------------------- |
| task_definition_arn          | ECS Task Definition ARN                                                                     |
| task_security_group_id       | ID of security group attached to ECS Task. Allows ingress from the LB only, egress all port |
| ecs_serivce_name             | ECS service name                                                                            |
| task_iam_role_name           | Name of the IAM role for ECS Task                                                           |
| task_execution_iam_role_name | Name of the IAM role for ECS Task Execution                                                 |
