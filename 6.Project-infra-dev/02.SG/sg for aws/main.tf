resource "aws_security_group" "allow_tls" {
    name        = "${var.project_name}-${var.environment}-${var.sg_name}"
    description = var.sg_description
    vpc_id = var.vpc_id

    dynamic ingress {
        for_each = var.sg_ingress_rules
        content {
          description      = ingress.value["description"]
          from_port        = ingress.value["from_port"]
          to_port          = ingress.value["to_port"]
          protocol         = ingress.value["protocol"]
          cidr_blocks      = ingress.value["cidr_blocks"]
        }     
    }

    # egress is always same for every sg, so keep egress static
    egress {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
        #ipv6_cidr_blocks = ["::/0"]
    }

    tags = merge(
        var.common_tags,
        var.sg_tags,
        {
            Name = "${var.project_name}-${var.environment}-${var.sg_name}"
        }

    )

}

#NOTE: generally resource blocks should be here, but kept in project-sg main.tf, just test by uncommenting below code and removing below code in
#in main.tf of project-sg

# #openvpn
# resource "aws_security_group_rule" "vpn_home" {
#   security_group_id = module.vpn.sg_id
#   type                     = "ingress"
#   from_port                = 0
#   to_port                  = 65535
#   protocol                 = "-1"
#   cidr_blocks = ["0.0.0.0/0"] #ideally your home public IP address, but it frequently changes
# }


# resource "aws_security_group_rule" "mongodb_vpn" {
#   source_security_group_id = module.vpn.sg_id
#   type                     = "ingress"
#   from_port                = 22
#   to_port                  = 22
#   protocol                 = "tcp"
#   security_group_id        = module.mongodb.sg_id
# }

# #mongodb accepting connections from catalogue instance
# resource "aws_security_group_rule" "mongodb_catalogue" {
#   source_security_group_id = module.catalogue.sg_id  #from catalogue
#   type                     = "ingress"
#   from_port                = 27017
#   to_port                  = 27017
#   protocol                 = "tcp"
#   security_group_id        = module.mongodb.sg_id   #to mongodb
# }

# #mongodb accepting connections from user instance
# resource "aws_security_group_rule" "mongodb_user" {
#   source_security_group_id = module.user.sg_id   #from user
#   type                     = "ingress"
#   from_port                = 27017
#   to_port                  = 27017
#   protocol                 = "tcp"
#   security_group_id        = module.mongodb.sg_id  #to mongodb
# }

# resource "aws_security_group_rule" "redis_user" {
#   source_security_group_id = module.user.sg_id
#   type                     = "ingress"
#   from_port                = 6379
#   to_port                  = 6379
#   protocol                 = "tcp"
#   security_group_id        = module.redis.sg_id
# }

# resource "aws_security_group_rule" "redis_cart" {
#   source_security_group_id = module.cart.sg_id
#   type                     = "ingress"
#   from_port                = 6379
#   to_port                  = 6379
#   protocol                 = "tcp"
#   security_group_id        = module.redis.sg_id
# }

# resource "aws_security_group_rule" "mysql_vpn" {
#   source_security_group_id = module.vpn.sg_id
#   type                     = "ingress"
#   from_port                = 22
#   to_port                  = 22
#   protocol                 = "tcp"
#   security_group_id        = module.mysql.sg_id
# }

# resource "aws_security_group_rule" "mysql_shipping" {
#   source_security_group_id = module.shipping.sg_id
#   type                     = "ingress"
#   from_port                = 3306
#   to_port                  = 3306
#   protocol                 = "tcp"
#   security_group_id        = module.mysql.sg_id
# }

# resource "aws_security_group_rule" "rabbitmq_vpn" {
#   source_security_group_id = module.vpn.sg_id
#   type                     = "ingress"
#   from_port                = 22
#   to_port                  = 22
#   protocol                 = "tcp"
#   security_group_id        = module.rabbitmq.sg_id
# }

# resource "aws_security_group_rule" "rabbitmq_payment" {
#   source_security_group_id = module.payment.sg_id
#   type                     = "ingress"
#   from_port                = 5672
#   to_port                  = 5672
#   protocol                 = "tcp"
#   security_group_id        = module.rabbitmq.sg_id
# }

# resource "aws_security_group_rule" "catalogue_vpn" {
#   source_security_group_id = module.vpn.sg_id
#   type                     = "ingress"
#   from_port                = 22
#   to_port                  = 22
#   protocol                 = "tcp"
#   security_group_id        = module.catalogue.sg_id
# }

