variable "domain_name" {
  type        = string
  description = "Domain name for the certificate"
}

variable "tags" {
  type        = map(string)
  description = "Tags to be added to resources"
  default     = {}
} 