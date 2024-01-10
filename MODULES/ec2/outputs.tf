output "total_output" {
    value = aws_instance.ec2
    #fetches all the information
}

output "public_ip" {
  value = aws_instance.ec2.public_ip
  #fetches only public ip
}

output "private_ip" {
  value = aws_instance.ec2.private_ip
}

output "instance_id" {
  value = aws_instance.ec2.id
}
