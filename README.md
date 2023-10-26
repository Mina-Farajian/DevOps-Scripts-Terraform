### Terraform AWS Infrastructure as Code (IaC) Project
Overview
provider AWS
version ~>4.0

## Structure
The repository is structured as follows:


* modules- Contains the Terraform modules that can be reused across the repository
* main file - you can call each module in main.tf file or use each module independently

## Prerequisites
Before you begin, ensure that you have the following prerequisites installed on your system:

Terraform
AWS CLI
AWS IAM credentials with appropriate permissions
## Usage
1- Clone this repository to your local machine.
2- Change into the project directory:
```
cd in resource main directory
```
3- Create a terraform.tfvars file to set your AWS access and secret keys, or use environment variables or use locals.
   - you can call modules in main.tf 
   - if you want to use each module independently, you should customize it as a main terraform file.

4- Initialize Terraform and download the required providers:
```
* terraform init
* terraform plan
* terraform apply
```
Happy Terraforming! 🚀
