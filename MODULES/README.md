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
