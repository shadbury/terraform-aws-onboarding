data "archive_file" "zipit" {
  type        = "zip"
  source_file = "${path.module}/modules/ssm_patching_alerts/ssm_patching_alerts.py"
  output_path = "ssm_patching_alerts.zip"
}

data "aws_caller_identity" "current" {}