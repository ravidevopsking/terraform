variable "instance_type" {
    default = "t2.micro"
}

variable "tags" {
    default = {
        Name = "project-ec2"
        terraform = "true"
        environment = "dev"
    }
  
}