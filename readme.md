I need you to create the following Modules:
- Terraform module to create a VPC
- Terraform module to create an API Gateway
- Terraform module to create a Lambda Function
- Terraform module to create a DynamoDB Table
- A 'Root' terraform template from where you are going to invoke the rest of the modules.About the exercise:
You will develop an infrastructure to host a backend application. The logic of your application will be developed on Lambda, you can use the language that you feel more comfortable with.
To store the data, we'll use a DynamoDB table to allocate your data, you can store any kind of information that you want, but be sure to set a 'partition key'. The Lambda functions will reach
 DynamoDB table through the internal network and write and read records. To expose these lambdas to the internet, we'll use API-Gateway to generate an endpoint and parse the HTTP request to forward
 the traffic to the lambdas functions.Notes:
You must create two HTTP methods (GET and POST).
For each HTTP method, you must create a single lambda which will process the request and return a result.
Store the data that you want, there is no restriction for that.