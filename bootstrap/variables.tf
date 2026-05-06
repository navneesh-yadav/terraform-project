variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "github_org" {
  description = "Your GitHub username or organization name"
  type        = string
}

variable "github_repo" {
  description = "The name of your GitHub repository"
  type        = string
}
