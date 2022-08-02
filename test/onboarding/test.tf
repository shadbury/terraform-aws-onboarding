module "onboarding" {
  source  = "shadbury/onboarding/aws"
  version = "1.0.0"

  profile                   = local.workspace["profile"]
  region                    = local.workspace["region"]
  monitoring_role_name      = local.workspace["monitoring_role_name"]
  root_monitoring_account   = data.aws_caller_identity.current.id
  root_monitoring_role_name = local.workspace["root_monitoring_role_name"]
  patch_alerting_recepients = "joelshadbolt123@hotmail.com"
  patch_alerting_sender     = "joelshadbolt123@hotmail.com"
  budget_limit              = 20
  vault_name                = "AWS_BACKUP_VAULT"
  budget_subscriber_email_addresses = "joelshadbolt123@hotmail.com"

}

data "aws_caller_identity" "current" {}
