module "onboarding" {
  source  = "shadbury/onboarding/aws"
  version = "1.0.3"

  profile                   = var.profile
  region                    = "ap-southeast-2"
  monitoring_role_name      = "Monitoring_Role"
  root_monitoring_account   = data.aws_caller_identity.current
  root_monitoring_role_name = "test"
}

data "aws_caller_identity" "current" {}