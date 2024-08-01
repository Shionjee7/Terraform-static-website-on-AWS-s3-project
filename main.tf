#create s3 bucket 

resource "aws_s3_bucket" "mybucket" {
  bucket = var.bucketname

}

resource "aws_s3_bucket_ownership_controls" "example" {
  bucket = aws_s3_bucket.mybucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}


resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.mybucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "example" {
  depends_on = [
    aws_s3_bucket_ownership_controls.example,
    aws_s3_bucket_public_access_block.example,
  ]

  bucket = aws_s3_bucket.mybucket.id
  acl    = "public-read"
}


#adding html file to s3 bucket

resource "aws_s3_object" "index" {
  bucket = aws_s3_bucket.mybucket.id
  key    = "index.html" #file name
  source = "index.html" # path
  acl = "public-read" #access control list
  content_type = "text/html"
}


resource "aws_s3_object" "error" {
  bucket = aws_s3_bucket.mybucket.id
  key    = "error.html" #file name
  source = "error.html" # path
  acl = "public-read" #access control list
  content_type = "text/html"
}

resource "aws_s3_object" "Profile" {
  bucket = aws_s3_bucket.mybucket.id
  key    = "Profile.jpeg"
  source ="Profile.jpeg"
  acl = "public-read"
}


resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.mybucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }


}