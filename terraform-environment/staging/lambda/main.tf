resource "aws_iam_role" "lambda_execution_role" {
  name = "lambda_execution_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com",
      },
    }],
  })
}

resource "aws_lambda_function" "lambda_function_1" {
  source_code_hash = <<EOT
filebase64("lambda-function-1.zip")
EOT
  runtime          = "python3.8"
  role             = aws_iam_role.lambda_execution_role.arn
  handler          = "index.handler"
  function_name    = "lambda-function-1"
  filename         = "lambda-function-1.zip"
}

resource "aws_lambda_function" "lambda_function_2" {
  source_code_hash = <<EOT
filebase64("lambda-function-1.zip")
EOT
  runtime          = "python3.8"
  role             = aws_iam_role.lambda_execution_role.arn
  handler          = "index.handler"
  function_name    = "lambda-function-2"
  filename         = "lambda-function-2.zip"
}

resource "aws_lambda_function" "lambda_function_3" {
  source_code_hash = <<EOT
filebase64("lambda-function-1.zip")
EOT
  runtime          = "python3.8"
  role             = aws_iam_role.lambda_execution_role.arn
  handler          = "index.handler"
  function_name    = "lambda-function-3"
  filename         = "lambda-function-3.zip"
}

resource "aws_lambda_function" "lambda_function_4" {
  source_code_hash = <<EOT
filebase64("lambda-function-1.zip")
EOT
  runtime          = "python3.8"
  role             = aws_iam_role.lambda_execution_role.arn
  handler          = "index.handler"
  function_name    = "lambda-function-4"
  filename         = "lambda-function-4.zip"
}

resource "aws_iam_role_policy_attachment" "lambda_execution_role_policy_attachment" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_api_gateway_rest_api" "my_api_gateway" {
  name        = "my-api-gateway"
  description = "My API Gateway"
}

resource "aws_api_gateway_resource" "resource_lambda_1" {
  rest_api_id = aws_api_gateway_rest_api.my_api_gateway.id
  path_part   = "lambda1"
  parent_id   = aws_api_gateway_rest_api.my_api_gateway.root_resource_id
}

resource "aws_api_gateway_resource" "resource_lambda_2" {
  rest_api_id = aws_api_gateway_rest_api.my_api_gateway.id
  path_part   = "lambda2"
  parent_id   = aws_api_gateway_rest_api.my_api_gateway.root_resource_id
}

resource "aws_api_gateway_resource" "resource_lambda_3" {
  rest_api_id = aws_api_gateway_rest_api.my_api_gateway.id
  path_part   = "lambda3"
  parent_id   = aws_api_gateway_rest_api.my_api_gateway.root_resource_id
}

resource "aws_api_gateway_resource" "resource_lambda_4" {
  rest_api_id = aws_api_gateway_rest_api.my_api_gateway.id
  path_part   = "lambda4"
  parent_id   = aws_api_gateway_rest_api.my_api_gateway.root_resource_id
}

resource "aws_api_gateway_integration" "integration_lambda_1" {
  uri                     = aws_lambda_function.lambda_function_1.invoke_arn
  type                    = "AWS_PROXY"
  rest_api_id             = aws_api_gateway_rest_api.my_api_gateway.id
  resource_id             = aws_api_gateway_resource.resource_lambda_1.id
  integration_http_method = "POST"
  http_method             = "POST"
}

resource "aws_api_gateway_integration" "integration_lambda_2" {
  uri                     = aws_lambda_function.lambda_function_2.invoke_arn
  type                    = "AWS_PROXY"
  rest_api_id             = aws_api_gateway_rest_api.my_api_gateway.id
  resource_id             = aws_api_gateway_resource.resource_lambda_2.id
  integration_http_method = "POST"
  http_method             = "POST"
}

resource "aws_api_gateway_integration" "integration_lambda_3" {
  uri                     = aws_lambda_function.lambda_function_3.invoke_arn
  type                    = "AWS_PROXY"
  rest_api_id             = aws_api_gateway_rest_api.my_api_gateway.id
  resource_id             = aws_api_gateway_resource.resource_lambda_3.id
  integration_http_method = "POST"
  http_method             = "POST"
}

resource "aws_api_gateway_integration" "integration_lambda_4" {
  uri                     = aws_lambda_function.lambda_function_4.invoke_arn
  type                    = "AWS_PROXY"
  rest_api_id             = aws_api_gateway_rest_api.my_api_gateway.id
  resource_id             = aws_api_gateway_resource.resource_lambda_4.id
  integration_http_method = "POST"
  http_method             = "POST"
}

