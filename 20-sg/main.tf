#Create MySQL Security Group
module "mysql_sg" {
    source = "git::https://github.com/aikdp/terraform-aws-security-group.git?ref=main"
    project_name = var.project_name
    environment = var.environment
    common_tags = var.common_tags
    sg_name = "mysql"
    sg_tags = var.mysql_sg_tags
    vpc_id = local.vpc_id   #get it from data source, we already store at ssm parameter
}

#Create BACKEND Security Group
module "backend_sg" {
    source = "git::https://github.com/aikdp/terraform-aws-security-group.git?ref=main"
    project_name = var.project_name
    environment = var.environment
    common_tags = var.common_tags
    sg_name = "backend"
    sg_tags = var.backend_sg_tags
    vpc_id = local.vpc_id   #get it from data source, we already store at ssm parameter
}

#Create FRONTEND Security Group
module "frontend_sg" {
    source = "git::https://github.com/aikdp/terraform-aws-security-group.git?ref=main"
    project_name = var.project_name
    environment = var.environment
    common_tags = var.common_tags
    sg_name = "frontend"
    sg_tags = var.frontend_sg_tags
    vpc_id = local.vpc_id   #get it from data source, we already store at ssm parameter
}

#Create FRONTEND Security Group
module "bastion_sg" {
    source = "git::https://github.com/aikdp/terraform-aws-security-group.git?ref=main"
    project_name = var.project_name
    environment = var.environment
    common_tags = var.common_tags
    sg_name = "bastion"
    sg_tags = var.bastion_sg_tags
    vpc_id = local.vpc_id   #get it from data source, we already store at ssm parameter
}

#Create ANSIBLE Security Group
module "ansible_sg" {
    source = "git::https://github.com/aikdp/terraform-aws-security-group.git?ref=main"
    project_name = var.project_name
    environment = var.environment
    common_tags = var.common_tags
    sg_name = "ansible"
    sg_tags = var.ansible_sg_tags
    vpc_id = local.vpc_id   #get it from data source, we already store at ssm parameter
}


#Create Security group rules for allow traffic from backend to MySQL
resource "aws_security_group_rule" "mysql_backend" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  source_security_group_id = module.backend_sg.id   #Source is backend and MySQL is allowing from backend
  security_group_id = module.mysql_sg.id    #adding SG rule in mysql
}

#Create Security group rules for allow traffic from frontend to backend
resource "aws_security_group_rule" "backend_frontend" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.frontend_sg.id   #Source is backend and backend is allowing from frontend
  security_group_id = module.backend_sg.id    #adding SG rule in backend
}

#Create Security group rules for allow traffic from  public to frontend
resource "aws_security_group_rule" "frontend_public" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]   #Source is public and frontend is allowing from public
  security_group_id = module.frontend_sg.id    #adding SG rule in frontend
}

#Create Security group rules for allow traffic from bastion to mysql
resource "aws_security_group_rule" "mysql_bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.bastion_sg.id  
  security_group_id = module.mysql_sg.id 
}

#Create Security group rules for allow traffic from bastion to backend
resource "aws_security_group_rule" "backend_bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.bastion_sg.id  
  security_group_id = module.backend_sg.id 
}

#Create Security group rules for allow traffic from bastion to frontend
resource "aws_security_group_rule" "frontend_bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.bastion_sg.id  
  security_group_id = module.frontend_sg.id 
}

#Create Security group rules for allow traffic from  public to bastion
resource "aws_security_group_rule" "bastion_public" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]  
  security_group_id = module.bastion_sg.id 
}

#Create Security group rules for allow traffic from ANSIBLE to mysql
resource "aws_security_group_rule" "mysql_ansible" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.ansible_sg.id   
  security_group_id = module.mysql_sg.id 
}

#Create Security group rules for allow traffic from ANSIBLE to backend
resource "aws_security_group_rule" "backend_ansible" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.ansible_sg.id   
  security_group_id = module.backend_sg.id 
}

#Create Security group rules for allow traffic from ANSIBLE to backend
resource "aws_security_group_rule" "frontend_ansible" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.ansible_sg.id   
  security_group_id = module.frontend_sg.id 
}

#Create Security group rules for allow traffic from public to ANSIBLE
resource "aws_security_group_rule" "ansible_public" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]  
  security_group_id = module.ansible_sg.id 
}
