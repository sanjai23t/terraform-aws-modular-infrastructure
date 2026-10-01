output "alb_dns_name" {
  value = aws_lb.this.dns_name
}

output "security_group_id" {
  value = aws_security_group.this.id
}

output "alb_arn" {
  value = aws_lb.this.arn
}