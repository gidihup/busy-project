resource "aws_vpc" "app-vpc" {
    cidr_block = "10.0.0.0/16"
    enable_dns_support = "true"
    enable_dns_hostnames = "true"
    instance_tenancy = "default"

    tags = {
        Name = "app-vpc"
    }
}

resource "aws_subnet" "public-1" {
    vpc_id = aws_vpc.app-vpc.id
    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = "true" //it makes this a public subnet
    availability_zone = "us-east-2a"

    tags = {
        Name = "public-1"
    }
}

resource "aws_subnet" "public-2" {
    vpc_id = aws_vpc.app-vpc.id
    cidr_block = "10.0.2.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "us-east-2b"

    tags = {
        Name = "public-2"
    }
}

resource "aws_subnet" "private-1" {
    vpc_id = aws_vpc.app-vpc.id
    cidr_block = "10.0.101.0/24"
    availability_zone = "us-east-2a"

    tags = {
        Name = "private-1"
    }
}

resource "aws_subnet" "private-2" {
    vpc_id = aws_vpc.app-vpc.id
    cidr_block = "10.0.102.0/24"
    availability_zone = "us-east-2b"

    tags = {
        Name = "private-2"
    }
}

# Create an IGW (Internet Gateway)
resource "aws_internet_gateway" "app-igw" {
    vpc_id = aws_vpc.app-vpc.id
    tags = {
        Name = "app-igw"
    }
}

# Create route to the internet for public subnets
resource "aws_route_table" "app-public-rt" {
    vpc_id = aws_vpc.app-vpc.id
    route {
        cidr_block = "0.0.0.0/0" //associated subnet can reach everywhere
        gateway_id = aws_internet_gateway.app-igw.id //CRT uses this IGW to reach internet
    }

    tags = {
        Name = "app-public-rt"
    }
}

# route table association for the public subnets
resource "aws_route_table_association" "prod-crta-public-subnet-1" {
    subnet_id = aws_subnet.public-1.id
    route_table_id = aws_route_table.app-public-rt.id
}

resource "aws_route_table_association" "prod-crta-public-subnet-2" {
    subnet_id = aws_subnet.public-2.id
    route_table_id = aws_route_table.app-public-rt.id
}