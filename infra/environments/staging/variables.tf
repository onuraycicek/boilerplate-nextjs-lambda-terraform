variable "aws_region" {
  type        = string
  description = "AWS Region"
  default     = "us-east-1"
}

variable "project_name" {
  type        = string
  description = "Name of the project. If not provided, domain_name will be used"
  default     = null
}

variable "environment" {
  type        = string
  description = "Environment name"
  default     = "staging"
}

variable "domain_name" {
  type        = string
  description = "Domain name for the application"
}

variable "company_name" {
  type        = string
  description = "Name of the company"
}

locals {
  actual_project_name = coalesce(var.project_name, replace(var.domain_name, ".", "-"))
} 