terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
  backend "remote" {
    organization = "lkcdevteam"

    workspaces {
      name = "lambda-demo"
    }
  }
}

provider "aws" {
  version = ">=3.0"
  region  = "ap-northeast-2"
}

provider "archive" {}

resource "aws_s3_bucket" "lambda-bucket" {
  bucket = "lambda-demo-code-bucket"
  acl    = "private"


  tags = {
    Name        = "sst9696@gmail.com"
    Environment = "Dev"
  }
}

# Archive 

data "archive_file" "init" {
  type        = "zip"
  source_file = "./example/main.js"
  output_path = "./example.zip"
}


# Upload lambda demo to S3 bucket
resource "aws_s3_bucket_object" "object" {
  depends_on = [aws_s3_bucket.lambda-bucket]
  bucket = aws_s3_bucket.lambda-bucket.bucket
  key    = "v${var.code_version}/example.zip"
  source = "./example.zip"
}


output "code_version" {
  value = var.code_version
}
