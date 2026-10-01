variable "ami_id" {
  description = "Amazon Linux AMI ID for ap-south-2"
  type        = string
}

variable "admin_cidr" {
  description = "CIDR allowed for SSH access"
  type        = string
}

variable "bucket_name" {
  description = "Globally unique S3 bucket name"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}