output "certificate_arn" {
  value       = aws_acm_certificate.cert.arn
  description = "ARN of the ACM certificate"
}

output "domain_name" {
  value       = aws_acm_certificate.cert.domain_name
  description = "Domain name of the certificate"
}

output "validation_emails" {
  value       = aws_acm_certificate.cert.validation_emails
  description = "List of email addresses that need to validate the certificate"
}

output "status" {
  value       = aws_acm_certificate.cert.status
  description = "Status of the certificate"
}

output "validation_records" {
  description = "DNS validation records that need to be created"
  value = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }
} 