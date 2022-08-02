module "monitoring" {
  count = var.enable_monitoring ? 1 : 0
  source = "shadbury/monitoring/aws"
  version = "1.0.0"

  monitoring_role_name      = var.monitoring_role_name
  root_monitoring_account   = var.root_monitoring_account
  root_monitoring_role_name = var.root_monitoring_role_name
}