
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

#-----
#SERVICE
#-----

output "ecs_serivce_name" {
  description = "ECS service name"
  value       = local.ecs_service_name
}

#-----
#TASK IAM
#-----

output "task_iam_role_name" {
  description = "Name of the IAM role for ECS Task. Use to attach additional policies"
  value       = aws_iam_role.task_role.name
}

#-----
#TASK EXECUTION IAM
#-----

output "task_execution_iam_role_name" {
  description = "Name of the IAM role for ECS Task Execution. Use to attach additional policies"
  value       = aws_iam_role.task_execution_role.name
}
