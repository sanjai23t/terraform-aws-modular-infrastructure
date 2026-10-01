#terraform main resources 
resource "aws_instance" "this" {
  ami           = var.ami_id
  instance_type = var.instance_type

  tags = {
    Name = "demo-ec2-instance"
  }
}

#vpc module
module "app_vpc" {
  source = "./modules/vpc"

  name = "app-vpc"

  vpc_cidr = "10.0.0.0/16"

  azs = [
    "ap-south-2a",
    "ap-south-2b"
  ]

  public_subnet_cidrs = [
    "10.0.1.0/24",
    "10.0.2.0/24"
  ]

  private_subnet_cidrs = [
    "10.0.11.0/24",
    "10.0.12.0/24"
  ]
}

module "shared_vpc" {
  source = "./modules/vpc"

  name = "shared-vpc"

  vpc_cidr = "10.1.0.0/16"

  azs = [
    "ap-south-2a",
    "ap-south-2b"
  ]

  public_subnet_cidrs = [
    "10.1.1.0/24",
    "10.1.2.0/24"
  ]

  private_subnet_cidrs = [
    "10.1.11.0/24",
    "10.1.12.0/24"
  ]
}

module "tools_vpc" {
  source = "./modules/vpc"

  name = "tools-vpc"

  vpc_cidr = "10.2.0.0/16"

  azs = [
    "ap-south-2a",
    "ap-south-2b"
  ]

  public_subnet_cidrs = [
    "10.2.1.0/24",
    "10.2.2.0/24"
  ]

  private_subnet_cidrs = [
    "10.2.11.0/24",
    "10.2.12.0/24"
  ]
}

#vpc peering module
module "vpc_peering" {
  source = "./modules/vpc-peering"

  name = "app-tools-peering"

  requester_vpc_id = module.app_vpc.vpc_id
  accepter_vpc_id  = module.tools_vpc.vpc_id

  requester_cidr = module.app_vpc.vpc_cidr
  accepter_cidr  = module.tools_vpc.vpc_cidr

  requester_route_table_ids = [
    module.app_vpc.public_route_table_id,
    module.app_vpc.private_route_table_id
  ]

  accepter_route_table_ids = [
    module.tools_vpc.public_route_table_id,
    module.tools_vpc.private_route_table_id
  ]
}

#transit gateway module
module "transit_gateway" {
  source = "./modules/transit-gateway"

  name = "main-tgw"

  requester_vpc_id = module.app_vpc.vpc_id
  accepter_vpc_id  = module.shared_vpc.vpc_id

  requester_subnet_ids = module.app_vpc.private_subnet_ids
  accepter_subnet_ids  = module.shared_vpc.private_subnet_ids

  requester_route_table_id = module.app_vpc.private_route_table_id
  accepter_route_table_id  = module.shared_vpc.private_route_table_id

  requester_cidr = module.app_vpc.vpc_cidr
  accepter_cidr  = module.shared_vpc.vpc_cidr
}

#iam module
module "iam" {
  source = "./modules/iam"

  role_name = "terraform-ec2-role"
}

#kms module
module "kms" {
  source = "./modules/kms"

  description = "Application encryption key"
  alias_name  = "terraform-app"
}

#ec2-module
module "ec2" {
  source = "./modules/ec2"

  ami_id                = var.ami_id
  instance_type         = "t3.micro"
  instance_name         = "standalone-ec2"

  vpc_id                = module.app_vpc.vpc_id
  subnet_id             = module.app_vpc.public_subnet_ids[0]

  admin_cidr            = var.admin_cidr

  instance_profile_name = module.iam.instance_profile_name
}

#target group module
module "target_group" {
  source = "./modules/target-group"

  name   = "app-target-group"
  vpc_id = module.app_vpc.vpc_id
}

#alb module
module "alb" {
  source = "./modules/alb"

  name = "app-alb"

  vpc_id = module.app_vpc.vpc_id

  public_subnet_ids = module.app_vpc.public_subnet_ids

  target_group_arn = module.target_group.target_group_arn
}

#launch template module 
module "launch_template" {
  source = "./modules/launch-template"

  name          = "app-launch-template"
  ami_id        = var.ami_id
  instance_type = "t3.micro"

  vpc_id = module.app_vpc.vpc_id

  alb_security_group_id = module.alb.security_group_id

  instance_profile_name = module.iam.instance_profile_name

  kms_key_arn = module.kms.key_arn
}

#asg module 
module "asg" {
  source = "./modules/asg"

  name = "app-asg"

  launch_template_id = module.launch_template.launch_template_id

  private_subnet_ids = module.app_vpc.private_subnet_ids

  target_group_arn = module.target_group.target_group_arn

  min_size         = 2
  desired_capacity = 2
  max_size         = 4
}

#rds module 
module "rds" {
  source = "./modules/rds"

  name = "app-database"

  vpc_id = module.app_vpc.vpc_id

  private_subnet_ids = module.app_vpc.private_subnet_ids

  application_security_group_id = module.launch_template.security_group_id

  kms_key_arn = module.kms.key_arn

  db_name = "appdb"
  username = "admin"

  instance_class = "db.t3.micro"
}

#efs module
module "efs" {
  source = "./modules/efs"

  name = "app-efs"

  vpc_id = module.app_vpc.vpc_id

  private_subnet_ids = module.app_vpc.private_subnet_ids

  application_security_group_id = module.launch_template.security_group_id

  kms_key_arn = module.kms.key_arn
}

#s3 module
module "s3" {
  source = "./modules/s3"

  bucket_name = var.bucket_name

  environment = "dev"

  kms_key_arn = module.kms.key_arn
}
