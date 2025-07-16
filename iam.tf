# IAM roles + policy + attach + profile (attached to ec2 instance)

# IAM Rule (That we will give the ec2 instance)
resource "aws_iam_role" "ec2_s3_upload_role" {
  name = "ec2_s3_upload_role"

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

# IAM Policy to upload into s3 buckets 
resource "aws_iam_policy" "s3_upload_policy" {
  name = "ec2_s3_upload_policy"

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

# Policy Role Attachment 
resource "aws_iam_role_policy_attachment" "attach_s3_policy_to_role" {
  role       = aws_iam_role.ec2_s3_upload_role.name
  policy_arn = aws_iam_policy.s3_upload_policy.arn
}

# Profile Role
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2_s3_upload_profile"
  role = aws_iam_role.ec2_s3_upload_role.name
}


# IAM roles + policy + attach + profile (attached to lambda)

# IAM Role (That we will give the lambda)
resource "aws_iam_role" "lambda_role" {
  name = "lambda_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

# IAM Policy for lambda to get from s3 buckets and log to cloudwatch 
resource "aws_iam_policy" "lambda_s3_get_policy" {
  name = "lambda_s3_get_policy"

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [{
      Effect   = "Allow"
      Action   = ["s3:GetObject"]
      Resource = "${aws_s3_bucket.data_s3_bucket.arn}/*"
      },
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
    }]
  })
}

# Policy Role Attachment 
resource "aws_iam_role_policy_attachment" "attach_lambda_policy_to_role" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_s3_get_policy.arn
}