# resource "aws_security_group_rule" "catalogue_web" {
#   source_security_group_id = module.web.sg_id
#   type                     = "ingress"
#   from_port                = 8080
#   to_port                  = 8080
#   protocol                 = "tcp"
#   security_group_id        = module.catalogue.sg_id
# }

# resource "aws_security_group_rule" "catalogue_cart" {
#   source_security_group_id = module.cart.sg_id
#   type                     = "ingress"
#   from_port                = 8080
#   to_port                  = 8080
#   protocol                 = "tcp"
#   security_group_id        = module.catalogue.sg_id
# }

# resource "aws_security_group_rule" "user_vpn" {
#   source_security_group_id = module.vpn.sg_id
#   type                     = "ingress"
#   from_port                = 22
#   to_port                  = 22
#   protocol                 = "tcp"
#   security_group_id        = module.user.sg_id
# }

# resource "aws_security_group_rule" "user_web" {
#   source_security_group_id = module.web.sg_id
#   type                     = "ingress"
#   from_port                = 8080
#   to_port                  = 8080
#   protocol                 = "tcp"
#   security_group_id        = module.user.sg_id
# }

# resource "aws_security_group_rule" "user_payment" {
#   source_security_group_id = module.payment.sg_id
#   type                     = "ingress"
#   from_port                = 8080
#   to_port                  = 8080
#   protocol                 = "tcp"
#   security_group_id        = module.user.sg_id
# }

# resource "aws_security_group_rule" "cart_vpn" {
#   source_security_group_id = module.vpn.sg_id
#   type                     = "ingress"
#   from_port                = 22
#   to_port                  = 22
#   protocol                 = "tcp"
#   security_group_id        = module.cart.sg_id
# }

# resource "aws_security_group_rule" "cart_web" {
#   source_security_group_id = module.web.sg_id
#   type                     = "ingress"
#   from_port                = 8080
#   to_port                  = 8080
#   protocol                 = "tcp"
#   security_group_id        = module.cart.sg_id
# }

# resource "aws_security_group_rule" "cart_shipping" {
#   source_security_group_id = module.shipping.sg_id
#   type                     = "ingress"
#   from_port                = 8080
#   to_port                  = 8080
#   protocol                 = "tcp"
#   security_group_id        = module.cart.sg_id
# }

# resource "aws_security_group_rule" "cart_payment" {
#   source_security_group_id = module.payment.sg_id
#   type                     = "ingress"
#   from_port                = 8080
#   to_port                  = 8080
#   protocol                 = "tcp"
#   security_group_id        = module.cart.sg_id
# }

# resource "aws_security_group_rule" "shipping_vpn" {
#   source_security_group_id = module.vpn.sg_id
#   type                     = "ingress"
#   from_port                = 22
#   to_port                  = 22
#   protocol                 = "tcp"
#   security_group_id        = module.shipping.sg_id
# }

# resource "aws_security_group_rule" "shipping_web" {
#   source_security_group_id = module.web.sg_id
#   type                     = "ingress"
#   from_port                = 8080
#   to_port                  = 8080
#   protocol                 = "tcp"
#   security_group_id        = module.shipping.sg_id
# }

# resource "aws_security_group_rule" "payment_vpn" {
#   source_security_group_id = module.vpn.sg_id
#   type                     = "ingress"
#   from_port                = 22
#   to_port                  = 22
#   protocol                 = "tcp"
#   security_group_id        = module.payment.sg_id
# }

# resource "aws_security_group_rule" "payment_web" {
#   source_security_group_id = module.web.sg_id
#   type                     = "ingress"
#   from_port                = 8080
#   to_port                  = 8080
#   protocol                 = "tcp"
#   security_group_id        = module.payment.sg_id
# }

# resource "aws_security_group_rule" "web_vpn" {
#   source_security_group_id = module.vpn.sg_id
#   type                     = "ingress"
#   from_port                = 22
#   to_port                  = 22
#   protocol                 = "tcp"
#   security_group_id        = module.web.sg_id
# }

# resource "aws_security_group_rule" "web_internet" {
#   cidr_blocks = ["0.0.0.0/0"]
#   type                     = "ingress"
#   from_port                = 80
#   to_port                  = 80
#   protocol                 = "tcp"
#   security_group_id        = module.web.sg_id
# }