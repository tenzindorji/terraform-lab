module "aws_vpc" {
  source      = "../../modules/vpc"
  vpc_cidr    = var.vpc_cidr
  environment = var.environment
}


module "aws_subnet" {
  source      = "../../modules/subnet"
  vpc_id      = module.aws_vpc.vpc_id
  environment = "dev"
}

module "web-sg" {
  source      = "../../modules/sg"
  vpc_id      = module.aws_vpc.vpc_id
  environment = var.environment
}

module "ec2" {
  source        = "../../modules/ec2"
  web_sg_id     = module.web-sg.sg_id
  pub_subnet_id = module.aws_subnet.pub_subnet_ids[0]
}