terraform {
  backend "s3" {}

  required_providers {
    aws = {
      version = "4.15.1"
      source  = "hashicorp/aws"
    }
  }
}

provider "aws" {
  profile = local.workspace["profile"]
  region = local.workspace["region"]
}
