terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.65.0"
    }
  }
}

provider "aws" {
  region = "eu-north-1"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  # Canonical
  owners = ["099720109477"]
}

data "aws_subnet_ids" "default" {
    vpc_id = data.aws_vpc.default.id
}

# Найти в VPC-подсетях Default VPC.
data "aws_vpc" "default" {
default = true
}

resource "aws_vpc" "main" {
  cidr_block       = var.cidr_block
  instance_tenancy = "default"

  tags = {
   - Student: Serik.Abulkhairov
   - Terraform: true
  }
}

resource "tls_private_key" "ec2_keypair" {
  algorithm = "RSA"
   tags = {
   - Student: Serik.Abulkhairov
   - Terraform: true
  }
}

module "key_pair" {
  source = "terraform-aws-modules/key-pair/aws"

  key_name   = "deployer-one"
  public_key = tls_private_key.ec2_keypair.public_key_openssh
}

resource "aws_subnet" "subnet1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.cidr_block, 8, 1)
  availability_zone = var.availability_zones[0]

  tags = {
    Name = "Subnet1"
    Type = "Public"
    - Student: Serik.Abulkhairov
   - Terraform: true
  }
}

resource "aws_subnet" "subnet2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.cidr_block, 8, 2)
  availability_zone = var.availability_zones[1]

  tags = {
    Name = "Subnet2"
    Type = "Public"
        - Student: Serik.Abulkhairov
   - Terraform: true
  }
}

resource "aws_subnet" "subnet5" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.cidr_block, 8, 5)
  availability_zone = var.availability_zones[2]

  tags = {
    Name = "Subnet5"
    Type = "Public"
        - Student: Serik.Abulkhairov
   - Terraform: true
  }
}

resource "aws_subnet" "subnet3" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.cidr_block, 8, 3)
  availability_zone = var.availability_zones[0]

  tags = {
    Name = "Subnet3"
    Type = "Private"
        - Student: Serik.Abulkhairov
   - Terraform: true
  }
}

resource "aws_subnet" "subnet4" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.cidr_block, 8, 4)
  availability_zone = var.availability_zones[1]

  tags = {
    Name = "Subnet4"
    Type = "Private"
        - Student: Serik.Abulkhairov
   - Terraform: true
  }
}

resource "aws_subnet" "subnet6" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.cidr_block, 8, 6)
  availability_zone = var.availability_zones[2]

  tags = {
    Name = "Subnet6"
    Type = "Private"
        - Student: Serik.Abulkhairov
   - Terraform: true
  }
}


resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
       - Student: Serik.Abulkhairov
   - Terraform: true
  }
}

resource "aws_eip" "nat" {
  vpc = true
    tags = {
       - Student: Serik.Abulkhairov
   - Terraform: true
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.subnet1.id

  tags = {
    Name = "NAT"
           - Student: Serik.Abulkhairov
   - Terraform: true
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.main]
}

resource "aws_route_table" "rt1" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "Public"
           - Student: Serik.Abulkhairov
   - Terraform: true
  }
}

resource "aws_route_table" "rt2" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "Private"
           - Student: Serik.Abulkhairov
   - Terraform: true
  }
}

resource "aws_route_table_association" "rta1" {
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.rt1.id
      tags = {
       - Student: Serik.Abulkhairov
   - Terraform: true
  }
}

resource "aws_route_table_association" "rta2" {
  subnet_id      = aws_subnet.subnet2.id
  route_table_id = aws_route_table.rt1.id
      tags = {
       - Student: Serik.Abulkhairov
   - Terraform: true
  }
}

resource "aws_route_table_association" "rta3" {
  subnet_id      = aws_subnet.subnet3.id
  route_table_id = aws_route_table.rt2.id
      tags = {
       - Student: Serik.Abulkhairov
   - Terraform: true
  }
}

resource "aws_route_table_association" "rta4" {
  subnet_id      = aws_subnet.subnet4.id
  route_table_id = aws_route_table.rt2.id
      tags = {
       - Student: Serik.Abulkhairov
   - Terraform: true
  }
}

resource "aws_route_table_association" "rta5" {
  subnet_id      = aws_subnet.subnet5.id
  route_table_id = aws_route_table.rt2.id
      tags = {
       - Student: Serik.Abulkhairov
   - Terraform: true
  }
}

resource "aws_route_table_association" "rta6" {
  subnet_id      = aws_subnet.subnet6.id
  route_table_id = aws_route_table.rt2.id
      tags = {
       - Student: Serik.Abulkhairov
   - Terraform: true
  }
}

resource "aws_security_group" "webserver" {
  name        = "webserver"
  description = "webserver network traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.workstation_ip]
  }

  ingress {
    description = "80 from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [
      cidrsubnet(var.cidr_block, 8, 1),
      cidrsubnet(var.cidr_block, 8, 2)
      cidrsubnet(var.cidr_block, 8, 5)
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow traffic"
           - Student: Serik.Abulkhairov
   - Terraform: true
  }
      
}

resource "aws_security_group" "alb" {
  name        = "alb"
  description = "alb network traffic"
  vpc_id      = aws_vpc.main.id

# Разрешить входящие HTTP
  ingress {
    description = "80 from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

# Разрешить все исходящие
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.webserver.id]
  }

  tags = {
    Name = "allow traffic"
           - Student: Serik.Abulkhairov
   - Terraform: true
  }
}

