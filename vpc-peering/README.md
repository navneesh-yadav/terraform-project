# AWS VPC Peering Setup with Terraform

This Terraform configuration automates the setup of an AWS infrastructure, including VPCs, subnets, internet gateways, VPC peering connections, route tables, security groups, and EC2 instances.

## Overview

This project uses Terraform to define and deploy AWS infrastructure components necessary for hosting applications and services in a cloud environment. The infrastructure is structured to provide isolation and secure communication between different environments.

## Architecture 

![vpc-peering](https://github.com/navneesh-yadav/terraform-project/assets/66907873/c51fd43b-0bab-4458-b13b-9846b53d8c3d)


### VPCs and Subnets

- **VPC 1 (`test-vpc-1`)**:
  - CIDR Block: `10.0.0.0/16`
  - Subnet: `10.0.1.0/24` in availability zone `ap-south-1a`
- **VPC 2 (`test-vpc-2`)**:
  - CIDR Block: `12.0.0.0/16`
  - Subnet: `12.0.1.0/24` in availability zone `ap-south-1b`

### Internet Gateway

- Attached to `test-vpc-1` for internet access.

### VPC Peering Connection

- Enables private communication between `test-vpc-1` and `test-vpc-2`.

### Route Tables

- **Route Table 1 (`rt-1`)**
  - Associated with `test-vpc-1`.
  - Routes traffic:
    - Locally within the VPC.
    - To the internet via the attached internet gateway.
    - To `test-vpc-2` via VPC peering connection.
- **Route Table 2 (`rt-2`)**
  - Associated with `test-vpc-2`.
  - Routes traffic to `test-vpc-1` via VPC peering connection.

### Security Groups

- **Security Group 1 (`sgp-1`)**:
  - Allows inbound traffic on port 80 (HTTP) and port 22 (SSH) from any source.
  - Allows all outbound traffic.
- **Security Group 2 (`sgp-2`)**:
  - Allows inbound traffic on port 80 (HTTP) from any source and port 22 (SSH) from `10.0.1.0/24` subnet.
  - Allows all outbound traffic.

### EC2 Instances

- **Instance 1 (`ec2-test-vpc-1`)**:
  - Launched in `test-vpc-1` subnet.
  - Security Group: `sgp-1`.
- **Instance 2 (`ec2-test-vpc-2`)**:
  - Launched in `test-vpc-2` subnet.
  - Security Group: `sgp-2`.

## Usage

1. Clone the repository.
2. Initialize Terraform: `terraform init`.
3. Plan the deployment: `terraform plan`.
4. Apply the configuration: `terraform apply`.
5. Review changes and confirm with `yes`.

## Files

- **main.tf**: Defines the AWS resources.
- **outputs.tf**: Defines output values.

## Contributing

Contributions are welcome! Feel free to open issues or submit pull requests.

