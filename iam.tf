# Policies and Rules so that the EC2 instance is able to push files into the s3 bucket 
# Role
resource "aws_iam_role" "ec2_s3_upload_role" {
  name = "ec2-s3-upload-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

# Policy 
resource "aws_iam_policy" "ec2_s3_upload_policy" {
  name = "ec2-s3-upload-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "s3:PutObject"
      ]
      Resource = "${aws_s3_bucket.data_s3_bucket.arn}/*"
    }]
  })
}
