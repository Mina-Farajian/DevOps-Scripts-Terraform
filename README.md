### Terraform AWS Infrastructure as Code (IaC) Project
Overview
provider AWS
version ~>4.0

##Structure
The repository is structured as follows:


* modules- Contains the Terraform modules that can be reused across the repository
* main file - you can call each module in main tf file or use each module independently

## Prerequisites
Before you begin, ensure that you have the following prerequisites installed on your system:

Terraform
AWS CLI
AWS IAM credentials with appropriate permissions
## Usage
1- Clone this repository to your local machine.
2- Change into the project directory:
```
cd in project main directory
```
3- Create a terraform.tfvars file to set your AWS access and secret keys, or use environment variables.

4- Initialize Terraform and download the required providers:
```
terraform init
```
5-Review and customize the variables in the module  files as needed, such as VPC settings, RDS configurations, and EC2 instance specifications.

6- Plan the changes:
```
terraform plan
```
7- Apply the configuration:
```
terraform apply
```
Happy Terraforming! 🚀
