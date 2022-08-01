data "aws_vpc" "mainvpc" {
  tags = {
    Name = local.workspace.runner_vpc_name
  }
}


data "aws_subnet_ids" "public" {
  vpc_id = data.aws_vpc.mainvpc.id

  tags = {
    Name = "*PUBLIC*"
  }
}

data "aws_subnet_ids" "private" {
  vpc_id = data.aws_vpc.mainvpc.id

  tags = {
    Name = "*PRIVATE*"
  }
}

data "aws_ami" "amazonlinux2" {
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.*-x86_64-gp2"]
  }

  most_recent = true
  owners      = ["137112412989"]
}

data "aws_caller_identity" "current" {}
