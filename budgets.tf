module "budgets" {
  count = var.enable_budget ? 1 : 0
  source = "./modules/budgets"

  budget_name                       = var.budget_name
  budget_type                       = var.budget_type
  budget_time_period_start          = var.budget_time_period_start_default ? timestamp() : var.budget_time_period_start
  budget_limit                      = var.budget_limit
  budget_unit                       = var.budget_unit
  budget_time_unit                  = var.budget_time_unit
  budget_comparison_operator        = var.budget_comparison_operator
  budget_threshold                  = var.budget_threshold
  budget_threshold_type             = var.budget_threshold_type
  budget_notification_type          = var.budget_notification_type
  budget_subscriber_email_addresses = var.budget_subscriber_email_addresses
}