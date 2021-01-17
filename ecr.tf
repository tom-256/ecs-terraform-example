resource "aws_ecr_repository" "main" {
  name                 = "tom-256/test-image"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
