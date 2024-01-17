module "roboshop" {
  #source = "../terraform-aws-vpc"  #below code is taking from github, change it as per ur code
  source = "git::https://github.com/daws-76s/terraform-aws-vpc.git?ref=main"
  project_name = var.project_name
  environment = var.environment
  common_tags = var.common_tags
  vpc_tags = var.vpc_tags

  # public subnet
  public_subnets_cidr = var.public_subnets_cidr

  # private subnet
  private_subnets_cidr = var.private_subnets_cidr

  # database subnet
  database_subnets_cidr = var.database_subnets_cidr

  #peering
  is_peering_required = var.is_peering_required

}

#Note: In modules we need to call required variables, tags & outputs as it fetches the information and pass to module from already declared variables.tf,outputs.tf
