variable "prefix" {
  type        = string
  description = "prefix for s3 bucket name"
  default = "illanes-iac-lab"
}

variable "region" {
  type        = string
  description = "region where s3 bucket is created"
  default = "eu-central-1"
}
