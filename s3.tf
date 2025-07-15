# S3 Bucket + versioning + encryption + lifecycle
#S3 Bucket 
resource "aws_s3_bucket" "data_s3_bucket" {
  bucket        = var.s3_bucket_name
  force_destroy = true

  tags = {
    Name        = "data_sensor_buckets"
    Environment = var.environment
  }
}

#Versioning 
resource "aws_s3_bucket_versioning" "sensor_data_versioning" {
  bucket = aws_s3_bucket.data_s3_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

#Encryption 
resource "aws_s3_bucket_server_side_encryption_configuration" "sensor_data_encryption" {
  bucket = aws_s3_bucket.data_s3_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

#Lifecycle 
resource "aws_s3_bucket_lifecycle_configuration" "sensor_data_lifecycle" {
  bucket = aws_s3_bucket.data_s3_bucket.id

  rule {
    id     = "expire-objects"
    status = "Enabled"

    expiration {
      days = 30
    }

    filter {
      prefix = ""
    }
  }
}
