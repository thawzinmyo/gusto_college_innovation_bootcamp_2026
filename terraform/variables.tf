variable "aws_region" {
  description = "AWS region to deploy the S3 bucket"
  type        = string
  default     = "ap-southeast-1"
}

variable "bucket_base_name" {
  description = <<-EOT
    Short base name for your S3 bucket (lowercase letters, numbers, hyphens only).
    AWS will scope it to your account + region automatically — no need for a
    globally unique name. Your AWS account ID is appended automatically.
    Example: "gusto-bootcamp-john"
  EOT
  type = string
}
