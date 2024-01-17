This is demo ec2 module, based on we develop vpc,sg,vpn,many modules
EC2-Module
Inputs:
ami (Optional): AMI ID is optional. Default ami is ami-03265a0778a880afb which is from centos8.

instance_type(Optional): default value is t2.micro
tags (Optional): default value is empty.
Note: whenever we mention default values, automatically terraform picks default values, so inputs became optional.
      If we doesn't pass default values then inputs are required to pass.

Outputs:
public_ip: public_ip of the instance
private_ip: private_ip of the instance
id: instance id of the instance


Under Modules we have two directories, one is ec2 (where ec2 code is taken/written from cloud admin team)
another is project-ec2 is user defined as per project, where ec2 module is written and fetches path from above ec2 code.
Folder structure is same for both directories.But project-ec2 folder variables will overwrite the ec2 folder variables.
If variables/outputs are not mention in project-ec2, then ec2 default variable/output values only it takes.

#Note: In modules we need to call required variables, tags & outputs as it fetches the information and pass to module from already declared variables.tf,outputs.tf