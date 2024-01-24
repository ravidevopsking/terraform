#using below module mongodb ec2 instance is created, but not configured.
module "mongodb" {
  source                 = "terraform-aws-modules/ec2-instance/aws"  #module from terraform website
  ami = data.aws_ami.centos8.id
  name                   = "${local.ec2_name}-mongodb"
  instance_type          = "t3.small"
  vpc_security_group_ids = [data.aws_ssm_parameter.mongodb_sg_id.value]
  subnet_id              = local.database_subnet_id
  tags = merge(
    var.common_tags,
    {
      Component = "mongodb"
    },
    {
      Name = "${local.ec2_name}-mongodb"
    }
  )
}

#using below module we are configuring mongodb server using bootstrap script in which ansible execute tasks on mongodb server.
#using null resource we are connecting to mongodb server through ssh and using provisioners to run bootstrap or shell script to achieve desired configurations on mongodb server. Bootstrap script has ansible which performs tasks on server to get mongodb configurations on it.
resource "null_resource" "mongodb" {
  # Changes to any instance of the cluster requires re-provisioning
  #it triggeres if there is any change to mongodb
  triggers = {
    instance_id = module.mongodb.id
  }

  # Bootstrap script can run on any instance of the cluster
  # So we just choose the first in this case
  connection {
    host = module.mongodb.private_ip                #mongodb doesnt have public ip as it is in private subnet
    type = "ssh"
    user = "centos"
    password = "DevOps321"
  }
  #copying file from local to remote machine using provisioner file
  provisioner "file" {
    source      = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
  }

  provisioner "remote-exec" {
    # Bootstrap script called with private_ip of each node in the cluster
    inline = [
      "chmod +x /tmp/bootstrap.sh",             #giving execution permissions to script
      "sudo sh /tmp/bootstrap.sh mongodb dev"   #executing bootstrap script
    ]
  }
}

module "redis" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  ami = data.aws_ami.centos8.id
  name                   = "${local.ec2_name}-redis"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.redis_sg_id.value]
  subnet_id              = local.database_subnet_id
  tags = merge(
    var.common_tags,
    {
      Component = "redis"
    },
    {
      Name = "${local.ec2_name}-redis"
    }
  )
}

resource "null_resource" "redis" {
  # Changes to any instance of the cluster requires re-provisioning
  triggers = {
    instance_id = module.redis.id
  }

  # Bootstrap script can run on any instance of the cluster
  # So we just choose the first in this case
  connection {
    host = module.redis.private_ip
    type = "ssh"
    user = "centos"
    password = "DevOps321"
  }

  provisioner "file" {
    source      = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
  }

  provisioner "remote-exec" {
    # Bootstrap script called with private_ip of each node in the cluster
    inline = [
      "chmod +x /tmp/bootstrap.sh",
      "sudo sh /tmp/bootstrap.sh redis dev"
    ]
  }
}

module "mysql" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  ami = data.aws_ami.centos8.id
  name                   = "${local.ec2_name}-mysql"
  instance_type          = "t3.small"
  vpc_security_group_ids = [data.aws_ssm_parameter.mysql_sg_id.value]
  subnet_id              = local.database_subnet_id
  iam_instance_profile = "ShellScriptRoleForRoboshop"
  tags = merge(
    var.common_tags,
    {
      Component = "mysql"
    },
    {
      Name = "${local.ec2_name}-mysql"
    }
  )
}

resource "null_resource" "mysql" {
  # Changes to any instance of the cluster requires re-provisioning
  triggers = {
    instance_id = module.mysql.id
  }

  # Bootstrap script can run on any instance of the cluster
  # So we just choose the first in this case
  connection {
    host = module.mysql.private_ip
    type = "ssh"
    user = "centos"
    password = "DevOps321"
  }

  provisioner "file" {
    source      = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
  }

  provisioner "remote-exec" {
    # Bootstrap script called with private_ip of each node in the cluster
    inline = [
      "chmod +x /tmp/bootstrap.sh",
      "sudo sh /tmp/bootstrap.sh mysql dev"
    ]
  }
}

module "rabbitmq" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  ami = data.aws_ami.centos8.id
  name                   = "${local.ec2_name}-rabbitmq"
  instance_type          = "t3.small"
  vpc_security_group_ids = [data.aws_ssm_parameter.rabbitmq_sg_id.value]
  subnet_id              = local.database_subnet_id
  iam_instance_profile = "ShellScriptRoleForRoboshop"
  tags = merge(
    var.common_tags,
    {
      Component = "rabbitmq"
    },
    {
      Name = "${local.ec2_name}-rabbitmq"
    }
  )
}

resource "null_resource" "rabbitmq" {
  # Changes to any instance of the cluster requires re-provisioning
  triggers = {
    instance_id = module.rabbitmq.id
  }

  # Bootstrap script can run on any instance of the cluster
  # So we just choose the first in this case
  connection {
    host = module.rabbitmq.private_ip
    type = "ssh"
    user = "centos"
    password = "DevOps321"
  }

  provisioner "file" {
    source      = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
  }

  provisioner "remote-exec" {
    # Bootstrap script called with private_ip of each node in the cluster
    inline = [
      "chmod +x /tmp/bootstrap.sh",
      "sudo sh /tmp/bootstrap.sh rabbitmq dev"
    ]
  }
}

#below module is used to create dns records for all databases
module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"

  zone_name = var.zone_name

  records = [
    {
      name    = "mongodb-dev"
      type    = "A"
      ttl     = 1
      records = [
        module.mongodb.private_ip,
      ]
    },
    {
      name    = "redis-dev"
      type    = "A"
      ttl     = 1
      records = [
        module.redis.private_ip,
      ]
    },
    {
      name    = "mysql-dev"
      type    = "A"
      ttl     = 1
      records = [
        module.mysql.private_ip,
      ]
    },
    {
      name    = "rabbitmq-dev"
      type    = "A"
      ttl     = 1
      records = [
        module.rabbitmq.private_ip,
      ]
    },
  ]
}
