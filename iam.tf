#------
#TASK IAM
#------

data "aws_iam_policy_document" "ecs_task_assume" {
  version = "2012-10-17"
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"

      identifiers = [
        "ecs.amazonaws.com",
        "ecs-tasks.amazonaws.com"
      ]
    }
  }
}

data "aws_iam_policy_document" "task_policy" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    actions = compact(concat([
      "autoscaling:Describe*",
      "cloudwatch:*",
      "logs:*",
      "sns:*",
      "iam:GetPolicy",
      "iam:GetPolicyVersion",
      "iam:GetRole",
    ], var.additional_ecs_task_iam_permisssions))

    resources = ["*"]
  }

  dynamic "statement" {
    for_each = var.ecs_exec_enabled ? ["true"] : []
    content {
      sid    = "AllowSSMaccessToDoECSEXEC"
      effect = "Allow"

      actions = [
        "ssmmessages:CreateControlChannel",
        "ssmmessages:CreateDataChannel",
        "ssmmessages:OpenControlChannel",
        "ssmmessages:OpenDataChannel"
      ]

      resources = ["*"]
    }
  }
}

resource "aws_iam_role" "task_role" {
  name               = "${module.this.id}-ecsTaskRole"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume.json

  tags = merge(
    module.this.tags,
    {
      Name = "${module.this.id}-ecsTaskRole"
    }
  )
}

resource "aws_iam_policy" "task_policy" {
  name   = "${module.this.id}-ecs-task-policy"
  policy = data.aws_iam_policy_document.task_policy.json

  tags = merge(
    module.this.tags,
    {
      Name = "${module.this.id}-ecs-task-policy"
    }
  )
}

resource "aws_iam_policy_attachment" "task_policy_attachment" {
  name       = "${module.this.id}-ecs-task-policy-attachment"
  roles      = [aws_iam_role.task_role.name]
  policy_arn = aws_iam_policy.task_policy.arn
}


#------
#TAST EXECUTION IAM
#------


data "aws_iam_policy_document" "task_execution_policy" {
  version = "2012-10-17"
  statement {
    effect = "Allow"

    actions = compact(concat([
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ], var.additional_ecs_task_execution_iam_permisssions))

    resources = ["*"]
  }
}


resource "aws_iam_role" "task_execution_role" {
  name               = "${module.this.id}-ecsTaskExecutionRole"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume.json

  tags = merge(
    module.this.tags,
    {
      Name = "${module.this.id}-ecsTaskExecutionRole"
    }
  )
}

resource "aws_iam_policy" "task_execution_policy" {
  name   = "${module.this.id}-ecs-task-execution-policy"
  policy = data.aws_iam_policy_document.task_execution_policy.json

  tags = merge(
    module.this.tags,
    {
      Name = "${module.this.id}-ecs-task-execution-policy"
    }
  )
}

resource "aws_iam_policy_attachment" "task_execution_policy_attachment" {
  name       = "${module.this.id}-ecs-task-execution-policy-attachment"
  roles      = [aws_iam_role.task_execution_role.name]
  policy_arn = aws_iam_policy.task_execution_policy.arn
}

