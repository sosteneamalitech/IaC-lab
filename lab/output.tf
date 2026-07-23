output "ec2_instance_id" {
  value = aws_instance.iac_lab_instance.id
}
output "ec2_instance_public_ip" {
  value = aws_instance.iac_lab_instance.public_ip
}
output "vpc_id" {
  value = aws_vpc.main.id
}
output "public_subnet_id" {
  value = aws_subnet.public_subnet.id
}
output "security_group_id" {
  value = aws_security_group.sg.id
}