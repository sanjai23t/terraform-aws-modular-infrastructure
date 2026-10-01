resource "aws_ec2_transit_gateway" "this" {
  description = var.name

  default_route_table_association = "enable"
  default_route_table_propagation = "enable"

  tags = {
    Name = var.name
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "requester" {
  transit_gateway_id = aws_ec2_transit_gateway.this.id
  vpc_id             = var.requester_vpc_id
  subnet_ids         = var.requester_subnet_ids

  tags = {
    Name = "${var.name}-requester"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "accepter" {
  transit_gateway_id = aws_ec2_transit_gateway.this.id
  vpc_id             = var.accepter_vpc_id
  subnet_ids         = var.accepter_subnet_ids

  tags = {
    Name = "${var.name}-accepter"
  }
}

resource "aws_route" "requester_to_accepter" {
  route_table_id         = var.requester_route_table_id
  destination_cidr_block = var.accepter_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.this.id

  depends_on = [
    aws_ec2_transit_gateway_vpc_attachment.requester,
    aws_ec2_transit_gateway_vpc_attachment.accepter
  ]
}

resource "aws_route" "accepter_to_requester" {
  route_table_id         = var.accepter_route_table_id
  destination_cidr_block = var.requester_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.this.id

  depends_on = [
    aws_ec2_transit_gateway_vpc_attachment.requester,
    aws_ec2_transit_gateway_vpc_attachment.accepter
  ]
}