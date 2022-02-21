provider "aws" {
   region = "us-east-1"
}

resource "aws_s3_bucket" "my-bucket-test-for-upload" {
  bucket = "my-bucket-test-for-upload"

  tags = {
    Name        = "Bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_acl" "acl_bucket_v1" {
  bucket = aws_s3_bucket.my-bucket-test-for-upload.id
  acl    = "private"
}


resource "aws_s3_bucket" "my-bucket-test" {
  bucket = "my-bucket-test-01020304"

  tags = {
    Name        = "Bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_acl" "acl_bucket_v2" {
  bucket = aws_s3_bucket.my-bucket-test.id
  acl    = "private"
}
