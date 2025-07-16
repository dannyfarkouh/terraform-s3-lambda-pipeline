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
# At this stage, we now gave lambda full permissions and is now able to do what we want it to do 
# But we still did not give the permission for the s3 to call the function

# Allow S3 bucket to call lambda function
resource "aws_lambda_permission" "allow_s3_to_invoke_lambda" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.s3_event_logger.function_name
  principal     = "s3.amazonaws.com"

  source_arn = aws_s3_bucket.data_s3_bucket.arn # bucket ARN 
}
# At this stage, the s3 bucket can call the lambda function, but we still haven't added the 'when', 
# so the s3 can call it but we haven't configured it to call it when there is a new file dropped. 

# Add notification so that lambda function is triggered at the event of an s3 object creation 
resource "aws_s3_bucket_notification" "s3_event_notification" {
  bucket = aws_s3_bucket.data_s3_bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.s3_event_logger.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = ""
    filter_suffix       = ""
  }

  depends_on = [aws_lambda_permission.allow_s3_to_invoke_lambda]
}
# At this stage, everything should be working well, we should run a lambda function everytime a file is dumped into s3 
# This is a perfect pipeline because we are also simulating the the dumping of json files into the s3 bucket 
