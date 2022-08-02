variable "monitoring_role_name" {
    description = "name for monitoring role"
    default     = "Monitoring_Role"
    type        = string
}

variable "root_monitoring_account" {
    description = "Account ID that contains the role that will be used to assume role into the monitoring role"
    type        = string
    default     = null
}

variable "root_monitoring_role_name" {
    description = "Name of the role that will be assuming into the monitoring role"
    type        = string
    default     = null
}