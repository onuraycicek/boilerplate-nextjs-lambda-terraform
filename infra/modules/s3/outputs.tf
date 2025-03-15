output "bucket_name" {
  value       = aws_s3_bucket.website.id
  description = "Name of the S3 bucket"
}

output "website_endpoint" {
  value       = aws_s3_bucket_website_configuration.website.website_endpoint
  description = "S3 static website hosting endpoint"
}

output "bucket_regional_domain_name" {
  value       = aws_s3_bucket.website.bucket_regional_domain_name
  description = "Regional domain name of the S3 bucket"
} 