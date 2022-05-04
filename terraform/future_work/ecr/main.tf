resource "aws_ecr_repository" "main" {
  name                 = "techchallenge-${var.environment}"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
}

resource "aws_ecr_lifecycle_policy" "main" {
  repository = aws_ecr_repository.main.name

  policy = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "keep last 10 images"
      action       = {
        type = "expire"
      }
      selection     = {
        tagStatus   = "any"
        countType   = "imageCountMoreThan"
        countNumber = 10
      }
    }]
  })
}

data "aws_caller_identity" "current" {}

variable "source_path" {
  description = "source path for terraform"
  default     = "../"
}

# to push latest docker image into ECR
resource "null_resource" "push" {
  provisioner "local-exec" {
    command     = "./${coalesce("push.sh", "${path.module}/push.sh")} ${var.source_path} ${aws_ecr_repository.main.repository_url} ${var.tag} ${data.aws_caller_identity.current.account_id}"
    interpreter = ["bash", "-c"]
  }
}

output "aws_ecr_repository_url" {
    value = aws_ecr_repository.main.repository_url
}

