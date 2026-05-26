output "enabled" {
  description = "Whether the module is enabled"
  value       = local.enabled
}

output "arn" {
  description = "ARN of the scaling policy"
  value       = try(aws_autoscaling_policy.this[0].arn, null)
}

output "name" {
  description = "Name of the scaling policy"
  value       = try(aws_autoscaling_policy.this[0].name, null)
}
