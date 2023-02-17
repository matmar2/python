# Provider configuration for AWS
provider "aws" {
  region = "us-west-2"
}

# Create an RDS MySQL database
resource "aws_db_instance" "wordpress_db" {
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = "wordpress_db"
  username             = "wordpress"
  password             = "password"
}

# Create a security group to allow access to the database
resource "aws_security_group" "wordpress_db_sg" {
  name_prefix = "wordpress_db_sg"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create a WordPress EC2 instance
resource "aws_instance" "wordpress" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  key_name      = "my_key_pair"
  vpc_security_group_ids = [aws_security_group.wordpress_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd php php-mysql

              # Download and install WordPress
              cd /var/www/html
              wget https://wordpress.org/latest.tar.gz
              tar -xzf latest.tar.gz
              cp -r wordpress/* .
              rm -rf wordpress latest.tar.gz

              # Configure WordPress
              cp wp-config-sample.php wp-config.php
              sed -i 's/database_name_here/wordpress_db/g' wp-config.php
              sed -i 's/username_here/wordpress/g' wp-config.php
              sed -i 's/password_here/password/g' wp-config.php
              EOF

  tags = {
    Name = "wordpress"
  }
}

# Create a security group to allow access to the EC2 instance
resource "aws_security_group" "wordpress_sg" {
  name_prefix = "wordpress_sg"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

