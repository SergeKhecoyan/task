resource "aws_lambda_function" "lambda_put" {
  filename      = "python/terraform-lambda-put_v1.zip"
  function_name = "lambda_put"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "terraform-lambda-put_v1.lambda_handler"

  source_code_hash = filebase64sha256("python/terraform-lambda-put_v1.zip")

  runtime = "python3.9"

  environment {
    variables = {
      foo = "bar"
    }
  }
}


resource "aws_lambda_function" "lambda_get" {
  filename      = "python/terraform-lambda-get_v1.zip"
  function_name = "lambda_get"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "terraform-lambda-get_v1.lambda_handler"

  source_code_hash = filebase64sha256("python/terraform-lambda-get_v1.zip")
  runtime = "python3.9"

  environment {
    variables = {
      foo = "bar"
    }
  }
}

resource "aws_lambda_permission" "apigw_lambda_get" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_get.function_name
  principal     = "apigateway.amazonaws.com"
}

resource "aws_lambda_permission" "apigw_lambda_put" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_put.function_name
  principal     = "apigateway.amazonaws.com"
}
