
output "vpc_id" {
  description = "ID of the created VPC"
  value       = module.network.vpc_id
}

output "public_subnet_a_id" {
  description = "ID of public subnet A"
  value       = module.network.public_subnet_a_id
}

output "public_subnet_b_id" {
  description = "ID of public subnet B"
  value       = module.network.public_subnet_b_id
}

output "security_group_id" {
  description = "ID of the EC2 security group"
  value       = module.security_group.security_group_id
}

output "ec2_instance_id" {
  description = "ID of the EC2 instance"
  value       = module.ec2.instance_id
}

output "ec2_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = module.ec2.instance_public_ip
}

output "ec2_private_ip" {
  description = "Private IP address of the EC2 instance"
  value       = module.ec2.instance_private_ip
}
