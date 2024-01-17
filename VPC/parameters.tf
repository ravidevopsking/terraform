resource "aws_ssm_parameter" "vpc_id" {
    name = "/${var.project_name}/${var.environment}/vpc_id"
    type = "String"
    value = module.roboshop.vpc_id
}

resource "aws_ssm_parameter" "public_subnet_ids" {
    name = "/${var.project_name}/${var.environment}/public_subnet_ids"
    type = "StringList"
    value = join(",", module.roboshop.public_subnet_ids)
}

resource "aws_ssm_parameter" "private_subnet_ids" {
    name = "/${var.project_name}/${var.environment}/private_subnet_ids"
    type = "StringList"
    value = join(",", module.roboshop.private_subnet_ids)
}

resource "aws_ssm_parameter" "database_subnet_ids" {
    name = "/${var.project_name}/${var.environment}/database_subnet_ids"
    type = "StringList"
    value = join(",", module.roboshop.database_subnet_ids)
}




#1.subnet_ids are stringList type
#2. module.roboshop.public_subnet_ids are list type 
#3.join(",", ["foo","bar"])
#A) foo, bar



# output "public_subnet_ids" {
#   value = module.roboshop.public_subnet_ids
# }
