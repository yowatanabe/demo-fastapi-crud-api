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

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name        = "demo-app-igw"
    Environment = "demo"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name        = "demo-app-public-rtb"
    Environment = "demo"
  }
}

resource "aws_route_table" "private_1a" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name        = "demo-app-private1a-rtb"
    Environment = "demo"
  }
}

resource "aws_route_table" "private_1c" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name        = "demo-app-private1c-rtb"
    Environment = "demo"
  }
}

resource "aws_route" "public" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.public.id
  gateway_id             = aws_internet_gateway.internet_gateway.id
}

resource "aws_route_table_association" "public_1a" {
  subnet_id      = aws_subnet.public_1a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_1c" {
  subnet_id      = aws_subnet.public_1c.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private_1a" {
  subnet_id      = aws_subnet.private_1a.id
  route_table_id = aws_route_table.private_1a.id
}

resource "aws_route_table_association" "private_1c" {
  subnet_id      = aws_subnet.private_1c.id
  route_table_id = aws_route_table.private_1c.id
}

resource "aws_security_group" "db_security_group" {
  description = "SecurityGroup for DB"
  name        = "demo-app-db-sg"
  tags = {
    Name        = "demo-app-db-sg"
    Environment = "demo"
  }
  vpc_id = aws_vpc.vpc.id
  ingress {
    cidr_blocks = [
      "${aws_vpc.vpc.cidr_block}"
    ]
    from_port = 3306
    protocol  = "tcp"
    to_port   = 3306
  }
  egress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 0
    protocol  = "-1"
    to_port   = 0
  }
}

resource "aws_ecr_repository" "demo_app_repository" {
  name         = "demo-app"
  force_delete = true

  image_scanning_configuration {
    scan_on_push = true
  }
}

variable "db_password" {
  type      = string
  sensitive = true
}

resource "aws_db_instance" "demo_app_db_instance" {
  identifier                          = "demo-app-db"
  allocated_storage                   = 20
  instance_class                      = "db.t3.micro"
  engine                              = "mysql"
  username                            = "admin"
  password                            = var.db_password
  backup_window                       = "20:00-22:00"
  backup_retention_period             = 7
  availability_zone                   = "ap-northeast-1a"
  maintenance_window                  = "sun:22:00-sun:22:30"
  multi_az                            = false
  engine_version                      = "8.0.32"
  auto_minor_version_upgrade          = false
  license_model                       = "general-public-license"
  publicly_accessible                 = false
  storage_type                        = "gp2"
  port                                = 3306
  storage_encrypted                   = false
  copy_tags_to_snapshot               = true
  iam_database_authentication_enabled = false
  deletion_protection                 = false
  db_subnet_group_name                = aws_db_subnet_group.demo_app_db_subnet_group.name
  vpc_security_group_ids = [
    "${aws_security_group.db_security_group.id}"
  ]
  max_allocated_storage = 1000
  skip_final_snapshot   = true
  tags = {
    Name        = "demo-app-db"
    Environment = "demo"
  }
}

resource "aws_db_subnet_group" "demo_app_db_subnet_group" {
  description = "demo app db subnetgroup"
  name        = "demo-app-db-subnetgroup"
  subnet_ids = [
    "${aws_subnet.private_1a.id}",
    "${aws_subnet.private_1c.id}"
  ]
}
