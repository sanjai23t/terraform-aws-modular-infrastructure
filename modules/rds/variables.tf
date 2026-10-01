variable "name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "application_security_group_id" {
  type = string
}

variable "kms_key_arn" {
  type = string
}

variable "db_name" {
  type = string
}

variable "username" {
  type = string
}

variable "instance_class" {
  type    = string
  default = "db.t3.micro"
}