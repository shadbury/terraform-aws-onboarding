locals {

  client = "test-client"
env = {

  #This is an example of the minimal reqired variables required to deploy onboarding resources into a clients account
  minimal = {
        aws_profile = "arrow-thirdparty-nonprod"
        region      = "ap-southeast-2"
    }

  # This is an example of all varibles that can be altered for the onboarding process
  maximum = {

    # account information
    aws_profile     = "arrow-thirdparty-nonprod"
    region          = "ap-southeast-2"

    # resources to deploy - default is true
    enable_patching           = true
    enable_budget             = true
    enable_patch_alerting     = true
    enable_backups            = true
    enable_grafana_monitoring = true

    # Patching

    patching_maintenance_windows                 = ["PROD-AZ-A", "PROD-AZ-B", "PROD-AZ-C"] # To set to be dynamic creation of patch groups by count and name
    default_patch_groups                         = true # this allows you to use the aws default patch groups without creating new ones if you dont need to customise settings of a group. Set to false to create your own list of baselines
    default_patch_scan                           = true # scan the default patch groups across all AZ's
    patching_schedule_windows                    = ["cron(0 18 ? * TUE *)", "cron(0 18 ? * WED *)", "cron(0 18 ? * THU *)"] # "when will each maintenance window be run on cron expression"
    patching_schedule_windows_scan               = "cron(0 16 ? * SUN *)" # when will scanner window be run on cron expression
    patching_install_maintenance_windows_targets = [] # instance ID's for manually selecting instances to patch
    patching_approved_patches_compliance_level   = "CRITICAL" # The list of systems for the SSM baseline
    patching_approved_patches                    = [] # The list of approved patches for the SSM baseline"
    patching_rejected_patches                    = [] # The list of rejected patches for the SSM baseline
    patching_custom_baselines                    = [] # create a list of custom baselines you want to use instead of the default ones.
    patching_operating_system                    = ["WINDOWS"] # which OS do you want to create a patch baseline for
    patching_reboot_option                       = "RebootIfNeeded" # Will reboot instances after update if required
    patching_task_install_priority               = 1
    patching_max_concurrency                     = 10
    patching_max_errors                          = 10

    # Backups

    backup_namespace = "aws" # environment name for backups
    backup_stage     = "backups" # stage for backups
    backup_name      = "AWS_BACKUPS" # Backup name
    backup_delimiter = "-" # Delimiter for seperation of name in backups for readability

    backup_schedule  = { # A CRON expression specifying when AWS Backup initiates a backup job and the retention period
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

    backup_resources = ["*"] # A list of resources to backup

    backup_selection_tags = [ # An array of tag condition objects used to filter resources based on tags for assigning to a backup plan
          {
            key   = "aws:ResourceTag/cmd:backup"
            value = "standard"
            }
        ]
    
    # Budgets

    budget_name                       = "AWS_BUDGET" # Name of budget
    budget_type                       = "COST" # Type of budget
    budget_comparison_operator        = "GREATER_THAN" # comparison_operator for budgets
    budget_threshold                  = 100 # Threshold for budget
    budget_threshold_type             = "PERCENTAGE" # The unit type for threshold comparison operator
    budget_notification_type          = "FORECASTED" # Notification type for budget
    budget_subscriber_email_addresses = ["managedservices@cmd.com.au"] # email/s to receive notifications
    budget_unit                       = "USD" # currency unit for budgets
    budget_time_unit                  = "MONTHLY" # Time comparitor for budgets
    budget_time_period_start_default  = false # default is set with timestamp()
    budget_time_period_start          = "2017-07-01_00:00" # start time for budget comparator
    budget_limit                      = 10000 # budget limit value

    # Patch Alerting

    patch_alerting_recepients = "managedservices@cmd.com.au" # email to receive patching alerts
    patch_alerting_sender     = "managedservices@cmd.com.au" # email that sends to alert
  }
}
  workspace = local.env[terraform.workspace]
}