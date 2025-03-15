terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
}

module "s3_website" {
  source = "../../modules/s3"
  providers = {
    aws = aws.us-east-1
  }

  bucket_name = var.domain_name
  tags       = local.common_tags
}

module "hello_world_lambda" {
  source = "../../modules/lambda"

  function_name = "${local.name_prefix}-hello-world"
  source_dir    = "../../../apps/backend/functions/hello-world/src"
  runtime       = "python3.12"
  handler       = "lambda_function.lambda_handler"

  tags = local.common_tags
}

module "acm" {
  source = "../../modules/acm"
  providers = {
    aws = aws.us-east-1
  }

  domain_name = var.domain_name
  tags       = local.common_tags
}

module "cloudfront" {
  source = "../../modules/cloudfront"
  depends_on = [module.acm.aws_acm_certificate_validation]

  name               = "${local.name_prefix}-distribution"
  origin_domain_name = module.s3_website.bucket_regional_domain_name
  origin_id         = "${local.name_prefix}-origin"
  certificate_arn   = module.acm.certificate_arn
  function_file     = "../../../apps/backend/functions/cloudfront-viewer/src/function.js"
  domain_name       = var.domain_name
  
  tags = local.common_tags
}

locals {
  name_prefix = "${local.actual_project_name}-${var.environment}"
  common_tags = {
    Project     = local.actual_project_name
    Environment = var.environment
    Company     = var.company_name
    Terraform   = "true"
    ManagedBy   = "terraform"
  }
}

output "s3_bucket_name" {
  description = "Name of the S3 bucket for frontend deployment"
  value       = module.s3_website.bucket_name
} 