resource "aws_s3_bucket" "default" {
  bucket                      = var.bucket_name
  acl                         = "private"
  tags                        = local.aws_tags
  versioning {
    enabled                   = var.enable_versioning
  }
}

resource "aws_s3_bucket_policy" "default" {
  bucket                      = aws_s3_bucket.default.id
  policy                      = var.bucket_policy
}

resource "aws_s3_bucket_public_access_block" "default" {
  depends_on                  = [aws_s3_bucket_policy.default]
  count                       = var.block_public_access ? 1 : 0
  bucket                      = aws_s3_bucket.default.id

  block_public_acls           = true
  block_public_policy         = true
  ignore_public_acls          = true
  restrict_public_buckets     = true
}
