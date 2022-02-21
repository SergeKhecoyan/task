resource "aws_lambda_function" "lambda-trigger" {
  filename      = "python/lambda-trigger.zip"
  function_name = "lambda_trigger"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "lambda-trigger.lambda_handler"

  source_code_hash = filebase64sha256("python/lambda-trigger.zip")
  
runtime = "python3.9"

  environment {
    variables = {
      foo = "bar"
    }
  }
}

resource "aws_s3_bucket_notification" "aws-lambda-trigger" {
  bucket = aws_s3_bucket.my-bucket-test-for-upload.id
  lambda_function {
    lambda_function_arn = aws_lambda_function.lambda-trigger.arn
    events              = ["s3:ObjectCreated:*"]

  }
}
resource "aws_lambda_permission" "test" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda-trigger.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = "arn:aws:s3:::${aws_s3_bucket.my-bucket-test-for-upload.id}"
}
