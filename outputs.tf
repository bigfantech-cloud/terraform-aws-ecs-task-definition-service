
#-----
#TASK DEFINITION
#-----

output "task_definition_arn" {
  description = "ECS Task Definition ARN"
  value       = aws_ecs_task_definition.td.arn
}

output "task_security_group_id" {
  description = "ID of security group attached to ECS Task. Allows ingress from the LB only, egress all port"
  value       = aws_security_group.task_sg.id
}

output "ecs_serivce_name" {
  description = "ECS service name"
  value       = local.ecs_service_name
}

output "task_iam_role_arn" {
  description = "ECS Task IAM role ARN"
  value       = aws_iam_role.task_role.arn
}

output "task_execution_iam_role_arn" {
  description = "ECS Task Execution IAM role ARN"
  value       = aws_iam_role.task_execution_role.arn
}

output "task_iam_role_name" {
  description = "ECS Task IAM role name"
  value       = aws_iam_role.task_role.name
}

output "task_execution_iam_role_name" {
  description = "ECS Task Execution IAM role name"
  value       = aws_iam_role.task_execution_role.name
}
