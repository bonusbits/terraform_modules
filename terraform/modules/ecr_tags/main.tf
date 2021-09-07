variable "repository_name" {
  description = "The ECR repository to query"
  type        = string
}

data "aws_region" "current" {}

data "external" "ecr_most_recent_tag" {
  program = [
    "aws", "ecr", "describe-images",
    "--repository-name", var.repository_name,
    "--region", data.aws_region.current.name,
    "--query", "{\"tag\": to_string(sort_by(imageDetails,& imagePushedAt)[-1].imageTags[0])}",
  ]
}

output "most_recent_tag" {
  description = ""
  value       = data.external.ecr_most_recent_tag.result.tag
}
