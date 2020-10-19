
resource "aws_dynamodb_table" "main" {
  name           = "FantasticDatabase"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "Username"
  range_key      = "GovtName"

  attribute {
    name = "Username"
    type = "S"
  }

  attribute {
    name = "GovtName"
    type = "S"
  }



  tags = {
    Name        = "dynamodb-table-1"
    Engineer    = var.engineer 
  }
}