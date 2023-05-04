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

### Required Variables

| Name                       | Description                                                      | Default |
| -------------------------- | ---------------------------------------------------------------- | ------- |
| `project_name`             |                                                                  |
| `environment`              |                                                                  |
| `task_cpu`                 | CPU size (example: 512)                                          |
| `task_memory`              | Memory size (example: 1024)                                      |
| `container_definitions`    | module.container.cd_json                                         |
| `ecs_service_name`         | Name the ECS Service                                             |
| `cluster_id`               | ECS Cluster ID                                                   |
| `lb_target_group_arn`      | ALB target group to add ECS Service target                       |
| `subnets`                  | List of subnets to create Service/Tasks in                       |
| `container_port`           | Container port to associate with ALB Target Group. (example: 80) |
| `container_name`           | Name of the container to associate with the load balancer        |
| `vpc_id`                   | VPC IS                                                           |
| `ecs_lb_security_group_id` | ALB secuirty group ID                                            |

### OPTIONAL:

| Name                                             | Description                                                                                              | Default                                                                    |
| ------------------------------------------------ | -------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------- |
| `capacity_provider_strategies`                   | List of ECS Service Capacity Provider Strategies                                                         | [{<br>capacity_provider = "FARGATE_SPOT"<br>weight = 100<br>base = 1<br>}] |
| `ignore_task_definition_change`                  | Whether to ignore updating ECS Service when new Task Definition is created through Terraform             | false                                                                      |
| `ecs_task_desired_count`                         | Number of ECS Task to run                                                                                | 1                                                                          |
| `ecs_exec_enabled`                               | Specifies whether to enable Amazon ECS Exec for the tasks within the service                             | true                                                                       |
| `td_skip_destroy`                                | Whether to retain the old revision when the Task Definition is updated or replacement is necessary       | true                                                                       |
| `additional_ecs_task_iam_permisssions`           | List of additional IAM permissions to attach to ECS Task IAM role                                        | []                                                                         |
| `additional_ecs_task_execution_iam_permisssions` | List of additional IAM permissions to attach to ECS Task Execution IAM role                              | []                                                                         |
| `custom_task_policy_document`                    | Custom IAM policy document for ECS Task role to attach instead of policy document defined in this module.<br>Use `aws_iam_policy_document` data block to generate JSON           | null                                                                       |
| `custom_task_execution_policy_document`          | Custom IAM policy document for ECS Task Execution role to attach instead of policy document defined in this module.<br>Use `aws_iam_policy_document` data block to generate JSON    | null                                                                       |

### Example config

> Check the `example` folder in this repo

### Outputs

| Name                           | Description                                                                                 |
| ------------------------------ | ------------------------------------------------------------------------------------------- |
| `task_definition_arn`          | ECS Task Definition ARN                                                                     |
| `task_security_group_id`       | ID of security group attached to ECS Task. Allows ingress from the LB only, egress all port |
| `ecs_serivce_name`             | ECS service name                                                                            |
| `task_iam_role_name`           | Name of the IAM role for ECS Task                                                           |
| `task_execution_iam_role_name` | Name of the IAM role for ECS Task Execution                                                 |
