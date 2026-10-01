output "transit_gateway_id" {
  value = aws_ec2_transit_gateway.this.id
}

output "requester_attachment_id" {
  value = aws_ec2_transit_gateway_vpc_attachment.requester.id
}

output "accepter_attachment_id" {
  value = aws_ec2_transit_gateway_vpc_attachment.accepter.id
}