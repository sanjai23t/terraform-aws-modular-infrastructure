variable "role_name" {
  type = string
}

variable "policy_arns" {
  type = list(string)

  default = [
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ]
}