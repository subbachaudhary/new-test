module "s3" {
    source                  = "./modules/s3"
}
module "vpc" {
  source                     = "./modules/vpc"
  vpc_cidr                   = var.vpc_cidr
  env                        = var.env
  project_name               = var.project_name
  public_subnet_cidr_blocks  = var.public_subnet_cidr_blocks
  private_subnet_cidr_blocks = var.private_subnet_cidr_blocks
  availability_zones         = var.availability_zones
  region                     = var.region
}
module "security_group" {
  source       = "./modules/security_group"
  env          = var.env
  project_name = var.project_name
  vpc_id       = module.vpc.vpc_id
  depends_on = [
    module.vpc
  ]
}
module "rancher-master" {
  source       = "./modules/rancher-master"
  env          = var.env
  project_name = var.project_name
  subnet_id = module.vpc.private_subnet_list[1]
  depends_on = [ 
    module.vpc
  ]
}
module "rancher-slave" {
  source       = "./modules/rancher-slave"
  env          = var.env
  project_name = var.project_name
  subnet_id = module.vpc.private_subnet_list[2]
  depends_on = [ 
    module.vpc
  ]
}
module "jenkins-ec2" {
  source       = "./modules/jenkins-ec2"
  env          = var.env
  project_name = var.project_name
  subnet_id = module.vpc.private_subnet_list[0]
  depends_on = [ 
    module.vpc
  ]
}
module "bastion-host" {
  source       = "./modules/bastion-host"
  env          = var.env
  project_name = var.project_name
  key_name = var.key_name
  subnet_id = module.vpc.public_subnet_list[0]
  depends_on = [ 
    module.vpc
  ]
}
module "database" {
  source                 = "./modules/database"
  env                    = var.env
  project_name           = var.project_name
  db_password            = var.db_password
  aws_db_subnet_group_id = module.vpc.rds_subnet_group_id
  rds_sg_id              = module.security_group.rds_sg_id
  depends_on = [
    module.vpc
  ]
}
module "certificates" {
  source                    = "./modules/certificates"
  env                       = var.env
  project_name              = var.project_name
  domain_name               = var.domain_name
  zone_name                 = var.zone_name
  subject_alternative_names = var.subject_alternative_names
}
module "load_balancer" {
  source                    = "./modules/load_balancer"
  env                       = var.env
  project_name              = var.project_name
  public_subnet_cidr_blocks = module.vpc.public_subnet_list
  vpc_id                    = module.vpc.vpc_id
  alb_sg                    = module.security_group.alb_sg
  certificate_arn           = module.certificates.certificate_arn

  depends_on = [
    module.security_group,
    module.vpc,
    module.certificates
  ]
}

module "route53" {
  source              = "./modules/route53"
  route53_zone_id     = module.certificates.route53_zone_id
  route53_name        = module.certificates.route53_name
  shared_alb_zone_id  = module.load_balancer.shared_alb_zone_id
  shared_alb_dns_name = module.load_balancer.shared_alb_dns_name
  api_domain          = var.api_domain
  depends_on = [
    module.load_balancer,
    module.vpc,
    module.security_group,
    module.certificates,
  ]
}


