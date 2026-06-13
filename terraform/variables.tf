variable "aws_region" {
  description = "AWS region to deploy the S3 bucket"
  type        = string
  default     = "ap-southeast-1"
}

variable "bucket_name" {
  description = "Globally unique S3 bucket name (lowercase letters, numbers, and hyphens only)"
  type        = string
  # Each student must set a unique name — no two S3 buckets in the world can share the same name
}