resource "aws_api_gateway_method_response" "method_response_lambda_1" {
  status_code = "200"
  rest_api_id = aws_api_gateway_rest_api.my_api_gateway.id
  resource_id = aws_api_gateway_resource.resource_lambda_1.id
  http_method = aws_api_gateway_integration.integration_lambda_1.http_method
}

resource "aws_api_gateway_method_response" "method_response_lambda_2" {
  status_code = "200"
  rest_api_id = aws_api_gateway_rest_api.my_api_gateway.id
  resource_id = aws_api_gateway_resource.resource_lambda_2.id
  http_method = aws_api_gateway_integration.integration_lambda_2.http_method
}

resource "aws_api_gateway_method_response" "method_response_lambda_3" {
  status_code = "200"
  rest_api_id = aws_api_gateway_rest_api.my_api_gateway.id
  resource_id = aws_api_gateway_resource.resource_lambda_3.id
  http_method = aws_api_gateway_integration.integration_lambda_3.http_method
}

resource "aws_api_gateway_method_response" "method_response_lambda_4" {
  status_code = "200"
  rest_api_id = aws_api_gateway_rest_api.my_api_gateway.id
  resource_id = aws_api_gateway_resource.resource_lambda_4.id
  http_method = aws_api_gateway_integration.integration_lambda_4.http_method
}

resource "aws_api_gateway_integration_response" "integration_response_lambda_1" {
  status_code = aws_api_gateway_method_response.method_response_lambda_1.status_code
  rest_api_id = aws_api_gateway_rest_api.my_api_gateway.id
  resource_id = aws_api_gateway_resource.resource_lambda_1.id
  http_method = aws_api_gateway_integration.integration_lambda_1.http_method
}

resource "aws_api_gateway_integration_response" "integration_response_lambda_2" {
  status_code = aws_api_gateway_method_response.method_response_lambda_2.status_code
  rest_api_id = aws_api_gateway_rest_api.my_api_gateway.id
  resource_id = aws_api_gateway_resource.resource_lambda_2.id
  http_method = aws_api_gateway_integration.integration_lambda_2.http_method
}

resource "aws_api_gateway_integration_response" "integration_response_lambda_3" {
  status_code = aws_api_gateway_method_response.method_response_lambda_3.status_code
  rest_api_id = aws_api_gateway_rest_api.my_api_gateway.id
  resource_id = aws_api_gateway_resource.resource_lambda_3.id
  http_method = aws_api_gateway_integration.integration_lambda_3.http_method
}

resource "aws_api_gateway_integration_response" "integration_response_lambda_4" {
  status_code = aws_api_gateway_method_response.method_response_lambda_4.status_code
  rest_api_id = aws_api_gateway_rest_api.my_api_gateway.id
  resource_id = aws_api_gateway_resource.resource_lambda_4.id
  http_method = aws_api_gateway_integration.integration_lambda_4.http_method
}

resource "aws_api_gateway_integration" "integration_alb" {
  uri                     = aws_lb.my_alb.dns_name
  type                    = "HTTP_PROXY"
  rest_api_id             = aws_api_gateway_rest_api.my_api_gateway.id
  resource_id             = aws_api_gateway_rest_api.my_api_gateway.root_resource_id
  integration_http_method = "GET"
  http_method             = "GET"
}

resource "aws_api_gateway_method" "method_alb" {
  rest_api_id   = aws_api_gateway_rest_api.my_api_gateway.id
  resource_id   = aws_api_gateway_rest_api.my_api_gateway.root_resource_id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method_response" "method_response_alb" {
  status_code = "200"
  rest_api_id = aws_api_gateway_rest_api.my_api_gateway.id
  resource_id = aws_api_gateway_rest_api.my_api_gateway.root_resource_id
  http_method = aws_api_gateway_method.method_alb.http_method
}

resource "aws_api_gateway_integration_response" "integration_response_alb" {
  status_code = aws_api_gateway_method_response.method_response_alb.status_code
  rest_api_id = aws_api_gateway_rest_api.my_api_gateway.id
  resource_id = aws_api_gateway_rest_api.my_api_gateway.root_resource_id
  http_method = aws_api_gateway_integration.integration_alb.http_method
}
