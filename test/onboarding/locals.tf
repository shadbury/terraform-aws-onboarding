locals {

  client = "shadbolt"
env = {
  master = {
        profile                   = var.profile
        region                    = var.region
        monitoring_role_name      = "Monitoring_Role"
        root_monitoring_role_name = "test"
    }
}
  workspace = local.env[terraform.workspace]
}