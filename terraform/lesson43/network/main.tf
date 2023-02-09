data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  az_count    = length(data.aws_availability_zones.available.names)
  subnet_type = ["public_front_net", "private_back_net", "private_db_net"]
  bits        = ceil(log(local.az_count * length(local.subnet_type), 2))

  subnets_cidr_blocks = {
    for i, name in local.subnet_type :
    "${name}" => [
      for subnet_num in range(i * local.az_count, (i + 1) * local.az_count) :
      cidrsubnet(var.cidr_block, local.bits, subnet_num)
    ]
  }
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "vlm-vpc"
  cidr = var.cidr_block

  azs              = data.aws_availability_zones.available.names
  private_subnets  = local.subnets_cidr_blocks.private_back_net
  public_subnets   = local.subnets_cidr_blocks.public_front_net
  database_subnets = local.subnets_cidr_blocks.private_db_net

  create_igw         = true
  enable_nat_gateway = true
  single_nat_gateway = true

  tags = {
    Terraform   = "true"
    Environment = "test"
  }
}
