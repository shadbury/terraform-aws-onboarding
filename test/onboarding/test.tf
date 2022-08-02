module "onboarding" {
  source  = "shadbury/onboarding/aws"
  version = "1.0.0"

  profile                   = local.workspace["profile"]
  region                    = local.workspace["region"]
  monitoring_role_name      = local.workspace["monitoring_role_name"]
  root_monitoring_account   = data.aws_caller_identity.current.id
  root_monitoring_role_name = local.workspace["root_monitoring_role_name"]
}

data "aws_caller_identity" "current" {}
