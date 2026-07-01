# Unit Tests for tf-atom-autoscaling-policy-aws
#
# These tests use a mock AWS provider — no real AWS calls are made.
# Run with:         terraform test -test-directory=tests/unit
# Run verbose:      terraform test -test-directory=tests/unit -verbose
# Run specific:     terraform test -test-directory=tests/unit -run "creates_when_enabled"
#
# NOTE: assertions target plan-KNOWN values only (tf-label id string, resource
# count, input pass-throughs). Computed attributes like `arn` are unknown under
# a mock provider and are therefore NOT asserted on.

mock_provider "aws" {}

variables {
  # tf-label context
  namespace = "eg"
  stage     = "test"
  name      = "thing"

  # module's own required input
  autoscaling_group_name = "eg-test-thing-asg"
}

# ---------------------------------------------------------------------------
# Test: module creates the scaling policy when enabled (default)
# ---------------------------------------------------------------------------
run "creates_when_enabled" {
  command = plan

  assert {
    condition     = length(aws_autoscaling_policy.this) == 1
    error_message = "Expected exactly one aws_autoscaling_policy when enabled."
  }

  assert {
    condition     = aws_autoscaling_policy.this[0].name == "eg-test-thing"
    error_message = "Scaling policy name should equal the tf-label id 'eg-test-thing'."
  }

  assert {
    condition     = aws_autoscaling_policy.this[0].autoscaling_group_name == "eg-test-thing-asg"
    error_message = "autoscaling_group_name input should pass through to the resource."
  }

  assert {
    condition     = output.enabled == true
    error_message = "enabled output should be true when the module is enabled."
  }
}

# ---------------------------------------------------------------------------
# Test: default policy_type wires target-tracking configuration
# ---------------------------------------------------------------------------
run "target_tracking_is_default" {
  command = plan

  assert {
    condition     = aws_autoscaling_policy.this[0].policy_type == "TargetTrackingScaling"
    error_message = "Default policy_type should be TargetTrackingScaling."
  }
}

# ---------------------------------------------------------------------------
# Test: disabled module creates nothing and null outputs
# ---------------------------------------------------------------------------
run "disabled_creates_nothing" {
  command = plan

  variables {
    enabled = false
  }

  assert {
    condition     = length(aws_autoscaling_policy.this) == 0
    error_message = "No aws_autoscaling_policy should be created when enabled = false."
  }

  assert {
    condition     = output.arn == null
    error_message = "arn output should be null when the module is disabled."
  }

  assert {
    condition     = output.enabled == false
    error_message = "enabled output should be false when enabled = false."
  }
}
