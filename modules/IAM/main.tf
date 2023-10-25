terraform {
  backend "s3" {
    bucket  = "your bucket name"
    key     = "terraform/prototyping"
    region  = "eu-west-1"
    encrypt = true
  }
}

locals {
  root_org_id    = "Account ID"
  dev_org_id     = "Account ID"
  prod_org_id    = "Account ID"
}
~ 
