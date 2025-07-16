locals {
  lambda_code = templatefile("${path.module}/lambda_handler.py", {})
}

resource "aws_lambda_function" "s3_event_logger" {
  function_name = "s3-event-logger"               # Name in AWS console
  role          = aws_iam_role.lambda_role.arn    # The IAM role we made 
  runtime       = "python3.12"                    # Python version 
  handler       = "lambda_handler.lambda_handler" # file.function → lambda_handler.py with lambda_handler()

  filename         = "${path.module}/lambda_payload.zip"                   # Upload the zipped file
  source_code_hash = filebase64sha256("${path.module}/lambda_payload.zip") # Required so Terraform knows when code changes

  timeout = 10   # Max runtime in seconds 
  publish = true # Creates a versioned Lambda 
}
