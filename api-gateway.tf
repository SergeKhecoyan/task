resource "aws_api_gateway_rest_api" "api" {
  name = "myapi"
  binary_media_types = [
       "image/jpg"
    ]
}

resource "aws_api_gateway_resource" "resource" {
  path_part   = "resource"
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  rest_api_id = aws_api_gateway_rest_api.api.id
}

resource "aws_api_gateway_method" "method_GET" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.resource.id
  http_method   = "GET"
  authorization = "NONE"
  request_validator_id = aws_api_gateway_request_validator.example.id
  request_parameters = {"method.request.header.Authorization" = true, "method.request.header.base64" = true, "method.request.querystring.file" = true}

}

resource "aws_api_gateway_method" "method_PUT" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.resource.id
  http_method   = "PUT"
  authorization = "NONE"
  request_validator_id = aws_api_gateway_request_validator.example.id
  request_parameters = {"method.request.header.Authorization" = true, "method.request.header.base64" = true}

}

resource "aws_api_gateway_integration" "integration_GET" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.resource.id
  http_method             = aws_api_gateway_method.method_GET.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda_get.invoke_arn

}

resource "aws_api_gateway_integration" "integration_PUT" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.resource.id
  http_method             = aws_api_gateway_method.method_PUT.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda_put.invoke_arn

}


resource "aws_api_gateway_request_validator" "example" {
  name                        = "Validate query string parameters and headers"
  rest_api_id                 = aws_api_gateway_rest_api.api.id
  validate_request_body       = false
  validate_request_parameters = true
}

resource "aws_api_gateway_deployment" "example" {
  depends_on = [aws_api_gateway_integration.integration_GET, aws_api_gateway_integration.integration_PUT]
  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name = "v1"
}