resource "aws_launch_template" "launchtemplate1" {
  name = "web"

  image_id               = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.webserver.id]

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "WebServer"
             - Student: Serik.Abulkhairov
   - Terraform: true
    }
  }

  user_data = filebase64("${path.module}/ec2.userdata")
}

resource "aws_lb" "alb1" {
  name               = "alb1"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = [aws_subnet.subnet1.id, aws_subnet.subnet2.id, aws_subnet.subnet5.id]

  enable_deletion_protection = false

  /*
  access_logs {
    bucket  = aws_s3_bucket.lb_logs.bucket
    prefix  = "test-lb"
    enabled = true
  }
  */

  tags = {
    Environment = "Prod"
           - Student: Serik.Abulkhairov
   - Terraform: true
  }
}


resource "aws_alb_target_group" "webserver" {
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
  health_check {
        path = "/"
        protocol = "HTTP"
        matcher = "200"
        interval = 15
        timeout = 3
        healthy_threshold = 2
        unhealthy_threshold = 2
    }
          tags = {
       - Student: Serik.Abulkhairov
   - Terraform: true
  }
}

resource "aws_alb_listener" "front_end" {
  load_balancer_arn = aws_lb.alb1.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.webserver.arn
  }
        tags = {
       - Student: Serik.Abulkhairov
   - Terraform: true
  }
}

resource "aws_alb_listener_rule" "rule1" {
  listener_arn = aws_alb_listener.front_end.arn
  priority     = 99

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.webserver.arn
  }

  condition {
    path_pattern {
      values = ["/"]
    }
  }
        tags = {
       - Student: Serik.Abulkhairov
   - Terraform: true
  }
}

resource "aws_autoscaling_group" "asg" {
  vpc_zone_identifier = [aws_subnet.subnet3.id, aws_subnet.subnet4.id, aws_subnet.subnet6.id]

  desired_capacity = 2
  max_size         = 3
  min_size         = 3

  target_group_arns = [aws_alb_target_group.webserver.arn]
#t3.micro
  launch_template {
    id      = aws_launch_template.launchtemplate1.id
    version = "$Latest"
  }
        tags = {
       - Student: Serik.Abulkhairov
   - Terraform: true
  }
}

resource "aws_acm_certificate" "vpn_server" {
#поменять на свой зарезервированный днс
  domain_name = "example-vpn.example.com"
  validation_method = "DNS"

tags = {
       - Student: Serik.Abulkhairov
   - Terraform: true
  }

  lifecycle {
    create_before_destroy = true
  }
  
}

resource "aws_acm_certificate_validation" "vpn_server" {
  certificate_arn = aws_acm_certificate.vpn_server.arn

  timeouts {
    create = "1m"
  }
}

resource "aws_acm_certificate" "vpn_client_root" {
  private_key = file("certs/client-vpn-ca.key")
  certificate_body = file("certs/client-vpn-ca.crt")
  certificate_chain = file("certs/ca-chain.crt")

  tags = {
       - Student: Serik.Abulkhairov
   - Terraform: true
  }
}

resource "aws_security_group" "vpn_access" {
  vpc_id = aws_vpc.main.id
  name = "vpn-example-sg"

  ingress {
    from_port = 443
    protocol = "UDP"
    to_port = 443
    cidr_blocks = [
      "0.0.0.0/0"]
    description = "Incoming VPN connection"
  }

  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = [
      "0.0.0.0/0"]
  }

tags = {
       - Student: Serik.Abulkhairov
   - Terraform: true
  }
}

resource "aws_ec2_client_vpn_endpoint" "vpn" {
  description = "Client VPN"
  client_cidr_block = "10.20.0.0/22"
  split_tunnel = true
  server_certificate_arn = aws_acm_certificate_validation.vpn_server.certificate_arn

  authentication_options {
    type = "certificate-authentication"
    root_certificate_chain_arn = aws_acm_certificate.vpn_client_root.arn
  }

  connection_log_options {
    enabled = false
  }

 tags = {
       - Student: Serik.Abulkhairov
   - Terraform: true
  }
}

resource "aws_ec2_client_vpn_network_association" "vpn_subnets" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.vpn.id
  subnet_id =  [aws_subnet.subnet3.id, aws_subnet.subnet4.id, aws_subnet.subnet6.id]
  security_groups = [aws_security_group.vpn_access.id]

  lifecycle {
    // The issue why we are ignoring changes is that on every change
    // terraform screws up most of the vpn assosciations
    // see: https://github.com/hashicorp/terraform-provider-aws/issues/14717
    ignore_changes = [subnet_id]
  }
}

resource "aws_ec2_client_vpn_authorization_rule" "vpn_auth_rule" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.vpn.id
  target_network_cidr = aws_vpc.main.cidr_block
  authorize_all_groups = true
  tags = {
       - Student: Serik.Abulkhairov
   - Terraform: true
  }
}

#############################################################################
# DNS ALB
############################################################################
# in outputs .tf
# output "alb_dns_name" {
#     value = aws_lb.alb.dns_name
#     description = "Доменное имя ALB"
# }