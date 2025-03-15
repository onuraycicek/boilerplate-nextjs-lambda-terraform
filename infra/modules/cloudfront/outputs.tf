output "distribution_id" {
  value       = aws_cloudfront_distribution.distribution.id
  description = "ID of the CloudFront distribution"
}

output "distribution_domain_name" {
  value       = aws_cloudfront_distribution.distribution.domain_name
  description = "Domain name of the CloudFront distribution"
}

output "distribution_arn" {
  value       = aws_cloudfront_distribution.distribution.arn
  description = "ARN of the CloudFront distribution"
}

output "function_arn" {
  value       = aws_cloudfront_function.viewer_request.arn
  description = "ARN of the CloudFront function"
} 