
module "Lambda" {
  source = "../Lambda"

  engineer = var.engineer
}

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

   integration_http_method = "GET"
   type                    = "HTTP"
   uri                     = var.get_arn
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
   type                    = "HTTP"
   uri                     = var.post_arn
}

resource "aws_api_gateway_deployment" "main" {
   depends_on = [
     aws_api_gateway_integration.get,
     aws_api_gateway_integration.post
   ]
   rest_api_id = aws_api_gateway_rest_api.main.id
   stage_name  = "test"
}

# resource "aws_lambda_permission" "apigw" {
#    statement_id  = "AllowAPIGatewayInvoke"
#    action        = "lambda:InvokeFunction"
#    function_name = aws_lambda_function.myLambda.function_name
#    principal     = "apigateway.amazonaws.com"

#    # The "/*/*" portion grants access from any method on any resource
#    # within the API Gateway REST API.
#    source_arn = "${aws_api_gateway_rest_api.apiLambda.execution_arn}/*/*"
# }