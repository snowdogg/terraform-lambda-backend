resource "aws_api_gateway_rest_api" "main" {
  name          = "FantasticAPI"
  tags = {
    Engineer = var.engineer
  }
    endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "main" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = aws_api_gateway_rest_api.main.root_resource_id
  path_part   = "users"
  # tags = {
  #   Engineer = var.engineer
  # }
}

resource "aws_api_gateway_method" "get" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.main.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "get" {
   rest_api_id = aws_api_gateway_rest_api.main.id
   resource_id = aws_api_gateway_method.get.resource_id
   http_method = aws_api_gateway_method.get.http_method

   integration_http_method = "POST"
   type                    = "AWS"
   uri                     = var.get_arn

     # Transforms the incoming XML request to JSON
  request_templates = {
    "application/xml" = <<EOF
{
   "body" : $input.json('$')
}
EOF
  }
}

resource "aws_api_gateway_method" "post" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.main.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "post" {
   rest_api_id = aws_api_gateway_rest_api.main.id
   resource_id = aws_api_gateway_method.post.resource_id
   http_method = aws_api_gateway_method.post.http_method

   integration_http_method = "POST"
   type                    = "AWS"
   uri                     = var.post_arn

   request_parameters = {
    "integration.request.header.X-Authorization" = "'static'"
  }

  # Transforms the incoming XML request to JSON
  request_templates = {
    "application/xml" = <<EOF
{
   "body" : $input.json('$')
}
EOF
  }
}

resource "aws_api_gateway_deployment" "main" {
   depends_on = [
     aws_api_gateway_integration.get,
     aws_api_gateway_integration.post
   ]
   rest_api_id = aws_api_gateway_rest_api.main.id
   stage_name  = "test"
}

resource "aws_lambda_permission" "get" {
   statement_id  = "AllowAPIGatewayInvoke"
   action        = "lambda:InvokeFunction"
   function_name = var.get_name
   principal     = "apigateway.amazonaws.com"

   # The "/*/*/*" portion grants access from any method on any resource
   # within the API Gateway REST API.
   source_arn = "${aws_api_gateway_rest_api.main.execution_arn}/*/*/*"
}

resource "aws_lambda_permission" "post" {
   statement_id  = "AllowAPIGatewayInvoke"
   action        = "lambda:InvokeFunction"
   function_name = var.post_name
   principal     = "apigateway.amazonaws.com"

   # The "/*/*/*" portion grants access from any method on any resource
   # within the API Gateway REST API.
   source_arn = "${aws_api_gateway_rest_api.main.execution_arn}/*/*/*"
}

resource "aws_api_gateway_method_response" "response_200" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.main.id
  http_method = aws_api_gateway_method.get.http_method
  status_code = "200"
  # response_parameters = {
  #   "method.response.header.Access-Control-Allow-Headers" = true
  #   "method.response.header.Access-Control-Allow-Methods" = true
  #   "method.response.header.Access-Control-Allow-Origin" = true
  # }
}

resource "aws_api_gateway_integration_response" "get" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.main.id
  http_method = "GET"
  status_code = aws_api_gateway_method_response.response_200.status_code
  # response_parameters = {
  #   "method.response.header.Access-Control-Allow-Headers" = "'*'"
  #   "method.response.header.Access-Control-Allow-Methods" = "'GET'"
  #   "method.response.header.Access-Control-Allow-Origin" = "'*'"
  # }
}