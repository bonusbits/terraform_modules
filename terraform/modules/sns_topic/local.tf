locals {
  aws_tags                      = merge(
    var.base_aws_tags,
    {
      Name                      = local.name
      Terraform_Module          = "sns_topic"
    }
  )

  delivery_policy               = templatefile(
    "${path.module}/templates/delivery_policy.json.tmpl",
    {
      minDelayTarget                = tonumber(var.tf_vars.sns_topic.minDelayTarget)
      maxDelayTarget                = tonumber(var.tf_vars.sns_topic.maxDelayTarget)
      numRetries                    = tonumber(var.tf_vars.sns_topic.numRetries)
      numMaxDelayRetries            = tonumber(var.tf_vars.sns_topic.numMaxDelayRetries)
      numNoDelayRetries             = tonumber(var.tf_vars.sns_topic.numNoDelayRetries)
      numMinDelayRetries            = tonumber(var.tf_vars.sns_topic.numMinDelayRetries)
      backoffFunction               = var.tf_vars.sns_topic.backoffFunction
      disableSubscriptionOverrides  = tobool(var.tf_vars.sns_topic.disableSubscriptionOverrides)
      maxReceivesPerSecond          = tonumber(var.tf_vars.sns_topic.maxReceivesPerSecond)
    }
  )
}
