variable "profile" {
    type        = string
    description = "account id for the account to onboard"
}

variable "region" {
    type        = string
    description = "region of the account to onboard"
    default     = "ap-southeast-2"
}

variable "gitlab_vpc_name" {
  type        = string
  description = "The name of the VPC to add the gitlab runner"
  default     = "mgmt"
}

variable "gitlab_url" {
  type        = string
  description = "URL of the gitlab runner"
  default     = "https://gitlab.runcmd.cmdsolutions.com.au/"
}

variable "gitlab_instance_type" {
  type        = string
  description = "Type of instance for gitlab runner"
  default     = "t3a.large"
}

variable "gitlab_concurrency" {
  type        = number
  description = "concurrency of gitlab runner"
  default     = 10
}

variable "gitlab_runner_domain" {
  type        = string
  description = "domain name for the gitlab runner"
  default     = "mgmt-int.runcmd.cmdsolutions.com.au"
}

variable "client" {
  type        = string
  description = "name of the client"
}

variable "gitlab_runner_use_private_subnet" {
  type        = bool
  description = "true or false to use private subnets"
  default     = true
}

