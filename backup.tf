module "backup" {
  count = var.enable_backups ? 1 : 0
  source = "shadbury/backup/aws"
  version = "1.0.0"
  
  namespace          = var.backup_namespace
  stage              = var.backup_stage
  name               = var.backup_name
  vault_name         = var.backup_name
  delimiter          = var.backup_delimiter
  schedule           = var.backup_schedule
  selection_tags     = var.backup_selection_tags
  backup_resources   = var.backup_resources
}