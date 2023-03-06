terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
}

# Configure provider
provider "aws" {
  region  = "us-east-1"
}

resource "aws_kms_key" "terraform-bucket-key" {
 description             = "This key is used to encrypt bucket objects"
 deletion_window_in_days = 10
 enable_key_rotation     = true
}

resource "aws_kms_alias" "key-alias" {
 name          = "alias/terraform-bucket-key"
 target_key_id = aws_kms_key.terraform-bucket-key.key_id
}


resource "aws_s3_bucket" "terraform-state" {
 bucket = "tkt-mat-78-worpress"
 acl    = "private"

 versioning {
   enabled = true
 }

 server_side_encryption_configuration {
   rule {
     apply_server_side_encryption_by_default {
       kms_master_key_id = aws_kms_key.terraform-bucket-key.arn
       sse_algorithm     = "aws:kms"
     }
   }
 }
}

resource "aws_s3_bucket_public_access_block" "block" {
 bucket = aws_s3_bucket.terraform-state.id

 block_public_acls       = true
 block_public_policy     = true
 ignore_public_acls      = true
 restrict_public_buckets = true
}

resource "aws_dynamodb_table" "terraform-state" {
 name           = "terraform-state"
 read_capacity  = 20
 write_capacity = 20
 hash_key       = "LockID"

 attribute {
   name = "LockID"
   type = "S"
 }
}


data "aws_vpc" "vpc" {
  id = "vpc-0d1697a7ee36defe8" # Replace with your VPC ID
}



data "aws_subnet" "public_1" {
  id = "subnet-0a0cd31803a7c5aec"
}

data "aws_subnet" "public_2" {
  id = "subnet-046b5d6c6ec204951"
}
  
data "aws_subnet" "private_1" {
  id = "subnet-00dee82436a382e89"
}

data "aws_subnet" "private_2" {
  id = "subnet-0a1d3fe32144d3e84"
}

#data "aws_internet_gateway" "ig" {
#  id = "igw-02278714d69356c9f"
#}



data "aws_internet_gateway" "ig" {
  filter {
    name   = "tag:Name"
    values = ["IGW-Prod-VPC"]
  }
}



#data "aws_vpc" "vpc" {
#  filter {
#    name   = "tag:Name"
#    values = ["vpc-0d1697a7ee36defe8"]
#  }
#}


# Create VPC
#resource "aws_vpc" "vpc" {
#  cidr_block       = "10.0.0.0/16"
#  instance_tenancy = "default"

#  tags = {
#    Name        = "prod-vpc"
#  }
#}

# Create internet gateway
#resource "aws_internet_gateway" "ig" {
#  vpc_id = data.aws_vpc.vpc.id
#  #vpc_id      = data.aws.vpc.id 
#  tags = {
#    Name        = "ig-project"
#  }
#}


# Create 2 public subnets
#resource "aws_subnet" "public_1" {
#  vpc_id     = data.aws_vpc.vpc.id
#  cidr_block = "10.0.1.0/24"
#  availability_zone = "us-east-1a"
#  map_public_ip_on_launch = true

#  tags = {
#    Name = "public-1"
#  }
#}

#resource "aws_subnet" "public_2" {
#  vpc_id     = data.aws_vpc.vpc.id
#  cidr_block = "10.0.2.0/24"
#  availability_zone = "us-east-1b"
#  map_public_ip_on_launch = true

#  tags = {
#    Name = "public-2"
#  }
#}


# Create 2 private subnets
#resource "aws_subnet" "private_1" {
#  vpc_id     = data.aws_vpc.vpc.id
#  cidr_block = "10.0.3.0/24"
#  availability_zone = "us-east-1a"
#  map_public_ip_on_launch = false

#  tags = {
#    Name = "private-1"
#  }
#}

#resource "aws_subnet" "private_2" {
#  vpc_id     = data.aws_vpc.vpc.id
#  cidr_block = "10.0.4.0/24"
#  availability_zone = "us-east-1b"
#  map_public_ip_on_launch = false

#  tags = {
#    Name = "private-2"
#  }
#}


# Create route table to internet gateway
resource "aws_route_table" "project_rt" {
  vpc_id = data.aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = data.aws_internet_gateway.ig.id
  }
    tags = {
    Name = "project-rt"
  }
}

# Associate public subnets with route table
#resource "aws_route_table_association" "public_route_1" {
#  subnet_id      = data.aws_subnet.public_1.id
#  route_table_id = aws_route_table.project_rt.id
#  depends_on = [aws_route_table.project_rt]   # [aws_route_table_association.existing_association]
#}

#resource "aws_route_table_association" "public_route_2" {
#  subnet_id      = data.aws_subnet.public_2.id
#  route_table_id = aws_route_table.project_rt.id
#  depends_on = [aws_route_table.project_rt]
#}



# Create security groups
resource "aws_security_group" "public_sg" {
  name        = "public-sg"
  description = "Allow web and ssh traffic"
  vpc_id      = data.aws_vpc.vpc.id

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    from_port         = 22
    to_port           = 22
    protocol          = "tcp"
    cidr_blocks       = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]

  }
}

