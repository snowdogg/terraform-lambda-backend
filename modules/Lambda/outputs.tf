output "get_arn"{
    value = aws_lambda_function.get.invoke_arn
}

output "post_arn"{
    value = aws_lambda_function.post.invoke_arn
}

output "get_name"{
    value = aws_lambda_function.get.function_name
}

output "post_name"{
    value = aws_lambda_function.post.function_name
}