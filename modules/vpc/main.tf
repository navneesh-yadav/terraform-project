# This creates the VPC network
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  # ENTERPRISE STANDARD: Meaningful tagging
  tags = {
    Name        = "${var.project_name}-${var.environment}-vpc"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# This creates a single subnet inside the VPC
resource "aws_subnet" "primary" {
  vpc_id     = aws_vpc.main.id
  cidr_block = cidrsubnet(var.vpc_cidr, 8, 1) # Automatically calculates a sub-network

  tags = {
    Name        = "${var.project_name}-${var.environment}-subnet-primary"
    Environment = var.environment
  }
}
