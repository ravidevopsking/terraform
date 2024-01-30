VM BASED rolling updates, generally in legacy applications we use this approach
#1.After any changes to catalogue instance, we want to update it in next version/release in VM based approach.
#2.create new catalogue instance, apply all new sprint configurations using ansible
#3.stop the instance and take the latest created ami
#4.Delete the instance
#5.create launch template using above latest ami
#6.using autoscaling group launch template, update the existing catalouge servers using rolling strategy update
i.e one by one old catalogue instance terminates, and new catalougue instance created using launch template.
nothing but old servers are rolling updated(replaced) with new version/release catalouge servers in VM based approach,
it is not a containarisation approach