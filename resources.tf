resource "aws_s3_bucket" "website" {
  bucket = var.website_bucket_name
  acl    = "public-read"
  policy = data.aws_iam_policy_document.public_read.json
  force_destroy = true #make it possible to delete s3 even is not empty


  # cors_rule {
  #   allowed_headers = ["*"]
  #   allowed_methods = ["PUT","POST"]
  #   allowed_origins = ["*"]
  #   expose_headers = ["ETag"]
  #   max_age_seconds = 3000
  # }

  website {
    index_document = "index.html"
    error_document = "index.html"
  }
}


data "aws_iam_policy_document" "public_read" {
  statement {
    actions = [
      "s3:GetObject"
    ]
    principals {
      identifiers = ["*"]
      type = "AWS"
    }
    resources = [
      "arn:aws:s3:::${var.website_bucket_name}/*"
    ]
  }
}


resource "aws_s3_bucket_object" "dist" {
  
  for_each = fileset("./dist/", "*")

  bucket = aws_s3_bucket.website.bucket
  key    = each.value
  source = "./dist/${each.value}"
  etag   = filemd5("./dist/${each.value}")
}

## NB files content type of the website files could make a problem
## in that case comment the automated upload upload your dist content manually to the ## s3 created bucket

resource "aws_s3_bucket_object" "index" {

  depends_on = [
    aws_s3_bucket_object.dist
  ]

  bucket = aws_s3_bucket.website.bucket
  key = "index.html"
  source = "./dist/index.html"

  content_type = "text/html" #prevent file to be downloaded by the browser instead of displaying
}



############# Redirect Bucket#################
# resource "aws_s3_bucket" "www" {
#   bucket = "www.${var.website_bucket_name}"
#   acl    = "private"
#   policy = ""

#   website {
#     redirect_all_requests_to = "https://${var.website_bucket_name}"
#   }
# }