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
> `custom_task_policy_document`
> `custom_task_execution_policy_document`

#### reason for change:

> Feature addition

#### info:

> Use `aws_iam_policy_document` data block to generate json

# v1.0.0

### Major

Initial release.
