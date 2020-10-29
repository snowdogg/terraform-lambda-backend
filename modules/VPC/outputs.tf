

output "igw" {
  value = aws_internet_gateway.main.id
}


output "private_subnet1" {
  value = aws_subnet.private_subnet1.id
}

output "private_subnet2" {
  value = aws_subnet.private_subnet2.id
}

output "security_group" {
  value = aws_security_group.main.id
}