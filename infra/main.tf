terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.4.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-1"
}

resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  instance_tenancy     = "default"
  tags = {
    Name        = "demo-app-vpc"
    Environment = "demo"
  }
}

resource "aws_subnet" "public_1a" {
  availability_zone       = "ap-northeast-1a"
  cidr_block              = "10.0.0.0/24"
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = false
  tags = {
    Name        = "demo-app-public1a-sub"
    Environment = "demo"
  }
}

resource "aws_subnet" "public_1c" {
  availability_zone       = "ap-northeast-1c"
  cidr_block              = "10.0.1.0/24"
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = false
  tags = {
    Name        = "demo-app-public1c-sub"
    Environment = "demo"
  }
}

resource "aws_subnet" "private_1a" {
  availability_zone       = "ap-northeast-1a"
  cidr_block              = "10.0.2.0/24"
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = false
  tags = {
    Name        = "demo-app-private1a-sub"
    Environment = "demo"
  }
}

resource "aws_subnet" "private_1c" {
  availability_zone       = "ap-northeast-1c"
  cidr_block              = "10.0.3.0/24"
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = false
  tags = {
    Name        = "demo-app-private1c-sub"
    Environment = "demo"
  }
}
