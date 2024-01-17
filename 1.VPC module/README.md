#this module is for reference purpose, practice from 2.vpc for aws

1.In modules we need to call required variables, tags & outputs as it fetches the information and pass to module from already declared variables.tf,outputs.tf

2.module code is kept in main.tf file

3.In parameters.tf file we store values, configurations.For creating data,secrets,passwords we use SSM Parameter store

4.For querying or reading data i.e created in SSM parameter store we use datasource.
