resource "aws_budgets_budget" "budget" {
  name              = var.budget_name
  budget_type       = var.budget_type
  time_period_start = var.budget_time_period_start_default ? formatdate("YYYY-MM-DD_hh:mm", timestamp()) : var.budget_time_period_start
  limit_amount      = var.budget_limit
  limit_unit        = var.budget_unit
  time_unit         = var.budget_time_unit


  notification {
    comparison_operator        = var.budget_comparison_operator
    threshold                  = var.budget_threshold
    threshold_type             = var.budget_threshold_type
    notification_type          = var.budget_notification_type
    subscriber_email_addresses = var.budget_subscriber_email_addresses
  }
}