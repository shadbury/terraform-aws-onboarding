# Resources to deploy

variable "enable_patching" {
    type        = bool
    description = "Setup Patching for client"
    default     = true
}

variable "enable_gitlab_runner" {
  type          = bool
  description   = "Setup gitlab runner"
  default       = true
}

variable "enable_budget" {
    type        = bool
    description = "Setup Patching for client"
    default     = true
}

variable "enable_patch_alerting" {
    type        = bool
    description = "setup alerting for patching"
    default     = true
}

variable "enable_backups" {
    type        = bool
    description = "enable AWS backups on account"
    default     = true
}

variable "enable_grafana_monitoring" {
    type        = bool
    description = "Deploy role for grafana monitoring"
    default     = true
}

# required profile

variable "profile" {
    type        = string
    description = "account id for the account to onboard"
}

variable "region" {
    type        = string
    description = "region of the account to onboard"
    default     = "ap-southeast-2"
}

#backups

variable "backup_name" {
    type        = string
    description = "name for backups"
    default     = "AWS_BACKUP"
}

variable "backup_namespace" {
    type        = string
    description = "environment name for backups"
    default     = "aws"
}

variable "backup_stage" {
    type        = string
    description = "stage for backups"
    default     = "backups"
}


variable "backup_delimiter" {
    type        = string
    description = "delimiter for backups"
    default     = "-"
}

variable "backup_schedule" {
  type        = map
  description = "A CRON expression specifying when AWS Backup initiates a backup job and the retention period"
  default     = {
          daily = {
            name = "daily"
            schedule     = "cron(0 15 * * ? *)"
            delete_after = 7
          }
          weekly = {
            name = "weekly"
            schedule = "cron(0 15 ? * 1 *)"
            delete_after = 30
          }
          monthly = {
            name = "monthly"
            schedule = "cron(0 15 1 * ? *)"
            delete_after = 365
          }
        }
}

variable "backup_resources" {
  type        = list(string)
  description = "An array of strings that either contain Amazon Resource Names (ARNs) or match patterns of resources to assign to a backup plan"
  default     = ["*"]
}


variable "backup_selection_tags" {
  type = list(object({
    key   = string
    value = string
  }))
  description = "An array of tag condition objects used to filter resources based on tags for assigning to a backup plan"
  default     = [
          {
            key   = "aws:ResourceTag/cmd:backup"
            value = "standard"
            }
        ]
}


# Patching



variable "patching_install_maintenance_windows_targets" {
  description = "The targets to register with the maintenance window. In other words, the instances to run commands on when the maintenance window runs. You can specify targets using instance IDs, resource group names, or tags that have been applied to instances. For more information about these examples formats see (https://docs.aws.amazon.com/systems-manager/latest/userguide/mw-cli-tutorial-targets-examples.html)"
  type = list(object({
    key : string
    values : list(string)
    }
    )
  )
  default = []
}

variable "approved_patches" {
  description = "The list of approved patches for the SSM baseline"
  type        = list(string)
  default     = []
}

variable "rejected_patches" {
  description = "The list of rejected patches for the SSM baseline"
  type        = list(string)
  default     = []
}

variable "custom_baselines" { // needed to create a new aws_ssm_patch_baseline
  description = "create a list of custom baselines you want to use instead of the default ones."
  type        = list(string)
  default     = []
}

variable "operating_system" { // needed to create new aws_ssm_patch_baseline and choose OS
  description = "which OS do you want to create a patch baseline for"
  type        = list(string)
  default     = ["*"]
}

variable "patching_maintenance_windows" {
  type        = list(string)
  description = "An array of strings that either contain Amazon Resource Names (ARNs) or match patterns of resources to assign to a backup plan"
  default     = ["PROD-AZ-A", "PROD-AZ-B", "PROD-AZ-C"]
}

variable "default_patch_groups" {
    type        = bool
    description = "use default patch groups"
    default     = true
}

variable "default_patch_scan" {
    type        = bool
    description = "enable patch scanning"
    default     = true
}

variable "patching_schedule_windows" {
  type        = list(string)
  description = "Cron for schedule windows"
  default     = ["cron(0 18 ? * TUE *)", "cron(0 18 ? * WED *)", "cron(0 18 ? * THU *)"]
}

variable "patching_schedule_windows_scan" {
  type        = string
  description = "Cron for scan"
  default     = "cron(0 16 ? * SUN *)" 
}

variable "patching_approved_patches_compliance_level" {
  type        = string
  description = "approved compliance level"
  default     = "CRITICAL"
}

variable "patching_reboot_option" {
  type        = string
  description = "reboot if required"
  default     = "RebootIfNeeded"
}

variable "patching_task_install_priority" {
  type        = number
  description = "Task priority for patcing"
  default     = 1
}

variable "patching_max_concurrency" {
  type        = number
  description = "abount of cuncurrent patching commands"
  default     = 10
}

variable "patching_max_errors" {
  type        = number
  description = "Max errors before function termination"
  default     = 10
}


# Patch Alertng

variable "patch_alerting_recepients" {
    type        = string
    description = "email to receive patching alerts"
    default     = "managedservices@cmd.com.au"
}

variable "patch_alerting_sender" {
    type        = string
    description = "email to send patching alerts"
    default     = "managedservices@cmd.com.au"
}

# Budgets

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

# Gitlab Runner

variable "gitlab_vpc_name" {
  type        = string
  description = "The name of the VPC to add the gitlab runner"
  default     = "mgmt"
}

variable "gitlab_url" {
  type        = string
  description = "URL of the gitlab runner"
  default     = "https://gitlab.runcmd.cmdsolutions.com.au/"
}

variable "gitlab_instance_type" {
  type        = string
  description = "Type of instance for gitlab runner"
  default     = "t3a.large"
}

variable "gitlab_concurrency" {
  type        = number
  description = "concurrency of gitlab runner"
  default     = 10
}

variable "gitlab_runner_domain" {
  type        = string
  description = "domain name for the gitlab runner"
  default     = "mgmt-int.runcmd.cmdsolutions.com.au"
}

variable "client" {
  type        = string
  description = "name of the client"
}

variable "gitlab_runner_use_private_subnet" {
  type        = bool
  description = "true or false to use private subnets"
  default     = true
}