variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "ecs_lb_security_group_id" {
  description = "ECS ALB security group ID to allow inbound access from the LB only to Task"
  type        = string
}

variable "custom_task_policy_document" {
  description = <<-EOT
    Custom IAM policy document for ECS Task to attach instead of policy document defined in this module
    Use `aws_iam_policy_document` data block to generate JSON"
  EOT
  type        = string
  default     = null
}

variable "custom_task_execution_policy_document" {
  description = <<-EOT
    Custom IAM policy document for ECS Task Execution to attach instead of policy document defined in this module
    Use `aws_iam_policy_document` data block to generate JSON"
  EOT
  type        = string
  default     = null
}

#----
#TASK DEFENITION
#----

variable "task_cpu" {
  description = "Task CPU size. example: 256 or 512 or 1024 or ..."
  type        = number
}

variable "task_memory" {
  description = "Task memory. example: 512 or 1024 or ..."
  type        = number
}

variable "container_definitions" {
  description = "json Container Definition"
}

variable "additional_ecs_task_iam_permisssions" {
  description = "List of additional IAM permissions to attach to ECS Task IAM role"
  type        = list(string)
  default     = []
}

variable "additional_ecs_task_execution_iam_permisssions" {
  description = "List of additional IAM permissions to attach to ECS Task Execution IAM role"
  type        = list(string)
  default     = []
}

#-----
#SERVICE
#-----

variable "ecs_service_name" {
  description = "Name the ECS Service"
  type        = string
}

variable "cluster_id" {
  description = "ECS cluster ID"
  type        = string
}

variable "ecs_task_desired_count" {
  description = "Number of ECS Task to run. Default = 1"
  default     = 1
}

variable "ignore_task_definition_change" {
  description = "Whether to ignore updating ECS Service when new Task Definition is created through Terraform"
  type        = bool
  default     = false
}

variable "lb_target_group_arn" {
  description = "ARN of ALB Target Group"
  type        = string
}

variable "subnets" {
  description = "Subnets to associate with Task & Service"
  type        = list(string)
}

variable "container_port" {
  description = <<-EOF
  "Container Port to associate with LB, and port mapping in Container Definition.
  Port mappings allow containers to access ports on the host container instance to send or receive traffic."
  EOF
  type        = number
}

variable "container_name" {
  description = "Name of the container to associate with the load balancer (as it appears in a container definition)."
  type        = string
}

variable "capacity_provider_strategies" {
  type = list(object({
    capacity_provider = string
    weight            = number
    base              = number
  }))

  description = <<EOF
  "List of ECS Service Capacity Provider Strategies.
    example: [{
        capacity_provider = "FARGATE_SPOT"
        weight            = 100
        base              = 1
        },]"
    EOF

  default = [{
    capacity_provider = "FARGATE_SPOT"
    weight            = 100
    base              = 1
  }]
}

variable "ecs_exec_enabled" {
  description = <<-EOF
    Specifies whether to enable Amazon ECS Exec for the tasks within the service.
    Adds required SSM permission to Task IAM Role. Default = true.
   EOF
  type        = bool
  default     = true
}
