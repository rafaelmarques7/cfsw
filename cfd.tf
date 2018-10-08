# Input variables
variable "AWS_PERSONAL_ACCESS_KEY" {}
variable "AWS_PERSONAL_SECRET_KEY" {}

# Configure the provider
provider "aws" {
    access_key = "${var.AWS_PERSONAL_ACCESS_KEY}"
    secret_key = "${var.AWS_PERSONAL_SECRET_KEY}"
    region     = "us-east-1"
}

# add variable to remove circular dependencies
variable "bucket_name" {
    type = "string"
    default = "scf-website"
}

# Configure the IAM policy
# The bucket must be accessible ONLY to OIA, and not to users directly!
data "aws_iam_policy_document" "s3_policy" {
    statement {
        effect = "Allow"
        actions = ["s3:GetObject"]
        resources = [
            "arn:aws:s3:::${var.bucket_name}/*"
        ]
        principals {
            type = "AWS"
            identifiers = ["${aws_cloudfront_origin_access_identity.oia.iam_arn}"] 
        }
    }
}

# Create a bucket
resource "aws_s3_bucket" "a_static_website" {
    bucket = "${var.bucket_name}"
    acl    = "public-read"
    policy = "${data.aws_iam_policy_document.s3_policy.json}"
  
    website {
        index_document = "index.html"
        # change to index for mma-fe
        error_document = "error.html"
    }
}

# Upload index.html
resource "aws_s3_bucket_object" "index_page" {
    bucket  = "${aws_s3_bucket.a_static_website.bucket}" 
    key     = "index.html"
    source  = "index.html"
    # this ACL should be reevaluated. Should the file still be public ???
    acl    = "public-read"
    content_type = "text/html"
}

# Upload error.html
resource "aws_s3_bucket_object" "error_page" {
    bucket  = "${aws_s3_bucket.a_static_website.bucket}" 
    key     = "error.html"
    source  = "error.html"
    # this ACL should be reevaluated. Should the file still be public ???
    acl    = "public-read"                      
    content_type = "text/html"
}

# Create Origin Access Identity
resource "aws_cloudfront_origin_access_identity" "oia" {
    comment = "This resource has only one argument, comment, and it is optional."
}

# Configure the CloudFront distribution
resource "aws_cloudfront_distribution" "cfd" {
    enabled         = true
    is_ipv6_enabled = true
    default_root_object = "index.html"

    origin {
        domain_name      = "${aws_s3_bucket.a_static_website.bucket_regional_domain_name}"
        origin_id        = "${aws_s3_bucket.a_static_website.id}"
      
        s3_origin_config {
            origin_access_identity = "${aws_cloudfront_origin_access_identity.oia.cloudfront_access_identity_path}"
        }
    }

    default_cache_behavior {
        allowed_methods         = ["HEAD", "GET"]
        cached_methods          = ["HEAD", "GET"]
        target_origin_id        = "${aws_s3_bucket.a_static_website.id}"
        viewer_protocol_policy  = "redirect-to-https"
       
        forwarded_values {
            query_string = false
            headers = ["Origin"]
            cookies {
                forward = "none" 
            }
        }
    }

    restrictions {
        geo_restriction {
            restriction_type = "whitelist"
            locations = ["US", "CA", "GB", "DE"]
        }
    }

    viewer_certificate {
        cloudfront_default_certificate = true
    }
}