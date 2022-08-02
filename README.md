# AWS Onboarding terraform module

## Usage

```hcl
module "onboarding" {
  source  = "shadbury/onboarding/aws"
  version = "1.0.0"
  profile = "<aws profile name or ID>"
  region  = "<aws region>"
}
```

## Details

This module has been created to assist with the onboarding process

The module contains.

- AWS BACKUP
- Patch Manager
- AWS BUDGETS
- Monitoring
- Patch Alerting


# Required Variables

## Profile

```
profile = "<AWS account ID>"
```

# Conditional Required Variables

The following Variables are only required if the follow resources are to be deployed

``Monitoring``, ``Patch Alerting``

To disable the above resources, enter the following into the module block

```
enable_monitoring     = false
enable_patch_alerting = false
```

## Monitoring

### monitoring_role_name

the `monitoring_role_name` is used to provide the name for the new iam role being created.

the default value of `monitoring_role_name` is `Monitoring_Role`

```
monitoring_role_name = "Monitoring_Role"
```

``variable type = string``

### root_monitoring_account

the `root_monitoring_account` is used to provide the central account ID used for monitoring

```
root_monitoring_account = "0123456789"
```

``variable type = string``

### root_monitoring_role_name

the `root_monitoring_role_name` is used to provide the central role that will assume role into the account for monitoring

```
root_monitoring_role_name = "root_monitoring_role"
```

``variable type = string``

## Patch Alerting

### patch_alerting_recepients

the `patch_alerting_recepients` is used to provide the recepients that will be sent alerts if a `run_command` fails for patching

```
patch_alerting_recepients = "name@domain.com"
```

``variable type = string``

### patch_alerting_sender

the `patch_alerting_sender` is used to provide the sender for alerts if a `run_command` fails for patching

```
patch_alerting_sender = "name@domain.com"
```

``variable type = string``


# Optional Variables

### Resources to enable or disable

By default, all resources are enabled or `true`

#### Backups

To disable backups, the following needs to be added into the module block

```
enable_backups = false
```

``variable type = bool``

#### Patching

To disabled patching, the following needs to be added into the module block
```
enable_patching = false
```

``variable type = bool``

#### Budget

To disable budgets. the following needs to be added into the module block.

```
enable_budget = false
```

``variable type = bool``

## Backups

### backup_name

```
backup_name = "AWS_BACKUP"
```

By default, the `backup_name` is `AWS_BACKUP`

``variable type = string``


### backup_namespace

```
backup_namespace = "aws"
```

By default, the `backup_namespace` is `aws`


``variable type = string``

### backup_stage

```
backup_stage = "backups"
```

by default, the `backup_stage` is `backups`

``variable type = string``

### backup_delimiter

The delimiter is used to seperate the name, stage and namespace for readability

```
backup_delimiter = "-"
```

By default, the `backup_delimiter` is `-`

``variable type = string``

### backup_schedule

The `backup_schedule` is a value to define the backup windows and the retention periods.

By default, the `backup_schedule` value is:

```
{
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
```

To alter the backup schedule, you need to supply a map value similar to the below.

```
backup_schedule = {
          unique_name_1 = {
            name         = "daily"
            schedule     = "cron(0 15 * * ? *)"
            delete_after = 7
          }
          unique_name_2  = {
            name         = "weekly"
            schedule     = "cron(0 15 ? * 1 *)"
            delete_after = 30
          }
          unique_name_3  = {
            name         = "monthly"
            schedule     = "cron(0 15 1 * ? *)"
            delete_after = 365
          }
        }
```

``variable type = map``

### backup_resources

The `backup_resources` is a list of resources to include in the backup process.

By default, the value for `backup_resources` is `["*"]`

```
backup_resources = ["*"]
```

``variable type = list(string)``


### backup_selection_tags

The `backup_selection_tags` is used to search for resources with a specific tag.

The default `backup_selection_tags` is:

```
[
          {
            key   = "aws:ResourceTag/backup"
            value = "standard"
            }
        ]
```

```
backup_selection_tags = [
          {
            key   = "aws:ResourceTag/backup"
            value = "standard"
            }
        ]
```

``
variable type = list(object({
    key   = string
    value = string
  }))
``

## Patching

### patching_install_maintenance_windows_targets

the `patching_install_maintenance_windows_targets` is used to manually enter the instance ID's that are going to receive patches in the specified patch window.

The default value for `patching_install_maintenance_windows_targets` is `[]`

```
patching_install_maintenance_windows_targets = []
```

