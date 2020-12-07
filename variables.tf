variable "aws_access_key" {
  description = "aws access key for aws access"
}
variable "aws_secret_key" {
  description = "aws secret access key for aws access"
}
variable "aws_region" {
  type = string
  description = "The region name want to deploy the VPC."
}
variable "vpc_name" {
  description = "name for vpc "
}
variable "vpc_cidr" {
  description = "cidr block range for vpc"
}
variable "azs" {
  description = "avaliability zone name to create a subnet"
  default = "us-east-1a"
}

variable "IGW_name" {
  description = "internet gateway to access the internet from the instance"
}
variable "public_subnet_cidr" {
  description = "cidr block range for public subnet"
}

variable "ami" {
  description = "amazon machine image id for creating instance"
}
variable "instancetype" {
  description = "type of instance that we wanted to create"
}
variable "keyname" {
  description = "provide the keyname to access the instace later using that key"
}

