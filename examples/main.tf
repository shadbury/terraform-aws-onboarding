module "onboarding"{
    source  = "../onboarding_module"
    profile = local.workspace["aws_profile"]
    region =  local.workspace["region"]
}