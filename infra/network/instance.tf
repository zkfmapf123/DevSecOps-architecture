############################################################ SSH SG ############################################################
resource "aws_security_group" "ssh-sg" {
  name   = "ssh-sg"
  vpc_id = module.default-3-tier.vpc.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ssh-sg"
  }
}

############################################################ SSM SG ############################################################
resource "aws_security_group" "ssm-sg" {
  name   = "ssm-sg"
  vpc_id = module.default-3-tier.vpc.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ssm-sg"
  }
}

############################################################ EC2 ############################################################

###################### webserver ec2
module "webserver-ec2" {
  source = "zkfmapf123/simpleEC2/lee"

  instance_name      = "webserver-ins"
  instance_region    = module.default-3-tier.vpc.regions[0]
  instance_subnet_id = lookup(module.default-3-tier.vpc.webserver_subnets, module.default-3-tier.vpc.regions[0])
  instance_sg_ids    = [aws_security_group.ssh-sg.id, aws_security_group.ssm-sg.id]

  instance_ip_attr = {
    is_public_ip  = true
    is_eip        = true
    is_private_ip = false
    private_ip    = ""
  }

  instance_key_attr = {
    is_alloc_key_pair = false
    is_use_key_path   = true
    key_name          = ""
    key_path          = "~/.ssh/id_rsa.pub"
  }

  user_data_file = "./root.sh"
  instance_iam   = aws_iam_instance_profile.ec2-ssm-role-profile.id

  instance_tags = {
    "Monitoring" : true,
    "MadeBy" : "terraform"
    "Name" : "webserver-ins"
  }
}

# # ###################### was ec2
module "was-ec2" {
  source = "zkfmapf123/simpleEC2/lee"

  instance_name      = "was-ins"
  instance_region    = module.default-3-tier.vpc.regions[0]
  instance_subnet_id = lookup(module.default-3-tier.vpc.was_subnets, module.default-3-tier.vpc.regions[0])
  instance_sg_ids    = [aws_security_group.ssh-sg.id, aws_security_group.ssm-sg.id]

  instance_ip_attr = {
    is_public_ip  = false
    is_eip        = false
    is_private_ip = true
    private_ip    = "10.0.100.10"
  }

  instance_key_attr = {
    is_alloc_key_pair = false
    is_use_key_path   = true
    key_name          = ""
    key_path          = "~/.ssh/id_rsa.pub"
  }

  instance_iam   = aws_iam_instance_profile.ec2-ssm-role-profile.id
  user_data_file = "./root.sh"

  instance_tags = {
    "Monitoring" : true,
    "MadeBy" : "terraform"
    "Name" : "was-ins"
  }
}

# # ###################### db ec2
module "db-ec2" {
  source = "zkfmapf123/simpleEC2/lee"

  instance_name      = "db-ins"
  instance_region    = module.default-3-tier.vpc.regions[0]
  instance_subnet_id = lookup(module.default-3-tier.vpc.db_subnets, module.default-3-tier.vpc.regions[0])
  instance_sg_ids    = [aws_security_group.ssh-sg.id, aws_security_group.ssm-sg.id]

  instance_ip_attr = {
    is_public_ip  = false
    is_eip        = false
    is_private_ip = true
    private_ip    = "10.0.200.10"
  }

  instance_key_attr = {
    is_alloc_key_pair = false
    is_use_key_path   = true
    key_name          = ""
    key_path          = "~/.ssh/id_rsa.pub"
  }

  instance_iam   = aws_iam_instance_profile.ec2-ssm-role-profile.id
  user_data_file = "./root.sh"

  instance_tags = {
    "Monitoring" : true,
    "MadeBy" : "terraform"
    "Name" : "db-ins"
  }
}
