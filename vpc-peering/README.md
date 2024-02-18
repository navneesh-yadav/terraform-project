# AWS VPC Peering Setup with Terraform

This Terraform configuration automates the setup of an AWS infrastructure, including VPCs, subnets, internet gateways, VPC peering connections, route tables, security groups, and EC2 instances.

## Overview

Yes, in the provided Terraform configuration, access to SSH from a public subnet instance to a private subnet instance is facilitated through Security Group rules.

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


## How It Works

1. **Security Group `sgp-2`**:
   - In the configuration, `sgp-2` is associated with the EC2 instance (`ec2-test-vpc-2`) launched in the private subnet (`test-vpc-2-subnet`).
   - `sgp-2` allows inbound traffic on port 22 (SSH) from the specific CIDR block `10.0.1.0/24`, which corresponds to the CIDR block of the subnet `test-vpc-1-subnet`. This allows SSH access from instances within the `test-vpc-1-subnet` to instances associated with `sgp-2`.

2. **EC2 Instance `ec2-test-vpc-1`**:
   - This instance is launched in the public subnet (`test-vpc-1-subnet`), which has an internet gateway attached, allowing it to communicate with the internet.
   - Since `ec2-test-vpc-1` is in the public subnet and has an associated public IP address due to `associate_public_ip_address` being set to `true`, it can initiate outbound SSH connections to the private subnet instance (`ec2-test-vpc-2`) via its private IP address.

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

