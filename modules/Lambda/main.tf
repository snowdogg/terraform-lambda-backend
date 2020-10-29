resource "aws_iam_role_policy" "main" {
  name = "dynamodbaccessforlambda"
  role = aws_iam_role.main.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Resource": "*",
            "Action": [
                "dynamodb:BatchGetItem",
                "dynamodb:Describe*",
                "dynamodb:List*",
                "dynamodb:GetItem",
                "dynamodb:PutItem",
                "dynamodb:Query",
                "dynamodb:Scan",
                "ec2:DescribeInstances",
                "ec2:CreateNetworkInterface",
                "ec2:AttachNetworkInterface",
                "ec2:DescribeNetworkInterfaces",
                "ec2:DeleteNetworkInterface",
                "autoscaling:CompleteLifecycleAction" 
            ]
        }
    ]
}
EOF


}

resource "aws_iam_role" "main" {
  name = "amazingRole"

  assume_role_policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "lambda.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
      }
    ]
  }
  EOF


}

resource "aws_lambda_function" "post" {
  filename      = "lambdapost.zip"
  function_name = "create-user"
  role          = aws_iam_role.main.arn
  handler       = "index.handler"
  timeout       = 9
  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = filebase64sha256("lambdapost.zip")

  runtime = "nodejs12.x"
  environment {
    variables = {
      foo = "bar"
    }
  }
  vpc_config {
     subnet_ids = [var.private_subnet1, var.private_subnet2]
     security_group_ids = [var.security_group]
   } 

}

resource "aws_lambda_function" "get" {
  filename      = "lambdaget.zip"
  function_name = "get-users"
  role          = aws_iam_role.main.arn
  handler       = "index.handler"
  timeout       = 9
  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = filebase64sha256("lambdaget.zip")

  runtime = "nodejs12.x"

  environment {
    variables = {foo = "bar"}
  }
  vpc_config {
     subnet_ids = [var.private_subnet1, var.private_subnet2]
     security_group_ids = [var.security_group]
   } 

}