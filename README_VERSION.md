# v1.3.0

### Feature addition

#### what changed:

`service_connect_configuration` addition.

#### reason for change:

> Feature addition

#### info:

```
service_connect_configuration:

  type = object({
    enabled   = optional(bool)
    namespace = optional(string)
    services = optional(list(object({
      port_name             = string
      discovery_name        = optional(string)
      ingress_port_override = optional(number)
      client_alias_dns_name = optional(string)
      client_alias_port     = number
    })))
  })
  default = {}

```

# v1.2.0

### Feature addition

#### what changed:

`ssm:GetParameter*`, `ssm:DescribeParameters` premission added to ECS Task, and Task execution role.

#### reason for change:

> Permission requirement for Environment Variable from SSM parameter store

#### info:

# v1.1.0

### Feature

#### what changed:

Option to pass custom IAM policy document for ECS Task, and Task execution role.

> variables:
> `custom_task_policy_document` > `custom_task_execution_policy_document`

#### reason for change:

> Feature addition

#### info:

> Use `aws_iam_policy_document` data block to generate json

# v1.0.0

### Major

Initial release.
