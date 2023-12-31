variable "project_prefix" {
  type        = string
  description = "prefix string put in front of string"
  default     = "f5xc"
}

variable "project_suffix" {
  type        = string
  description = "prefix string put at the end of string"
  default     = "1"
}

variable "root_path" {
  type = string
}

variable "f5xc_api_p12_file_absolute" {
  type = string
}

variable "f5xc_api_url" {
  type = string
}

variable "f5xc_api_token" {
  type = string
}

variable "f5xc_aws_region" {
  type        = string
  description = "AWS region name"
  default     = "us-west-2"
}

variable "f5xc_namespace" {
  type    = string
  default = "system"
}

provider "aws" {
  region = var.f5xc_aws_region
  alias  = "default"
}

provider "volterra" {
  api_p12_file = format("%s/%s", var.root_path, var.f5xc_api_p12_file_absolute)
  url          = var.f5xc_api_url
  alias        = "default"
  timeout      = "30s"
}

module "namespace" {
  source                        = "./modules/f5xc/namespace"
  f5xc_namespace_name           = format("%s-ns-service-policy-%s", var.project_prefix, var.project_suffix)
  f5xc_namespace_create_timeout = "10s"
  providers                     = {
    volterra = volterra.default
  }
}

module "service-policy" {
  source                   = "./modules/f5xc/service-policy"
  f5xc_namespace           = module.namespace.namespace["name"]
  f5xc_service_policy_name = format("%s-service-policy-%s", var.project_prefix, var.project_suffix)
  f5xc_service_policy      = {
    rules = [
      {
        metadata = {
          name = "r1"
        }
        spec = {
          action     = "ALLOW"
          any_client = true
        }
      },
      {
        metadata = {
          name = "r2"
        }
        spec = {
          action = "DENY"
          any_ip = true
        }
      }
    ]
    deny_list = {
      country_list = ["COUNTRY_CN"]
    }
  }
  providers = {
    volterra = volterra.default
  }
}

output "service_policy" {
  value = module.service-policy.service_policy
}