variable "autoscaling_group_name" {
  description = "Name of the Auto Scaling group"
  type        = string
  validation {
    condition     = length(var.autoscaling_group_name) > 0
    error_message = "autoscaling_group_name must not be empty."
  }
}

variable "policy_type" {
  description = "Policy type (SimpleScaling, StepScaling, TargetTrackingScaling)"
  type        = string
  default     = "TargetTrackingScaling"
  validation {
    condition     = contains(["SimpleScaling", "StepScaling", "TargetTrackingScaling"], var.policy_type)
    error_message = "policy_type must be SimpleScaling, StepScaling, or TargetTrackingScaling."
  }
}

variable "adjustment_type" {
  description = "Adjustment type for simple/step scaling"
  type        = string
  default     = null
}

variable "scaling_adjustment" {
  description = "Number of instances to scale by"
  type        = number
  default     = null
}

variable "cooldown" {
  description = "Cooldown period in seconds"
  type        = number
  default     = null
}

variable "predefined_metric_type" {
  description = "Predefined metric (ASGAverageCPUUtilization, ALBRequestCountPerTarget, etc.)"
  type        = string
  default     = "ASGAverageCPUUtilization"
}

variable "target_value" {
  description = "Target value for tracking metric"
  type        = number
  default     = 70
}
