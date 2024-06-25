Title
Create an Aurora RDS Database in AWS using Terraform

This Terraform configuration creates a VPC with public and private subnets, deploys a bastion host in the public subnet, and provisions an Aurora DB instance in the private subnet with its password managed by AWS Secrets Manager. The password is autogenerated with a length of 16 characters. Each component is encapsulated within its own module for better organization and reuse.