output "pub_subnet_ids" {
    value = aws_subnet.pub_subnet[*].id
}