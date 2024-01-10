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
whatever variables mention in project-ec2 will be overwriten otherwise ec2 default values only it takes.