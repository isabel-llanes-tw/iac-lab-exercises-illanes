output "vpc_id" {
  description = "VPC id."
  value       = aws_vpc.iac_lab_vpc.id
}