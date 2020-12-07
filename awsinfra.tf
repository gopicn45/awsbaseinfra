#This Terraform Code Deploys Basic aws Infra which consists of vpc subnets route table security group and one instance

provider "aws" {
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
    region = "${var.aws_region}"
}
resource "aws_vpc" "test-vpc" {
    cidr_block = "${var.vpc_cidr}"
    enable_dns_hostnames = true
    tags = {
        Name = "${var.vpc_name}"
    }
}
resource "aws_internet_gateway" "test-gateway" {
    vpc_id = "${aws_vpc.test-vpc.id}"
	tags = {
        Name = "${var.IGW_name}"
    }
}
resource "aws_subnet" "public-subnet" {
    vpc_id = "${aws_vpc.test-vpc.id}"
    cidr_block = "${var.public_subnet_cidr}"
    availability_zone = "${var.azs}"

    tags = {
        Name = "${aws_vpc.test-vpc.tags.Name}-public-subnet"
    }
} 
resource "aws_route_table" "main-rt" {
    vpc_id = "${aws_vpc.test-vpc.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.test-gateway.id}"
    }

    tags = {
        Name = "${aws_vpc.test-vpc.tags.Name}-route-table"
    }
}
resource "aws_route_table_association" "routetableassociation" {
    subnet_id = "${aws_subnet.public-subnet.id}"
    route_table_id = "${aws_route_table.main-rt.id}"
}

resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Allow all inbound traffic"
  vpc_id      = "${aws_vpc.test-vpc.id}"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    }
}

resource "aws_instance" "test-instance" {
    ami = "${var.ami}"
    instance_type = "${var.instancetype}"
    key_name = "${var.keyname}"
    subnet_id = "${aws_subnet.public-subnet.id}"
    vpc_security_group_ids = ["${aws_security_group.allow_all.id}"]
    associate_public_ip_address = true	
    tags = {
        Name = "Test-serve"
    }
}