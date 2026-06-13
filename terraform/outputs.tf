output "website_url" {
  description = "Public URL of the static website"
  value       = "http://${aws_s3_bucket_website_configuration.website.website_endpoint}"
}

output "bucket_name" {
  description = "Full name of the created S3 bucket (base name + account ID suffix)"
  value       = aws_s3_bucket.website.id
}

output "bucket_arn" {
  description = "ARN of the created S3 bucket"
  value       = aws_s3_bucket.website.arn
}
