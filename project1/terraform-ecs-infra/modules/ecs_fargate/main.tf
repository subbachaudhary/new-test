# ServiceDiscovery CloudMap

resource "aws_service_discovery_private_dns_namespace" "service_namespace" {
  name        = "microservices.local"
  description = "CloudMap service discovery for microservices"
  vpc         = var.vpc_id
}

resource "aws_service_discovery_service" "service_discovery" {
  name = "${var.environment}-${var.services-ecs}"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.service_namespace.id

    dns_records {
      ttl  = 10
      type = "A"
    }

    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {
    failure_threshold = 5
  }
}

resource "aws_ecs_cluster" "ecs-fargate" {
  name = "${var.environment}-${var.ecs_cluster_name}"
#   capacity_providers = [
#     "FARGATE"]
  setting {
    name = "containerInsights"
    value = "enabled"
  }

  tags = {
    Name = "${var.environment}-ecs"
  }
}
resource "aws_ecs_cluster_capacity_providers" "capacity_provider_stage" {
  cluster_name = aws_ecs_cluster.ecs-fargate.name

  capacity_providers = ["FARGATE_SPOT","FARGATE"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE_SPOT"
  }
}

resource "aws_ecs_task_definition" "nginx-task" {
  family = "nginx-task"
  container_definitions = <<TASK_DEFINITION
  [
  {
    "portMappings": [
      {
        "hostPort": 80,
        "protocol": "tcp",
        "containerPort": 80
      }
    ],
    "cpu": ${var.nginx-cpu},
    "environment": [
      {
        "name": "AUTHOR",
        "value": "BhuwanDevOpsGuru"
      }
    ],
    "mountPoints": [
          {
              "containerPath": "/etc/nginx/conf.d",
              "sourceVolume": "${var.nginx-config}"
          }
      ],
    "memory": ${var.nginx-memory},
    "image": "893117704213.dkr.ecr.us-east-2.amazonaws.com/challenge-devops-ecs:latest",
    "essential": true,
    "stopTimeout": 120,
    "name": "gymapp-nginx",
    "logConfiguration": {
	  "logDriver": "awslogs",
	  "options": {
		  "awslogs-group": "/ecs/${var.environment}-${var.task_nginx}",
          "awslogs-region": "${var.aws_region}",
          "awslogs-stream-prefix": "ecs",
          "awslogs-create-group": "true"
	  }
	}
 
  }
]
TASK_DEFINITION

  network_mode = "awsvpc"
  requires_compatibilities = [
    "FARGATE"]
  memory = "1024"
  cpu = "512"
  execution_role_arn = aws_iam_role.ecs_service.arn
  task_role_arn = aws_iam_role.ecs_service.arn
  dynamic "volume" {
    for_each = var.efs_volumes
    content {
      name = volume.key
      efs_volume_configuration {
        file_system_id     = var.file_system_id
        root_directory     = volume.value
        transit_encryption = "ENABLED"
      }
    }
  }

  tags = {
    Name = "${var.environment}-nginx"
  }
}


#### Nginx ECS Services

resource "aws_ecs_service" "service-nginx-fargate" {
  depends_on = [
    aws_service_discovery_service.service_discovery
  ]
  name = var.svc_name
  cluster = aws_ecs_cluster.ecs-fargate.id
  task_definition = aws_ecs_task_definition.nginx-task.arn
  desired_count = "${var.app_desired_count}"
  # launch_type = "FARGATE"
  platform_version = "1.4.0"

  lifecycle {
    ignore_changes = [
      desired_count]
  }
    capacity_provider_strategy {
    capacity_provider = "${var.capacity_provider1}"
    weight = 1
    base = 2
   
  }
  capacity_provider_strategy {
    capacity_provider ="${var.capacity_provider2}"
    weight = 2
  }
  network_configuration {
    security_groups    = var.security_groups_ecs
    # security_groups    = [data.terraform_remote_state.vpc.outputs.nginx_sg]
    subnets            = var.private_subnets_ecs
    assign_public_ip   = false
  }

  load_balancer {
    target_group_arn = var.target_group_ecs
    container_name = var.container_name
    container_port = var.container_port
  }
  
  deployment_circuit_breaker {
      enable   = true
      rollback = true
  }
}

### Autoscaling 
locals {
  autoscaling_policy = {
    "policy1" = {
      name = "ecs-memory-policy",
      type = "TargetTrackingScaling",
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
      target_value = "${var.target_value_memory}" 
    },
    "policy2" = {
      name = "ecs-cpu-policy",
      type = "TargetTrackingScaling",
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
      target_value = "${var.target_value_cpu}"
    }
  }
}
resource "aws_appautoscaling_target" "ecs_target" {
  depends_on = [
    aws_ecs_service.service-nginx-fargate
  ]
  max_capacity = "${var.max_capacity}"
  min_capacity = "${var.min_capacity}"
  resource_id = "service/${aws_ecs_cluster.ecs-fargate.name}/${var.svc_name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace = "ecs"
}

resource "aws_appautoscaling_policy" "ecs_scaling1" {
  for_each = local.autoscaling_policy
  name               = each.value.name
  policy_type        = each.value.type
  resource_id        = "service/${aws_ecs_cluster.ecs-fargate.name}/${var.svc_name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = each.value.predefined_metric_type
    }

    target_value       = each.value.target_value
  }
}