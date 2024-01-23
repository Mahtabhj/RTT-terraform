# ecs.tf

resource "aws_ecs_cluster" "my_cluster" {
  name = "my-cluster"
}

resource "aws_ecr_repository" "frontend_repo" {
  name = "frontend-repo"
}

resource "aws_ecr_repository" "backend_repo" {
  name = "backend-repo"
}

resource "aws_ecr_repository" "celery_repo" {
  name = "celery-repo"
}

resource "aws_ecr_repository" "celery_beat_repo" {
  name = "celery-beat-repo"
}

resource "aws_ecs_task_definition" "frontend_task" {
  network_mode = "awsvpc"
  family       = "frontend-task"
  container_definitions = jsonencode([{
    name  = "frontend-container"
    image = aws_ecr_repository.frontend_repo.repository_url
    portMappings = [{
      containerPort = 80,
      hostPort      = 80
    }],
    environment = [
      { name = "S3_BUCKET_NAME", value = aws_s3_bucket.my_s3_bucket.bucket },
    ]
  }])

  requires_compatibilities = [
    "FARGATE",
  ]
}

resource "aws_ecs_task_definition" "backend_task" {
  network_mode = "awsvpc"
  family       = "backend-task"
  container_definitions = jsonencode([{
    name  = "backend-container"
    image = aws_ecr_repository.backend_repo.repository_url
    portMappings = [{
      containerPort = 8080,
      hostPort      = 8080
    }],
    environment = [
      { name = "S3_BUCKET_NAME", value = aws_s3_bucket.my_s3_bucket.bucket },
    ]
  }])

  requires_compatibilities = [
    "FARGATE",
  ]
}

resource "aws_ecs_task_definition" "celery_task" {
  network_mode = "awsvpc"
  family       = "celery-task"
  container_definitions = jsonencode([{
    name  = "celery-container"
    image = aws_ecr_repository.celery_repo.repository_url
    environment = [
      { name = "POSTGRES_HOST", value = aws_db_instance.my_rds.address },
      { name = "POSTGRES_USER", value = aws_db_instance.my_rds.username },
      { name = "POSTGRES_PASSWORD", value = aws_db_instance.my_rds.password },
      { name = "POSTGRES_DB", value = "your_database_name" },
    ]
  }])

  requires_compatibilities = [
    "FARGATE",
  ]
}

resource "aws_ecs_task_definition" "celery_beat_task" {
  network_mode = "awsvpc"
  family       = "celery-beat-task"
  container_definitions = jsonencode([{
    name  = "celery-beat-container"
    image = aws_ecr_repository.celery_beat_repo.repository_url
    environment = [
      { name = "POSTGRES_HOST", value = aws_db_instance.my_rds.address },
      { name = "POSTGRES_USER", value = aws_db_instance.my_rds.username },
      { name = "POSTGRES_PASSWORD", value = aws_db_instance.my_rds.password },
      { name = "POSTGRES_DB", value = "your_database_name" },
    ]
  }])

  requires_compatibilities = [
    "FARGATE",
  ]
}

resource "aws_ecs_service" "frontend_service" {
  task_definition = aws_ecs_task_definition.frontend_task.arn
  name            = "frontend-service"
  launch_type     = "FARGATE"
  desired_count   = 2
  cluster         = aws_ecs_cluster.my_cluster.id

  network_configuration {
    subnets = aws_subnet.public_subnet[*].id
  }
}

resource "aws_ecs_service" "backend_service" {
  task_definition      = aws_ecs_task_definition.backend_task.arn
  name                 = "backend-service"
  launch_type          = "FARGATE"
  iam_role             = aws_ecs_service.backend_service.name
  force_new_deployment = true
  desired_count        = 2
  cluster              = aws_ecs_cluster.my_cluster.id

  load_balancer {
    target_group_arn = aws_lb_target_group.backend_target_group.arn
    elb_name         = aws_lb.my_alb.name
    container_port   = 8000
    container_name   = aws_ecs_task_definition.backend_task.family
  }

  network_configuration {
    subnets = aws_subnet.private_subnet[*].id
  }
}

resource "aws_ecs_service" "celery_service" {
  task_definition = aws_ecs_task_definition.celery_task.arn
  name            = "celery-service"
  launch_type     = "FARGATE"
  desired_count   = 2
  cluster         = aws_ecs_cluster.my_cluster.id

  network_configuration {
    subnets = aws_subnet.private_subnet[*].id
  }
}

resource "aws_ecs_service" "celery_beat_service" {
  task_definition = aws_ecs_task_definition.celery_beat_task.arn
  name            = "celery-beat-service"
  launch_type     = "FARGATE"
  desired_count   = 1
  cluster         = aws_ecs_cluster.my_cluster.id

  network_configuration {
    subnets = aws_subnet.private_subnet[*].id
  }
}
