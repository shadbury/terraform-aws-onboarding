variable "budget_comparison_operator" {
    type        = string
    description = "comparison_operator for budgets"
    default     = "GREATER_THAN"
}

variable "budget_threshold" {
    type        = number
    description = "Alert Threshold for budgets"
    default     = 100
}

variable "budget_threshold_type" {
    type        = string
    description = "Threshold type for budget"
    default     = "PERCENTAGE"
}

variable "budget_notification_type" {
    type        = string
    description = "Notification type for budget"
    default     = "FORECASTED"
}

variable "budget_subscriber_email_addresses" {
    type        = list(string)
    description = "Email for notifications"
    default     = ["managedservices@cmd.com.au"]
}

variable "budget_unit" {
    type        = string
    description = "unit for budget"
    default     = "USD"
}

variable "budget_time_unit" {
    type        = string
    description = "Time unit for budger"
    default     = "MONTHLY"
}


variable "budget_time_period_start_default" {
    type        = bool
    description = "default start time period"
    default     = true
}

variable "budget_time_period_start" {
    type        = string
    description = "Start time period for AWS Budgets"
    default     = null
}

variable "budget_limit" {
    type        = number
    description = "limit for budgets"
    default     = 10000
}

variable "budget_name" {
    type        = string
    description = "name for budget"
    default     = "AWS_BUDGET"
}

variable "budget_type" {
    type        = string
    description = "budget type"
    default     = "COST"
}