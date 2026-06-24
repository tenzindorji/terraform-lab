resource "aws_security_group" "web_sg" {
    vpc_id =  var.vpc_id
    name = "${var.environment}-web_sg"
    description = "web security group"

}


resource "aws_vpc_security_group_ingress_rule" "web_inbound" {
    for_each = var.allowed_ports
    security_group_id = aws_security_group.web_sg.id

    ip_protocol = "tcp"
    from_port = each.value 
    to_port = each.value
    cidr_ipv4 = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "web_outbound"  {
    for_each = var.allowed_ports
    security_group_id = aws_security_group.web_sg.id

    ip_protocol = "tcp"
    from_port = each.value
    to_port = each.value

    cidr_ipv4 = "0.0.0.0/0"
}