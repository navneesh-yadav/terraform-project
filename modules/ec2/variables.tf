variable "ami_id" {
  description = "The Amazon Machine Image ID"
  type        = string
  default     = "ami-0eb38b817b93460ac" # standard Amazon Linux AMI
}

variable "instance_type" {
  description = "The size of the server"
  type        = string
  default     = "t2.micro" # Free-tier eligible
}

variable "subnet_id" {
  description = "The ID of the subnet to place the EC2 instance in"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC for the Security Group"
  type        = string
}

variable "environment" {
  description = "The environment name"
  type        = string
}
