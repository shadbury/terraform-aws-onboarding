locals {
  enabled          = module.this.enabled
  plan_enabled     = local.enabled && var.plan_enabled
  iam_role_enabled = local.enabled && var.iam_role_enabled
  iam_role_name    = coalesce(var.iam_role_name, module.label_backup_role.id)
  vault_enabled    = local.enabled && var.vault_enabled
  vault_name       = coalesce(var.vault_name, module.this.id)
  vault_id         = join("", local.vault_enabled ? aws_backup_vault.default.*.id : data.aws_backup_vault.existing.*.id)
  vault_arn        = join("", local.vault_enabled ? aws_backup_vault.default.*.arn : data.aws_backup_vault.existing.*.arn)
}

data "aws_partition" "current" {}

module "label_backup_role" {
  source     = "../terraform-client-tags"
  enabled    = local.enabled
  attributes = ["backup"]

  context = module.this.context
}

resource "aws_backup_vault" "default" {
  count       = local.vault_enabled ? 1 : 0
  name        = local.vault_name
  kms_key_arn = var.kms_key_arn
  tags        = module.this.tags
}

data "aws_backup_vault" "existing" {
  count = local.enabled && var.vault_enabled == false ? 1 : 0
  name  = local.vault_name
}

resource "aws_backup_plan" "default" {
  name  = "standard" 

  dynamic rule {
    for_each = var.schedule
    content {
    rule_name                = rule.value["name"]
    target_vault_name        = join("", local.vault_enabled ? aws_backup_vault.default.*.name : data.aws_backup_vault.existing.*.name)
    schedule                 = rule.value["schedule"]
    start_window             = var.start_window
    completion_window        = var.completion_window
    recovery_point_tags      = module.this.tags

    dynamic "lifecycle" {
      for_each = var.cold_storage_after != null || rule.value.delete_after != null ? ["true"] : []
      content {
        cold_storage_after = var.cold_storage_after
        delete_after       = rule.value.delete_after
      }
    }

    dynamic "copy_action" {
      for_each = var.destination_vault_arn != null ? ["true"] : []
      content {
        destination_vault_arn = var.destination_vault_arn

        dynamic "lifecycle" {
          for_each = var.copy_action_cold_storage_after != null || var.copy_action_delete_after != null ? ["true"] : []
          content {
            cold_storage_after = var.copy_action_cold_storage_after
            delete_after       = var.copy_action_delete_after
          }
        }
      }
    }
  }
  }

  tags = module.this.tags
}

data "aws_iam_policy_document" "assume_role" {
  count = local.iam_role_enabled ? 1 : 0

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["backup.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "default" {
  count              = local.iam_role_enabled ? 1 : 0
  name               = local.iam_role_name
  assume_role_policy = join("", data.aws_iam_policy_document.assume_role.*.json)
  tags               = module.label_backup_role.tags
}

data "aws_iam_role" "existing" {
  count = local.enabled && var.iam_role_enabled == false ? 1 : 0
  name  = local.iam_role_name
}

resource "aws_iam_role_policy_attachment" "default" {
  count      = local.iam_role_enabled ? 1 : 0
  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
  role       = join("", aws_iam_role.default.*.name)
}

resource "aws_backup_selection" "default" {
  name          = module.this.id
  iam_role_arn  = join("", var.iam_role_enabled ? aws_iam_role.default.*.arn : data.aws_iam_role.existing.*.arn)
  plan_id       = aws_backup_plan.default.id
  resources     = var.backup_resources
  condition {
    dynamic "string_equals"{
      for_each = var.selection_tags
      content {
        key   = string_equals.value["key"]
        value = string_equals.value["value"]
      }
    }
  }
}
