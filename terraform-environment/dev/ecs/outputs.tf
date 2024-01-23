output "frontend_service_name" {
  value = aws_ecs_service.frontend_service.name
}

output "backend_service_name" {
  value = aws_ecs_service.backend_service.name
}

output "celery_service_name" {
  value = aws_ecs_service.celery_service.name
}

output "celery_beat_service_name" {
  value = aws_ecs_service.celery_beat_service.name
}

output "frontend_task_definition_arn" {
  value = aws_ecs_task_definition.frontend_task.arn
}

output "backend_task_definition_arn" {
  value = aws_ecs_task_definition.backend_task.arn
}

output "celery_task_definition_arn" {
  value = aws_ecs_task_definition.celery_task.arn
}

output "celery_beat_task_definition_arn" {
  value = aws_ecs_task_definition.celery_beat_task.arn
}
