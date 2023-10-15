### Terraform AWS Infrastructure as Code (IaC) Project
Overview
This Terraform project is designed to provision and manage AWS resources using Infrastructure as Code (IaC) principles. It organizes AWS resources into different modules, making it easy to deploy and maintain complex infrastructure.

## Project Structure
The project is structured into the following directories:

* main-module: This is the main module that defines the base AWS resources, such as VPC, subnets, and security groups. It serves as the foundation for other modules.

* ec2-instances: This module creates EC2 instances within the previously defined VPC and subnets. You can specify the number of instances, instance types, and other instance-specific configurations.

* rds-database: The RDS module provisions a managed Relational Database Service (RDS) instance. It allows you to set up database engines, instance types, and database options.

* s3-bucket: This module creates an Amazon S3 bucket. You can specify the bucket name, access control policies, and other S3-specific configurations.

* iam-roles: The IAM module defines Identity and Access Management (IAM) roles and policies for EC2 instances, allowing them to interact with other AWS services securely.

## Prerequisites
Before you begin, ensure that you have the following prerequisites installed on your system:

Terraform
AWS CLI
AWS IAM credentials with appropriate permissions
Usage
Clone this repository to your local machine.

Change into the project directory:
```
cd terraform-aws-iac-project
```
