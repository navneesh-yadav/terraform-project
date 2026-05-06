terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# -------------------------------------------------------------------------
# 1. S3 BUCKET FOR TERRAFORM STATE
# -------------------------------------------------------------------------
resource "aws_s3_bucket" "terraform_state" {
  # Bucket names must be globally unique. We add a random suffix later, 
  # or you can hardcode a unique name here. Let's make it simple for now:
  bucket        = "${var.github_org}-${var.github_repo}-tf-state-bucket"
  force_destroy = true # For portfolio cleanup. In Enterprise, this is ALWAYS false.
}

resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# -------------------------------------------------------------------------
# 2. DYNAMODB TABLE FOR STATE LOCKING
# -------------------------------------------------------------------------
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "${var.github_org}-${var.github_repo}-tf-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

# -------------------------------------------------------------------------
# 3. GITHUB OIDC PROVIDER & IAM ROLE
# -------------------------------------------------------------------------
resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  # GitHub's standard thumbprint
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"] 
}

data "aws_iam_policy_document" "github_actions_assume_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      # STRICT RESTRICTION: Only the main branch of your repo can assume this role
      values   = ["repo:${var.github_org}/${var.github_repo}:ref:refs/heads/main"]
    }
  }
}

resource "aws_iam_role" "github_actions_role" {
  name               = "github-actions-terraform-prod-role"
  assume_role_policy = data.aws_iam_policy_document.github_actions_assume_role.json
}

# NOTE: For this portfolio project, we are giving the role AdministratorAccess 
# so it can build VPCs, EC2s, etc. 
# ENTERPRISE CALLOUT: In a true production environment, you would scope this 
# policy down to ONLY the specific services Terraform needs to touch.
resource "aws_iam_role_policy_attachment" "github_actions_admin" {
  role       = aws_iam_role.github_actions_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# -------------------------------------------------------------------------
# OUTPUTS - We need these for the next phase!
# -------------------------------------------------------------------------
output "s3_bucket_name" {
  value = aws_s3_bucket.terraform_state.bucket
}

output "dynamodb_table_name" {
  value = aws_dynamodb_table.terraform_locks.name
}

output "github_actions_role_arn" {
  value = aws_iam_role.github_actions_role.arn
}
