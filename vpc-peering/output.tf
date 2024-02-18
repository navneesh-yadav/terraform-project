output "vpc_id_1" {
  description = "The ID of VPC 1"
  value       = aws_vpc.test-vpc-1.id
}

output "vpc_id_2" {
  description = "The ID of VPC 2"
  value       = aws_vpc.test-vpc-2.id
}

output "internet_gateway_id" {
  description = "The ID of the internet gateway attached to VPC 1"
  value       = aws_internet_gateway.igw-vpc-1.id
}

output "vpc_peering_connection_id" {
  description = "The ID of the VPC peering connection"
  value       = aws_vpc_peering_connection.vpc_peering.id
}

output "security_group_id_1" {
  description = "The ID of Security Group 1"
  value       = aws_security_group.sgp-1.id
}

output "security_group_id_2" {
  description = "The ID of Security Group 2"
  value       = aws_security_group.sgp-2.id
}

output "subnet_id_1" {
  description = "The ID of Subnet 1 in VPC 1"
  value       = aws_subnet.test-vpc-1-subnet.id
}

output "subnet_id_2" {
  description = "The ID of Subnet 2 in VPC 2"
  value       = aws_subnet.test-vpc-2-subnet.id
}

output "instance_id_1" {
  description = "The ID of Instance 1"
  value       = aws_instance.public_subnet_instances.id
}

output "instance_id_2" {
  description = "The ID of Instance 2"
  value       = aws_instance.instances.id
}
