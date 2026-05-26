resource "aws_autoscaling_policy" "this" {
  count = module.this.enabled ? 1 : 0

  name                   = module.this.id
  autoscaling_group_name = var.autoscaling_group_name
  policy_type            = var.policy_type
  adjustment_type        = var.adjustment_type
  scaling_adjustment     = var.scaling_adjustment
  cooldown               = var.cooldown

  dynamic "target_tracking_configuration" {
    for_each = var.policy_type == "TargetTrackingScaling" ? [1] : []
    content {
      predefined_metric_specification {
        predefined_metric_type = var.predefined_metric_type
      }
      target_value = var.target_value
    }
  }
}
