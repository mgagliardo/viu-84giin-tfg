module "ecr" {
  source  = "terraform-aws-modules/ecr/aws"
  version = "~> 2.4.0"

  repository_type         = "private"
  repository_name         = var.service
  repository_force_delete	= true

  repository_read_write_access_arns = [aws_iam_role.ecs_task_execution_role.arn]
  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last 30 images",
        selection = {
          tagStatus     = "tagged",
          tagPrefixList = ["v"],
          countType     = "imageCountMoreThan",
          countNumber   = 30
        },
        action = {
          type = "expire"
        }
      }
    ]
  })

  tags = local.tags
}
