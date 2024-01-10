module "project-ec2"{
    source = "../ec2" #previous directory 
    instance_type = var.instance_type
    tags = var.tags
}