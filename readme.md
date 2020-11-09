# Serverless API using Lambda and DynamoDB

Terraform template to create an AWS API Gateway taht accepts GET and POST requests to trigger one of two Lambda functions to update or access a small NoSQL AWS DynamoDB Database.

## Installation and Setup

[Download and Install Terraform](https://www.terraform.io/downloads.html)

[Download and Install AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)
After you have installed AWS CLI, use your terminal to configure your AWS credentials: 
```bash
aws configure
```

## Managing Terraform Backend

If you are using this project independently, please either **comment out the terraform block** that begins on line 5 of serverless.tf, or **change the bucket parameter** to reference an S3 bucket that you have access to with your AWS credentials. 

## Usage

```bash
terraform init
terraform apply
```

Follow the prompts from these commands and as long as you have the correct permissions on your AWS credentials, the environment should launch successfully. 

## How to Interact with API

Using the AWS Console, navigate to the API Gateway service. Try this sample data to test the Create User function: 

```JSON
{
    "body": {"Username":"snowdogg","GovtName":"Andreas Cary"}
}
```

There is no data required to test the Get User function. Just use the test feature after adding the above data to the database and it should return your new database entry.

## What Does This Template Create?

### VPC Module

Creates a VPC with 2 public and 2 private subnets, an internet gateway and a nat gateway. 

### Lambda Module

Creates two lambda functions: one to create an entry in the database and one to fetch all the entries in the database. These lambda functions can exist across the two private subnets for high availability.

### DynamoDB Module

Master key is Username, sort key is GovtName. 
Example entry: Username: "snowdogg", GovtName: "Andreas Cary"

### API Module

Creates an API Gateway which receives GET requests and forwards them to the Get Users lambda function, and also receives POST requests and forwards them to the Create User lambda function.

![wireframe](/wireframe.jpeg)