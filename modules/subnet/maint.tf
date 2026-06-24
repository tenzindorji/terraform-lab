
data "aws_availability_zones" "az" {}

resource "aws_subnet" "pub_subnet" {
    count = 3
    vpc_id = var.vpc_id
    cidr_block = "10.0.${count.index + 1}.0/24"
    availability_zone = data.aws_availability_zones.az.names[count.index]
    map_public_ip_on_launch = true
    tags = {
        Name = "${var.environment}-pub_subnet-${count.index + 1}"
    }

}

resource "aws_internet_gateway" "igw" {
    vpc_id = var.vpc_id
    tags = {
        Name = "${var.environment}-igw"
    }
}

resource "aws_route_table" "public_rt" {
    vpc_id = var.vpc_id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id 
    }
    tags = {
        Name = "${var.environment}-pub_rt"
    }
}

resource "aws_route_table_association" "public" {
    count = length(aws_subnet.pub_subnet)
    subnet_id = aws_subnet.pub_subnet[count.index].id
    route_table_id = aws_route_table.public_rt.id
    depends_on = [
        aws_route_table.public_rt
    ]
}

