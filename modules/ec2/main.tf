resource "aws_instance" "web_server" {
    ami = "ami-04a8291398335a9ac"
    instance_type = "t3.micro"
    vpc_security_group_ids = [var.web_sg_id]
    subnet_id = var.pub_subnet_id
    associate_public_ip_address = true

    lifecycle {
        create_before_destroy = true
    }
    
    user_data = <<-EOF
        #!/bin/bash
        yum update -y
        yum install -y httpd
        systemctl start httpd
        systemctl enable httpd
        echo "<h1>Hello World from Terraform EC2</h1>" > /var/www/html/index.html
    EOF
    tags = {
        Name = "dev-web-ec2"
    }
}

output "public_dns" {
    value = aws_instance.web_server.public_dns
}