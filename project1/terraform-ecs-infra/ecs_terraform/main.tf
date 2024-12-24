module "vpc" {
    source = "../modules/vpc"
    environment = var.environment 
    cidr = var.cidr 
    igw_tag = var.igw_tag
    vpc_name = var.vpc_name
    enable_dns_support = var.enable_dns_support
    enable_dns_hostnames = var.enable_dns_hostnames
    public_subnets_cidr = var.public_subnets_cidr
    private_subnets_cidr = var.private_subnets_cidr
    availability_zones = var.availability_zones

}
module "ec2" {
    source = "../modules/ec2"
    instance_ami = var.instance_ami
    instance_type = var.instance_type
    key_name = var.key_name
    public_subnet = module.vpc.public_subnet
    security_groups = [module.security_group.remote_sg]
    volume_size = var.volume_size
    environment = var.environment
    security_groups_efs = [module.security_group.efs_sg]
    private_subnets = module.vpc.private_subnets
    pre_assign_privateip = var.pre_assign_privateip
    private_key_path = var.private_key_path
    depends_on = [module.security_group]
}

module "security_group" {
    source = "../modules/security_group"
    vpc_id = module.vpc.vpc_name
    backend_alb_sg = var.backend_alb_sg
    nginx_sg_ecs = var.nginx_sg_ecs
    remote_sg = var.remote_sg
    environment = var.environment
    depends_on = [module.vpc]
}

module "alb" {
    source = "../modules/alb"
    alb_name = var.alb_name
    target_type = var.target_type
    targetgroup_name = var.targetgroup_name
    bucket_name = var.bucket_name
    acm_arn = var.acm_arn
    environment = var.environment
    security_groups_alb = [module.security_group.backend_alb_sg]
    public_subnets_alb = module.vpc.public_subnets
    vpc_id = module.vpc.vpc_name
    depends_on = [module.vpc,module.security_group]

}

module "ecs" {
    source = "../modules/ecs_fargate"
    services-ecs = var.services-ecs
    ecs_cluster_name = var.ecs_cluster_name
    task_nginx = var.task_nginx
    svc_name = var.svc_name
    nginx-config = var.nginx-config 
    nginx-html = var.nginx-html 
    app_desired_count = var.app_desired_count 
    capacity_provider1 = var.capacity_provider1 
    capacity_provider2 = var.capacity_provider2 
    container_name = var.container_name 
    container_port = var.container_port 
    target_value_cpu = var.target_value_cpu 
    target_value_memory = var.target_value_memory 
    max_capacity = var.max_capacity 
    min_capacity = var.min_capacity 
    nginx-memory = var.nginx-memory 
    nginx-cpu = var.nginx-cpu 
    efs_volumes = var.efs_volumes
    file_system_id = module.ec2.efs_id
    target_group_ecs = module.alb.alb_target_group_arn
    alb_arn = module.alb.alb_arn
    vpc_id = module.vpc.vpc_name
    environment = var.environment
    aws_region = var.aws_region
    security_groups_ecs = [module.security_group.nginx_sg]
    private_subnets_ecs = module.vpc.private_subnets
    depends_on = [module.alb]

}