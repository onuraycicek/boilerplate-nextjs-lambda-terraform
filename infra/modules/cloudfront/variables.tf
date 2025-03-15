variable "name" {
  type        = string
  description = "Name for the CloudFront distribution and related resources"
}

variable "origin_domain_name" {
  type        = string
  description = "Domain name of the origin (e.g., S3 website endpoint)"
}

variable "origin_id" {
  type        = string
  description = "Unique identifier for the origin"
}

variable "certificate_arn" {
  type        = string
  description = "ARN of the ACM certificate for CloudFront"
}

variable "function_file" {
  type        = string
  description = "Path to the CloudFront function JavaScript file"
}

variable "price_class" {
  type        = string
  description = "CloudFront distribution price class"
  default     = "PriceClass_100"
}

variable "domain_name" {
  type        = string
  description = "Domain name for the CloudFront distribution"
}

variable "tags" {
  type        = map(string)
  description = "Tags to be added to resources"
  default     = {}
} 