resource "aws_security_group" "private_sg" {
  name        = "private-sg"
  description = "Allow web tier and ssh traffic"
  vpc_id      = data.aws_vpc.vpc.id

  ingress {
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    cidr_blocks      = ["10.0.0.0/16"]
    security_groups = [ aws_security_group.public_sg.id ]
  }
  ingress {
    from_port         = 22
    to_port           = 22
    protocol          = "tcp"
    cidr_blocks       = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]

  }
}
# Security group for ALB
resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "security group for alb"
  vpc_id      = data.aws_vpc.vpc.id

  ingress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}



# Create ALB
resource "aws_lb" "project_alb" {
  name               = "alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [data.aws_subnet.public_1.id, data.aws_subnet.public_2.id]
}


# Create ALB target group
resource "aws_lb_target_group" "project_tg" {
  name     = "project-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.vpc.id

  depends_on = [data.aws_vpc.vpc]
}

# Create target attachments
resource "aws_lb_target_group_attachment" "tg_attach1" {
  target_group_arn = aws_lb_target_group.project_tg.arn
  target_id        = aws_instance.web1.id
  port             = 80

  depends_on = [aws_instance.web1]
}


# Create listener
resource "aws_lb_listener" "listener_lb" {
  load_balancer_arn = aws_lb.project_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.project_tg.arn
  }
}


# Create database instance
resource "aws_db_instance" "project_db" {
  allocated_storage    = 5
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  identifier           = "db-instance"
  db_name              = "project_db"
  username             = "admin"
  password             = "password"
  db_subnet_group_name = aws_db_subnet_group.db_subnet.id
  vpc_security_group_ids = [aws_security_group.private_sg.id]
  publicly_accessible = false
  skip_final_snapshot  = true
}

 variable "database_user" {
    type    = string
    default = "myuser"
  }

  variable "database_password" {
    type    = string
    default = "mypassword"
  }
  
  variable "database_name" {
    type    = string
    default = "mydb"
  }



# -----------------------------------------------
# Change USERDATA varible value after grabbing RDS endpoint info
# -----------------------------------------------
data "template_file" "user_data" {
  template = file("userdata.sh")




  vars = {
    db_username      = var.database_user
    db_user_password = var.database_password
    db_name          = var.database_name
    db_RDS           = aws_db_instance.project_db.endpoint    #aws_db_instance.wordpressdb.endpoint

  }


#  variable "database_user" {
#     type = string
#  }

#  variable "database_password" {
#     type = string
#  }
#  variable "database_name" {
#     type = string
#  }
#  variable "db_RDS" {
#     type = string
#  }

#  variable "db_username" {
#     type = string
#  }

#  variable "db_user_password" {
#     type = string
#  }
#  variable "db_name" {
#     type = string
#  }
  #variable "db_RDS" {
  #   type = string
  #}

# vars = {

#    db_username      = aws_db_instance.database.username
#    db_user_password = aws_db_instance.database.password
#    db_name          = aws_db_instance.database.name
#    db_RDS           = aws_db_instance.database.endpoint

# }



#  vars = {
#    db_username      = var.database_user
#    db_user_password = var.database_password
#    db_name          = var.database_name
#    db_RDS           = var.aws_db_instance.wordpressdb.endpoint
#  }
}


# Create ec2 instances
resource "aws_instance" "web1" {
  ami           = "ami-0cff7528ff583bf9a"
  instance_type = "t2.micro"
  key_name          = "Mat-internship-ticket-key"
  availability_zone = "us-east-1a"
  vpc_security_group_ids      = [aws_security_group.public_sg.id]
  subnet_id                   = data.aws_subnet.public_1.id
  associate_public_ip_address = true


# user_data = file("userdata.sh")

  user_data = data.template_file.user_data.rendered


  tags = {
    Name = "wordpress_instance"
  }
}

# Database subnet group
resource "aws_db_subnet_group" "db_subnet"  {
    name       = "db-subnet"
    subnet_ids = [data.aws_subnet.private_1.id, data.aws_subnet.private_2.id]
}


# Create database instance
#resource "aws_db_instance" "project_db" {
#  allocated_storage    = 5
#  engine               = "mysql"
#  engine_version       = "5.7"
#  instance_class       = "db.t3.micro"
#  identifier           = "db-instance"
#  db_name              = "project_db"
#  username             = "admin"
#  password             = "password"
#  db_subnet_group_name = aws_db_subnet_group.db_subnet.id
#  vpc_security_group_ids = [aws_security_group.private_sg.id]
#  publicly_accessible = false
#  skip_final_snapshot  = true
#}
# Outputs
# Ec2 instance public ipv4 address
output "ec2_public_ip" {
  value = aws_instance.web1.public_ip
}

# Db instance address
output "db_instance_address" {
    value = aws_db_instance.project_db.address
}

# Getting the DNS of load balancer
output "lb_dns_name" {
  description = "The DNS name of the load balancer"
  value       = "${aws_lb.project_alb.dns_name}"
}

