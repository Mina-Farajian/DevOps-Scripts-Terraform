module "mina_ec2" {
  source = "./modules/EC2"
  name   = "mina-ec2"
  count  = 3
  tags = {
    Name       = local.Name
    Created_By = local.created_by
  }
  instance_type = "t2.micro"
}

module "mina_s3" {
  source = "./modules/S3"
  name   = "s3-storage"
}

module "mina_rds" {
  source = "./modules/RDS"
  name   = "rds-mina"
}

module "mina_efs" {
  source = "./modules/EFS"
  name   = "efs-mina"
}

module "mina_lba" {
  source = "./modules/load-balancer-App"
  name   = "lba-mina"
}

module "mina_ecr_repo" {
  source = "./modules/ECR"
  name   = "mina-front"
  tags   = local.tags
}

