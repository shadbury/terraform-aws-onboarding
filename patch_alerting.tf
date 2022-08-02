module "patch_alerting" {
  count = var.enable_patch_alerting ? 1 : 0
  source = "./modules/patch_alerting"

  patch_alerting_recepients = var.patch_alerting_recepients
  patch_alerting_sender     = var.patch_alerting_sender
  profile                   = var.profile
}