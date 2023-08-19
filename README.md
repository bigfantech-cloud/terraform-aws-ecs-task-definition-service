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

| Name                    | Description                                                      | type         |
| ----------------------- | ---------------------------------------------------------------- | ------------ |
| `project_name`          |                                                                  | string       |
| `environment`           |                                                                  | string       |
| `task_cpu`              | CPU size (example: 512)                                          | number       |
| `task_memory`           | Memory size (example: 1024)                                      | number       |
| `container_definitions` | List of Container Definiton JSON objects                         | list(string) |
| `ecs_service_name`      | Name the ECS Service                                             | string       |
| `cluster_id`            | ECS Cluster ID                                                   | string       |
| `lb_target_group_arn`   | ALB target group to add ECS Service as target                    | string       |
| `subnets`               | List of subnets to create Service/Tasks in                       | list(string) |
| `container_port`        | Container port to associate with ALB Target Group. (example: 80) | number       |
| `container_name`        | Name of the container to associate with the load balancer        | string       |
| `vpc_id`                | VPC ID                                                           | string       |
| `lb_security_group_id`  | LB Security group ID to whitelist for inbound access to Service  | string       |

### OPTIONAL:

| Name                                             | Description                                                                                                                                                                      | Type                                                                                                                                                                                                                                                                                                              | Default                                                                    |
| ------------------------------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------- |
| `capacity_provider_strategies`                   | List of ECS Service Capacity Provider Strategies                                                                                                                                 | list(object({<br>capacity_provider = string<br>weight = number<br>base = number<br>}))                                                                                                                                                                                                                            | [{<br>capacity_provider = "FARGATE_SPOT"<br>weight = 100<br>base = 1<br>}] |
| `ignore_task_definition_change`                  | Whether to ignore updating ECS Service when new Task Definition is created through Terraform. If not ignored, always the later version of TD is used.                            | bool                                                                                                                                                                                                                                                                                                              | false                                                                      |
| `ecs_task_desired_count`                         | Number of ECS Task to run                                                                                                                                                        | number                                                                                                                                                                                                                                                                                                            | 1                                                                          |
| `ecs_exec_enabled`                               | Specifies whether to enable Amazon ECS Exec for the tasks within the service                                                                                                     | bool                                                                                                                                                                                                                                                                                                              | true                                                                       |
| `td_skip_destroy`                                | Whether to retain the old revision when the Task Definition is updated or replacement is necessary                                                                               | bool                                                                                                                                                                                                                                                                                                              | true                                                                       |
| `additional_ecs_task_iam_permisssions`           | List of additional IAM permissions to attach to ECS Task IAM role                                                                                                                | list(string)                                                                                                                                                                                                                                                                                                      | []                                                                         |
| `additional_ecs_task_execution_iam_permisssions` | List of additional IAM permissions to attach to ECS Task Execution IAM role                                                                                                      | list(string)                                                                                                                                                                                                                                                                                                      | []                                                                         |
| `custom_task_iam_policy_document`                | Custom IAM policy document for ECS Task role to attach instead of policy document defined in this module.<br>Use `aws_iam_policy_document` data block to generate JSON           | string                                                                                                                                                                                                                                                                                                            | null                                                                       |
| `custom_task_iam_execution_policy_document`      | Custom IAM policy document for ECS Task Execution role to attach instead of policy document defined in this module.<br>Use `aws_iam_policy_document` data block to generate JSON | string                                                                                                                                                                                                                                                                                                            | null                                                                       |
| `service_connect_configuration                   | ECS Service Connect configuration                                                                                                                                                | object({<br>enabled = optional(bool)<br> namespace = optional(string)<br> services = optional(list(object({<br> port_name = string<br> discovery_name = optional(string)<br> ingress_port_override = optional(number)<br> client_alias_dns_name = optional(string)<br> client_alias_port = number<br> })))<br> }) | {}                                                                         |

### Example config

> Check the `example` folder in this repo

### Outputs

| Name                           | Description                                  |
| ------------------------------ | -------------------------------------------- |
| `task_definition_arn`          | ECS Task Definition ARN                      |
| `task_security_group_id`       | ID of security group attached to ECS Service |
| `ecs_serivce_name`             | ECS service name                             |
| `task_iam_role_name`           | Name of the ECS Task IAM role                |
| `task_execution_iam_role_name` | Name of the ECS Task Execution IAM role      |
