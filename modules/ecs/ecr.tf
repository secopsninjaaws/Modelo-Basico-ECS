resource "aws_ecr_repository" "main" {
  name = "${var.service_name}-ecr-repo"

  image_scanning_configuration {
    scan_on_push = true
  }
  force_delete = true
}
