output s3_buckets {
  value       = {for k, v in module.s3_buckets : k => v.s3_bucket}
  // map(object)
}

output s3_bucket_policies {
  value       = {for k, v in module.s3_buckets : k => v.s3_bucket_policy}
  // map(object)
}
