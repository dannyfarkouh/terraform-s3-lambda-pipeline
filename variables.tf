# Variables for S3 Bucket

variable "s3_bucket_name" {
  description = "Name of the S3 Bucket"
  type        = string
}

variable "environment" {
  description = "Environment name (dev / prod)"
  type        = string
  default     = "dev"
}
