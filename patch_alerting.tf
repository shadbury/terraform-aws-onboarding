module "patch_alerting" {
  count = var.enable_patch_alerting ? 1 : 0
  source = "shadbury/patch-alerting/aws"
  version = "1.0.0"

  patch_alerting_recepients = var.patch_alerting_recepients
  patch_alerting_sender     = var.patch_alerting_sender
  profile                   = var.profile
}