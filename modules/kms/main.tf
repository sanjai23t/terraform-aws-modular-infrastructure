resource "aws_kms_key" "this" {
  description         = var.description
  enable_key_rotation = true
  deletion_window_in_days = 7

  tags = {
    Name = var.alias_name
  }
}

resource "aws_kms_alias" "this" {
  name          = "alias/${var.alias_name}"
  target_key_id = aws_kms_key.this.key_id
}