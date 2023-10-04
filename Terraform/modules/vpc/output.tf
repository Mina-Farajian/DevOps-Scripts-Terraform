output "vpc_id" {
  value = aws_vpc.vpc.id
}
output "public_subnet_ids" {
  value = aws_subnet.public_subnet.*.id
}
output "private_subnet_ids" {
  value = aws_subnet.private_subnet.*.id
}
output "default_sg_id" {
  value = aws_security_group.default.id
}
output "default_vpc_sg_id" {
  /*
  This is the original default security group created by AWS when the VPC was created.
  */
  value = aws_vpc.vpc.default_security_group_id
}
output "security_group_ids" {
  value = aws_security_group.default.id
}
output "private_route_table_id" {
  value = aws_route_table.private.id
}
output "public_route_table_id" {
  value = aws_route_table.public.id
}
