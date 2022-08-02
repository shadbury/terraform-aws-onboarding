module "patch-manager" {
  count = var.enable_patching ? 1 : 0
  source = "shadbury/patching/aws"
  version = "1.0.0"

  client_name                         = var.profile
  maintenance_windows                 = var.patching_maintenance_windows
  default_patch_groups                = var.default_patch_groups
  default_scan                        = var.default_patch_scan
  schedule_windows                    = var.patching_schedule_windows
  schedule_windows_scan               = var.patching_schedule_windows_scan
  approved_patches_compliance_level   = var.patching_approved_patches_compliance_level
  reboot_option                       = var.patching_reboot_option
  task_install_priority               = var.patching_task_install_priority
  max_concurrency                     = var.patching_max_concurrency
  max_errors                          = var.patching_max_errors
  install_maintenance_windows_targets = var.patching_install_maintenance_windows_targets
  approved_patches                    = var.approved_patches
  rejected_patches                    = var.rejected_patches
  custom_baselines                    = var.custom_baselines
  operating_system                    = var.operating_system
}