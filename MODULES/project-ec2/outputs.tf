output "total_output" {
  value = module.project-ec2.total_output.metadata_options["0"].http_tokens
  #from here i am fetching last data from total output metadata_options
}

output "public" {
  value = module.project-ec2.public_ip
}

output "private" {
  value = module.project-ec2.private_ip
}
