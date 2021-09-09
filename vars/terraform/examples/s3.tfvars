s3_buckets = {
  tfs = {
    block_public_access         = true
    bucket_name                 = "demo-dev-use1-tfs"
    enable_versioning           = true
  },
  deploy = {
    block_public_access         = true
    bucket_name                 = "demo-dev-use1-deploy"
    enable_versioning           = false
  }
}
