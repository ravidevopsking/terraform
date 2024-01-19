In ec2.tf or main.tf
while creating resource like ec2 and rout53 records from modules source path is taking from terraform official website .
so there is no separate folder for code of ec2 .

i.e we have project-vpc and vpc, project-sg and sg for aws folder structures
where resource code is mention in vpc and sg folders
module blocks for resource creation are mentioned in project-vpc and project-sg.

But In EC2 there is no resource code folder, so directly using refering from terraform website "terraform-aws-modules/ec2-instance/aws"
