variable "bucket_name" {
  type = string
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "kms_key_arn" {
  type = string
}