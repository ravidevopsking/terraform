
Here ALL databases instances are first created using module
ALL databases(mongodb,mysql,redis,rabbitmq) are configured using null resource provisioners.
using provisioners we executed bootstrap script on target host
bootstap script has ansible commands to execute its tasks from ansible roles on target server to achieve desired configurations.