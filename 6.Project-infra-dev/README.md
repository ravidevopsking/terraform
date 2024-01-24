
Here ALL databases instances are first created using module
ALL databases(mongodb,mysql,redis,rabbitmq) are configured using null resource provisioners.
using provisioners we executed bootstrap script on target host
bootstap script has ansible commands to execute its tasks from ansible roles on target server to achieve desired configurations.
In bootstrap script ansible is using ansible-pull mechanism, where it pulls code from github and execute on target server 
Generally ansible uses push based mechanism.i.e from ansible server i execute commands it push code changes to all hosts in inventory