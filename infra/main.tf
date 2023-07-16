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
