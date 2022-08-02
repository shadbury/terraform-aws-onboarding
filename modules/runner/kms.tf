resource "aws_kms_key" "key" {
  description             = "gitlab_runner"
  deletion_window_in_days = 10
}