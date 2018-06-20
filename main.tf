data "aws_region" "default" {}
data "aws_caller_identity" "default" {}

locals {
  region     = "${ var.region == "" ? data.aws_region.default.name : var.region}"
  account_id = "${var.account_id == "" ? data.aws_caller_identity.default.account_id : var.account_id}"

  # Normalise the parameter name, and remove any duplicate slashes
  parameter_root_name = "${join("/",compact(split("/", var.parameter_root_name)))}"

  # If no KMS arn supplied, allow access to any KMS 
  kms_key = "${var.kms_key == "" ? "*" : var.kms_key }"
}

data "aws_iam_policy_document" "read_parameter_store" {
  statement {
    actions   = ["ssm:GetParameters", "ssm:GetParameter", "ssm:GetParameterHistory", "ssm:GetParametersByPath"]
    resources = ["arn:aws:ssm:${local.region}:${local.account_id}:parameter/${local.parameter_root_name}*"]
  }
}

data "aws_iam_policy_document" "write_parameter_store" {
  statement {
    actions   = ["ssm:PutParameters", "ssm:PutParameter"]
    resources = ["arn:aws:ssm:${local.region}:${local.account_id}:parameter/${local.parameter_root_name}*"]
  }
}

data "aws_iam_policy_document" "manage_parameter_store" {
  statement {
    actions = [
      "ssm:PutParameters",
      "ssm:PutParameter",
      "ssm:DeleteParameter",
      "ssm:DeleteParameters",
      "ssm:GetParameters",
      "ssm:GetParameter",
      "ssm:GetParameterHistory",
      "ssm:GetParametersByPath",
    ]

    resources = ["arn:aws:ssm:${local.region}:${local.account_id}:parameter/${local.parameter_root_name}*"]
  }
}

data "aws_iam_policy_document" "put_xray_trace" {
  statement {
    actions   = ["xray:PutTraceSegments", "xray:PutTelemetryRecords"]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "manage_kms_store" {
  statement {
    actions = [
      "kms:ListKeys",
      "kms:ListAliases",
      "kms:Describe*",
      "kms:Decrypt",
    ]

    resources = [
      "${local.kms_key}",
    ]
  }
}
