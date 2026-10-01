output "app_vpc_id" {
  value = module.app_vpc.vpc_id
}

output "ec2_instance_id" {
  value = module.ec2.instance_id
}

output "ec2_public_ip" {
  value = module.ec2.public_ip
}

output "alb_dns_name" {
  value = module.alb.alb_dns_name
}

output "rds_endpoint" {
  value = module.rds.db_endpoint
}

output "efs_id" {
  value = module.efs.file_system_id
}

output "s3_bucket_name" {
  value = module.s3.bucket_name
}

output "transit_gateway_id" {
  value = module.transit_gateway.transit_gateway_id
}

output "vpc_peering_id" {
  value = module.vpc_peering.peering_id
}

output "kms_key_arn" {
  value = module.kms.key_arn
}