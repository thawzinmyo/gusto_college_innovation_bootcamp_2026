# ─── Account identity (used for account-regional namespace) ────────────────────
# AWS Mar 2026: bucket names are now scoped to your account + region,
# so simple names like "gusto-bootcamp-john" are always available to you.
# We append the account ID to make the name deterministic and collision-free.
data "aws_caller_identity" "current" {}

locals {
  # Format: <base-name>--<account-id>  (account-regional namespace convention)
  full_bucket_name = "${var.bucket_base_name}--${data.aws_caller_identity.current.account_id}"
}

# ─── S3 Bucket ─────────────────────────────────────────────────────────────────
resource "aws_s3_bucket" "website" {
  bucket        = local.full_bucket_name
  force_destroy = true

  tags = {
    Name        = local.full_bucket_name
    Project     = "gusto-bootcamp-2026"
    Environment = "workshop"
  }
}

# ─── Disable Block Public Access ───────────────────────────────────────────────
resource "aws_s3_bucket_public_access_block" "website" {
  bucket = aws_s3_bucket.website.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# ─── Static Website Configuration ─────────────────────────────────────────────
resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.website.id

  index_document { suffix = "index.html" }
  error_document { key    = "index.html" }
}

# ─── Bucket Policy — allow public read ─────────────────────────────────────────
resource "aws_s3_bucket_policy" "website" {
  bucket = aws_s3_bucket.website.id

  # Must wait for public access block to be removed first
  depends_on = [aws_s3_bucket_public_access_block.website]

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.website.arn}/*"
      }
    ]
  })
}

# ─── Upload website files ───────────────────────────────────────────────────────
locals {
  website_files = {
    "index.html" = {
      path         = "${path.module}/../website/index.html"
      content_type = "text/html"
    }
    "style.css" = {
      path         = "${path.module}/../website/style.css"
      content_type = "text/css"
    }
    "script.js" = {
      path         = "${path.module}/../website/script.js"
      content_type = "application/javascript"
    }
  }
}

resource "aws_s3_object" "website_files" {
  for_each = local.website_files

  bucket       = aws_s3_bucket.website.id
  key          = each.key
  source       = each.value.path
  content_type = each.value.content_type
  etag         = filemd5(each.value.path)
}
