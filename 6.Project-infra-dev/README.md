
Here ALL databases instances are first created using module
ALL databases(mongodb,mysql,redis,rabbitmq) are configured using null resource provisioners.
using provisioners we executed bootstrap script on target host
bootstap script has ansible commands to execute its tasks from ansible roles on target server to achieve desired configurations.
In bootstrap script ansible is using ansible-pull mechanism, where it pulls code from github and execute on target server 
Generally ansible uses push based mechanism.i.e from ansible server i execute commands it push code changes to all hosts in inventory
###########################################

#ports:
#components(catalogue,user,web..) to vpn connection using port : 22
#web instance/public component to outside internet using port : 80
#component to componet connection (not recommended), but if i want to use without vpn then port : 8080
#component to application load balancer connection (recommended) using port: 8080

##############################################


READ 06.CATALOGUE/main.tf  and 09.WEB/main.tf   for provisioning servers and configuring for every updation/release in VM BASED APPROACH.
i.e rolling upgrades to existing servers