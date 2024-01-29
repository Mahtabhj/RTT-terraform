# Terraform Infrastructure as Code (IaC) Project for RTT

This project uses Terraform to define and deploy cloud infrastructure on AWS.

## Overview

The infrastructure includes the following components:
- Virtual Private Cloud (VPC)
- Subnets (Public and Private)
- Internet Gateway (IGW)
- NAT Gateway for Private Subnets
- Elastic Load Balancer (ALB)
- Amazon RDS (Relational Database Service) Instance
- Amazon S3 Bucket
- AWS Lambda Functions
- AWS API Gateway
- AWS ECS (Elastic Container Service) with Fargate Launch Type

## Prerequisites

Before running Terraform, make sure you have the following installed and configured:
- [Terraform](https://www.terraform.io/downloads.html)
- AWS CLI with configured credentials
Certainly! Below is a description of the architecture breakdown for your Terraform project:

## Project Architecture Breakdown

### Virtual Private Cloud (VPC)

The project establishes a Virtual Private Cloud (VPC) on AWS to isolate and organize the cloud resources. The VPC spans multiple Availability Zones for high availability and consists of public and private subnets.

### Subnets

The VPC includes both public and private subnets. Public subnets are designed for resources that require direct internet access, such as the Elastic Load Balancer (ALB), while private subnets house resources that should remain private, like the Amazon RDS instance and AWS ECS services.

### Internet Gateway (IGW)

An Internet Gateway (IGW) is attached to the VPC, enabling communication between instances in the VPC and the internet. This is essential for resources in public subnets to access external services.

### NAT Gateway

To allow resources in private subnets to initiate outbound connections to the internet, a Network Address Translation (NAT) Gateway is deployed. It provides a controlled and secure way for private resources to access external services.

### Elastic Load Balancer (ALB)

The Elastic Load Balancer (ALB) is configured to distribute incoming traffic across multiple ECS services. It ensures high availability and fault tolerance for the application.

### Amazon RDS Instance

An Amazon RDS instance is provisioned to serve as the relational database for the application. It is placed in a private subnet to enhance security, and access is controlled through security groups.

### Amazon S3 Bucket

An Amazon S3 bucket is created to store and manage objects for the frontend and backend containers. Both containers use this common S3 bucket for data storage.

### AWS Lambda Functions

Several AWS Lambda functions are defined to enable serverless architecture. These functions are associated with an API Gateway and can be triggered by various events.

### AWS API Gateway

An AWS API Gateway is established to create RESTful APIs that connect to the Lambda functions. This provides a scalable and managed way to expose endpoints for the serverless functions.

### AWS ECS (Elastic Container Service) with Fargate Launch Type

The AWS ECS cluster uses the Fargate launch type for running containers without managing the underlying infrastructure. Different ECS services, including frontend, backend, celery, and celery-beat, are deployed with their respective tasks and configurations.

### Route Tables and Gateways

The project includes the configuration of route tables for efficient routing within the VPC. Internet and NAT gateways are used to control traffic flow.

### Load Balancer and Target Groups

The ALB is associated with target groups to distribute traffic among ECS service instances. This ensures a balanced and efficient allocation of requests.

### IAM Roles

Identity and Access Management (IAM) roles are defined to provide secure access to AWS services. These roles are associated with ECS tasks, Lambda functions, and other components to grant necessary permissions.

This architecture breakdown illustrates the thoughtful design and configuration of AWS resources using Terraform, allowing for a scalable, secure, and maintainable cloud infrastructure for your application.

## Usage

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd <repository-directory>
   ```

2. Initialize Terraform:
   ```bash
   terraform init
   ```

3. Review and modify variables in `terraform.tfvars` as needed.

4. Apply the Terraform configuration:
   ```bash
   terraform apply
   ```

5. Confirm the changes by typing `yes` when prompted.

## Cleanup

To destroy the created infrastructure:

```bash
terraform destroy
```

Enter `yes` when prompted.

## Contributing

Contributions are welcome! Please open an issue or submit a pull request.
