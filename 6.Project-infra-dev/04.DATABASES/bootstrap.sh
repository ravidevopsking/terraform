#!/bin/bash
component=$1
environment=$2 #dont use "env" here, it is reserved in linux. so using "environment"
yum install python3.11-devel python3.11-pip -y
pip3.11 install ansible botocore boto3
ansible-pull -U https://github.com/ravidevopsking/roboshop-ansible-roles-tf.git -e component=$component -e env=$environment main-tf.yaml
#ansible is using ansible-pull mechanism, where it pulls code from github and execute on target server 
#Generally ansible uses push based mechanism.i.e from ansible server i execute commands it push code changes/ perform tasks to all hosts in inventory

