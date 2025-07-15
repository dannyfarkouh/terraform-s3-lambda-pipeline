variable "s3_bucket_name" {
  description = "Name of the s3 bucket that holds data"
  type        = string
}

variable "environment" {
  description = "env (prod / dev)"
  type        = string
  default     = "dev"
}
