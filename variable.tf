variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "lb_security_group_id" {
  description = "LB Security group ID to whitelist for inbound access to Service"
  type        = string
}

variable "custom_task_iam_policy_document" {
  description = "Custom IAM policy document for ECS Task to attach instead of policy document defined in this module"
  type        = string
  default     = null
}

variable "custom_task_iam_execution_policy_document" {
  description = "Custom IAM policy document for ECS Task Execution to attach instead of policy document defined in this module"
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
  description = "Whether to ignore updating ECS Service when new Task Definition is created through Terraform. If not ignored, always the later version of TD is used. Default = false"
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
  description = "Container Port to associate with LB"
  type        = number
}

variable "container_name" {
  description = "Name of the container to associate with the load balancer (as it appears in a container definition)."
  type        = string
}

variable "capacity_provider_strategies" {
  description = "List of ECS Service Capacity Provider Strategies"
  type = list(object({
    capacity_provider = string
    weight            = number
    base              = number
  }))

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

variable "service_connect_configuration" {
  description = "ECS Service Connect configuration"
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
}
