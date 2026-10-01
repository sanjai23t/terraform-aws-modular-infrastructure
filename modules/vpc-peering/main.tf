resource "aws_vpc_peering_connection" "this" {
  vpc_id      = var.requester_vpc_id
  peer_vpc_id = var.accepter_vpc_id
  auto_accept = true

  tags = {
    Name = var.name
  }
}

resource "aws_route" "requester" {
  for_each = {
    for index, route_table_id in var.requester_route_table_ids :
    index => route_table_id
  }

  route_table_id            = each.value
  destination_cidr_block    = var.accepter_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.this.id
}

resource "aws_route" "accepter" {
  for_each = {
    for index, route_table_id in var.accepter_route_table_ids :
    index => route_table_id
  }

  route_table_id            = each.value
  destination_cidr_block    = var.requester_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.this.id
}