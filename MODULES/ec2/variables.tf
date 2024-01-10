variable "ami" {
    default = "ami-03265a0778a880afb"
    type = string
}

variable "instance_type" {

    default = "t2.micro"
    type = string

}

variable "tags" {
  default = {
    Name = "ec2"
  }
  type = map
}