``
variable type = list(object({
    key : string
    values : list(string)
    })
``

### approved_patches

the `approved_patches` is used to supply a list of approved patches for the baseline.

The default value for `approved_patches` is `[]`

```
approved_patches = []
```

``variable type = list(string)``

### rejected_patches

the `rejected_patches` is used to supply a list of rejected patches for the baseline

the default value for `rejected_patches` is `[]`

```
rejected_patches = []
```

``variable type = list(string)``

### custom_baselines

the `custom_baselines` is used to create a list of custome baselines you want to use instead of the default ones.

the default value for `custom_baselines` is `[]`

```
custom_baselines = []
```

``variable type = list(string)``

### operating_system

The `operating_system` is used to supply the operating system the patches are applied to

the default value for `operating_system` is `[]`

```
operating_system = []
```

``variable type = list(string)``

### patching_maintenance_windows
The `patching_maintenance_windows` is used to supply a list of patching maintenane window names.

The default value for `patching_maintenance_windows` is `["PROD-AZ-A", "PROD-AZ-B", "PROD-AZ-C"]`

```
patching_maintenance_windows = ["PROD-AZ-A", "PROD-AZ-B", "PROD-AZ-C"]
```

``variable type = list(string)``

### default_patch_groups

The `default_patch_groups` is used if you would like to use the default patching groups

the default value for `default_patch_groups` is `true`

```
default_patch_groups = true
```

``variable type = bool``


### default_patch_scan

the `default_patch_scan` is used to enable the monthly "scanning" of all instances in the AWS account.

the default value for `default_patch_scan` is `true`

```
default_patch_scan = true
```

``variable type = bool``

### patching_schedule_windows

the `patching_schedule_windows` is used to suppy a list of cron values for the `patching_maintenance_windows` above

the default value for `patching_schedule_windows` is `["cron(0 18 ? * TUE *)", "cron(0 18 ? * WED *)", "cron(0 18 ? * THU *)"]`

```
patching_schedule_windows = ["cron(0 18 ? * TUE *)", "cron(0 18 ? * WED *)", "cron(0 18 ? * THU *)"]
```

``variable type = list(string)``

### patching_schedule_windows_scan

the `patching_schedule_windows_scan` is used to supply the `default_patch_scan` a cron time to run the scan.

The default value for `patching_schedule_windows_scan` is `cron(0 16 ? * SUN *)`

```
patching_schedule_windows_scan = "cron(0 16 ? * SUN *)" 
```

``variable type = string``

### patching_approved_patches_compliance_level

the `patching_approved_patches_compliance_level` is used to supply the level of compliance for the patch baselines.

the default value for `patching_approved_patches_compliance_level` is `CRITICAL`

```
patching_approved_patches_compliance_level = "CRITICAL"
```
``variable type = string``

### patching_reboot_option

the `patching_reboot_option` is used to determine if an instance is rebooted when a patch requires a reboot.

The default value for `patching_reboot_option` is `RebootIfNeeded`

```
patching_reboot_option = "RebootIfNeeded"
```

``variable type = string``

### patching_task_install_priority

The `patching_task_install_priority` is used to determine the priority of the install patch run command.

the default value for `patching_task_install_priority` is `1`

```
patching_task_install_priority = 1
```

``variable type = number``

### patching_max_concurrency

the `patching_max_concurrency` is used to provide the number of instances able to be patched at one time.

The default value for `patching_max_concurrency` is `10` 

```
patching_max_concurrency = 10
```

``variable type = number``

### patching_max_errors

The `patching_max_errors` is used to provide the maxumum number of failures before the patching process is terminated.

the default value for `patching_max_errors` is `10` 

```
patching_max_errors = 10
```

``variable type = 10``

## Budgets

### budget_comparison_operator

the `budget_comparison_operator` is used to define the operator that determines when a budget has reached its threshold

the default value for `budget_comparison_operator` is `GREATER_THAN`

```
budget_comparison_operator = "GREATER_THAN"
```

``variable type = string``

### budget_threshold

the `budget_threshold` is used to determine the value required for the threshold

the default value of `budget_threshold` is `100`

```
budget_threshold = 100
```

``variable type = number``

### budget_threshold_type

the `budget_threshold_type` is used for the comparator to determine if the threshold has been met.

the default value for `budget_threshold_type` is `PERCENTAGE`

```
budget_threshold_type = "PERCENTAGE"
```

``variable type = string``

### budget_notification_type

the `budget_notification_type` is used to provide when the notification should be sent.

The default value for `budget_notification_type` is `FORECASTER`

```
budget_notification_type = "FORECASTED"
```

``variable type = string``

### budget_subscriber_email_addresses

the `budget_subscriber_email_addresses` is used to provide an email address for when the threshold is met

the default value for `budget_subscriber_email_addresses` is `""`

```
budget_subscriber_email_addresses = ""
```

``variable type = string``

### budget_unit 

the `budget_unit` is used to provide the currency used for the threshold.

the default value of `budget_unit` is `USD`

```
budget_unit = "USD"
```

``variable type = string``

### budget_time_unit 

The `budget_time_unit` is used to provide the time unit for measurement required for the threshold

The default value of `budget_time_unit` is `MONTHLY`

```
budget_time_unit = "MONTHLY"
```

``variable type = string``

### budget_time_period_start_default 

the `budget_time_period_start_default` is used to if you want to use the default start time.

the default value of `budget_time_period_start_default` is `true` the default value uses the current time as the starting time when the budget is created.

```
budget_time_period_start_default = true
```

``variable type = bool``

### budget_time_period_start

if `budget_time_period_start_default` is `false` then `budget_time_period_start` is used to determine the start time.

The default value for `budget_time_period_start` is `null`

```
budget_time_period_start = null
```

``variable type = string``

### budget_limit

the `budget_limit` is used to provide a number value for the threshold

the default value for `budget_limit` is 10000

```
budget_limit = 10000
```

``variable type = number``

### budget_name 

the `budget_name` is used to provide a name for the budget.

The default value of `budget_name` is `AWS_BUDGET`

```
budget_name = "AWS_BUDGET"
```

``variable type = string``

### budget_type

the `budget_type` is used to determine the type of budget notification.

the default value of `budget_type` is `COST`

```
budget_type = "COST"
```

``variable type = string``
