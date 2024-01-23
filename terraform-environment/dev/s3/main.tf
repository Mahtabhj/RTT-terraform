resource "aws_s3_bucket" "my_s3_bucket" {
  bucket = "my-unique-s3-bucket-name"
  acl    = "private"

  tags = {
    Name = "MyS3Bucket"
  }
}

resource "aws_s3_bucket_policy" "my_s3_bucket_policy" {
  bucket = aws_s3_bucket.my_s3_bucket.bucket
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = "*",
      Action    = ["s3:GetObject"],
      Resource = [
        "${aws_s3_bucket.my_s3_bucket.arn}/*",
      ],
    }],
  })
}
