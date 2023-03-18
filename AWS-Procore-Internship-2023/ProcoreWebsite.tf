terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 3.0"
        }
    }
}

provider "aws" {
    region = "us-east-1"
}

resource "aws_instance" "EC2Instance" {
    ami = "ami-0b5eea76982371e91"
    instance_type = "t2.micro"
    availability_zone = "us-east-1a"
    tenancy = "default"
    subnet_id = "subnet-0a0cd31803a7c5aec"
    ebs_optimized = false
    vpc_security_group_ids = [
        "${aws_security_group.EC2SecurityGroup.id}"
    ]
    source_dest_check = true
    root_block_device {
        volume_size = 8
        volume_type = "gp2"
        delete_on_termination = true
    }
    user_data = "IyEvYmluL2Jhc2gKc3VkbyB5dW0gLXkgdXBkYXRlCnN1ZG8geXVtIGluc3RhbGwgLXkgaHR0cGQKc3VkbyBzeXN0ZW1jdGwgc3RhcnQgaHR0cGQKc3VkbyBzeXN0ZW1jdGwgZW5hYmxlIGh0dHBkCnN1ZG8geXVtIGluc3RhbGwgLXkgZ2l0CnN1ZG8geXVtIGluc3RhbGwgcnVieSB3Z2V0IC15CmNkIC9ob21lL2VjMi11c2VyCnN1ZG8gd2dldCBodHRwczovL2F3cy1jb2RlZGVwbG95LXVzLWVhc3QtMS5zMy51cy1lYXN0LTEuYW1hem9uYXdzLmNvbS9sYXRlc3QvaW5zdGFsbApzdWRvIGNobW9kICt4IC4vaW5zdGFsbApzdWRvIC4vaW5zdGFsbCBhdXRvCnN1ZG8gZ2l0IGNvbmZpZyAtLXN5c3RlbSBjcmVkZW50aWFsLmhlbHBlciAnIWF3cyBjb2RlY29tbWl0IGNyZWRlbnRpYWwtaGVscGVyICRAJyAKc3VkbyBnaXQgY29uZmlnIC0tc3lzdGVtIGNyZWRlbnRpYWwuVXNlSHR0cFBhdGggdHJ1ZQpzdWRvIGdpdCBjb25maWcgLS1zeXN0ZW0gY3JlZGVudGlhbC5Vc2VIdHRwc1BhdGggdHJ1ZQpzdWRvIGdpdCBjb25maWcgLS1zeXN0ZW0gdXNlci5uYW1lICJNYXRoZXdvcyIgCnN1ZG8gZ2l0IGNvbmZpZyAtLXN5c3RlbSB1c2VyLmVtYWlsICJtYXRtYXIyQHlhaG9vLmNvbSIKY2QgL2hvbWUvZWMyLXVzZXIKc3VkbyBnaXQgY2xvbmUgLWIgbWFpbiBodHRwczovL2dpdC1jb2RlY29tbWl0LnVzLWVhc3QtMS5hbWF6b25hd3MuY29tL3YxL3JlcG9zL1RLVC1NQVQtMzctQ29kZUNvbW1pdC1SZXBv"
    iam_instance_profile = "${aws_iam_role.IAMRole.name}"
    tags = 
}

resource "aws_vpc" "EC2VPC" {
    cidr_block = "10.1.0.0/16"
    enable_dns_support = true
    enable_dns_hostnames = false
    instance_tenancy = "default"
    tags = 
}

resource "aws_vpc" "EC2VPC2" {
    cidr_block = "10.2.0.0/16"
    enable_dns_support = true
    enable_dns_hostnames = true
    instance_tenancy = "default"
    tags = 
}

resource "aws_security_group" "EC2SecurityGroup" {
    description = "Prod VPC Security Group"
    name = "Prod-SG"
    tags = 
    vpc_id = "${aws_vpc.EC2VPC2.id}"
    ingress {
        cidr_blocks = [
            "0.0.0.0/0"
        ]
        from_port = 80
        protocol = "tcp"
        to_port = 80
    }
    ingress {
        cidr_blocks = [
            "0.0.0.0/0"
        ]
        from_port = 0
        protocol = "-1"
        to_port = 0
    }
    ingress {
        cidr_blocks = [
            "0.0.0.0/0"
        ]
        description = "Port 554"
        from_port = 554
        protocol = "tcp"
        to_port = 554
    }
    ingress {
        cidr_blocks = [
            "0.0.0.0/0"
        ]
        description = "Port 8000"
        from_port = 8000
        protocol = "tcp"
        to_port = 8000
    }
    ingress {
        cidr_blocks = [
            "0.0.0.0/0"
        ]
        from_port = 22
        protocol = "tcp"
        to_port = 22
    }
    ingress {
        cidr_blocks = [
            "0.0.0.0/0"
        ]
        description = "Port 8089"
        from_port = 8089
        protocol = "tcp"
        to_port = 8089
    }
    ingress {
        cidr_blocks = [
            "0.0.0.0/0"
        ]
        description = "Port 9997"
        from_port = 9997
        protocol = "tcp"
        to_port = 9997
    }
    ingress {
        cidr_blocks = [
            "0.0.0.0/0"
        ]
        from_port = 443
        protocol = "tcp"
        to_port = 443
    }
    ingress {
        cidr_blocks = [
            "0.0.0.0/0"
        ]
        from_port = -1
        protocol = "icmp"
        to_port = -1
    }
    ingress {
        security_groups = [
            "sg-0e8e1ab5f5bf9708f"
        ]
        description = "Dev-VPC-SG"
        from_port = -1
        protocol = "icmp"
        to_port = -1
    }
    egress {
        cidr_blocks = [
            "0.0.0.0/0"
        ]
        from_port = 0
        protocol = "-1"
        to_port = 0
    }
}

resource "aws_iam_role" "IAMRole" {
    path = "/"
    name = "EC2InstanceRoleForCodeDeploy"
    assume_role_policy = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Principal\":{\"Service\":\"ec2.amazonaws.com\"},\"Action\":\"sts:AssumeRole\"}]}"
    max_session_duration = 3600
    tags = 
}

resource "aws_iam_instance_profile" "IAMInstanceProfile" {
    path = "/"
    name = "${aws_iam_role.IAMRole.name}"
    roles = [
        "${aws_iam_role.IAMRole.name}"
    ]
}

resource "aws_subnet" "EC2Subnet" {
    availability_zone = "us-east-1a"
    cidr_block = "10.2.2.0/26"
    vpc_id = "${aws_vpc.EC2VPC2.id}"
    map_public_ip_on_launch = false
}

resource "aws_subnet" "EC2Subnet2" {
    availability_zone = "us-east-1a"
    cidr_block = "10.2.0.0/24"
    vpc_id = "${aws_vpc.EC2VPC2.id}"
    map_public_ip_on_launch = true
}

resource "aws_subnet" "EC2Subnet3" {
    availability_zone = "us-east-1b"
    cidr_block = "10.2.2.64/26"
    vpc_id = "${aws_vpc.EC2VPC2.id}"
    map_public_ip_on_launch = false
}

resource "aws_subnet" "EC2Subnet4" {
    availability_zone = "us-east-1b"
    cidr_block = "10.2.1.0/24"
    vpc_id = "${aws_vpc.EC2VPC2.id}"
    map_public_ip_on_launch = true
}

resource "aws_route_table" "EC2RouteTable" {
    vpc_id = "${aws_vpc.EC2VPC2.id}"
    tags = 
}

resource "aws_route" "EC2Route" {
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = "igw-02278714d69356c9f"
    route_table_id = "rtb-0ce7f6e508de0bfe9"
}

resource "aws_route_table" "EC2RouteTable2" {
    vpc_id = "${aws_vpc.EC2VPC2.id}"
    tags = 
}

resource "aws_route" "EC2Route2" {
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id = "nat-04af95bdf799b7816"
    route_table_id = "rtb-094d606e18c4e0c2b"
}

resource "aws_route_table_association" "EC2SubnetRouteTableAssociation" {
    route_table_id = "rtb-094d606e18c4e0c2b"
    subnet_id = "subnet-00dee82436a382e89"
}

resource "aws_route_table_association" "EC2SubnetRouteTableAssociation2" {
    route_table_id = "rtb-0ce7f6e508de0bfe9"
    subnet_id = "subnet-0a0cd31803a7c5aec"
}

resource "aws_route_table_association" "EC2SubnetRouteTableAssociation3" {
    route_table_id = "rtb-0ce7f6e508de0bfe9"
    subnet_id = "subnet-046b5d6c6ec204951"
}

resource "aws_route_table" "EC2RouteTable3" {
    vpc_id = "${aws_vpc.EC2VPC2.id}"
    tags = 
}

resource "aws_route" "EC2Route3" {
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id = "nat-0fc4e5e2065334163"
    route_table_id = "rtb-08960009de92b0ac1"
}

resource "aws_lb" "ElasticLoadBalancingV2LoadBalancer" {
    name = "ALB-Internship"
    internal = false
    load_balancer_type = "application"
    subnets = [
        "subnet-046b5d6c6ec204951",
        "subnet-0a0cd31803a7c5aec"
    ]
    security_groups = [
        "${aws_security_group.EC2SecurityGroup.id}"
    ]
    ip_address_type = "ipv4"
    access_logs {
        enabled = false
        bucket = ""
        prefix = ""
    }
    idle_timeout = "60"
    enable_deletion_protection = "false"
    enable_http2 = "true"
    enable_cross_zone_load_balancing = "true"
}

resource "aws_lb_listener" "ElasticLoadBalancingV2Listener" {
    load_balancer_arn = "arn:aws:elasticloadbalancing:us-east-1:202618001640:loadbalancer/app/ALB-Internship/5488027b79c4869f"
    port = 80
    protocol = "HTTP"
    default_action {
        target_group_arn = "arn:aws:elasticloadbalancing:us-east-1:202618001640:targetgroup/Target-Group-Internship/de731a1b6727f30a"
        type = "forward"
    }
}

resource "aws_lb_listener" "ElasticLoadBalancingV2Listener2" {
    load_balancer_arn = "arn:aws:elasticloadbalancing:us-east-1:202618001640:loadbalancer/app/ALB-Internship/5488027b79c4869f"
    port = 8080
    protocol = "HTTP"
    default_action {
        target_group_arn = "arn:aws:elasticloadbalancing:us-east-1:202618001640:targetgroup/Target-Group-Internship/de731a1b6727f30a"
        type = "forward"
    }
}

resource "aws_lb_listener_rule" "ElasticLoadBalancingV2ListenerRule" {
    priority = "1"
    listener_arn = "arn:aws:elasticloadbalancing:us-east-1:202618001640:listener/app/ALB-Internship/5488027b79c4869f/0a63d0b55b40ffb7"
    condition {
        field = "path-pattern"
        values = [
            "/TKT-MAT-37-CodeCommit-Repo/index.html"
        ]
    }
}

resource "aws_autoscaling_group" "AutoScalingAutoScalingGroup" {
    name = "ASG-Internship-Ticket-MAT39"
    launch_template {
        id = "lt-0cd07445d374ed1cf"
        name = "EC2-Launch-Template"
        version = "$Default"
    }
    min_size = 1
    max_size = 3
    desired_capacity = 1
    default_cooldown = 300
    availability_zones = [
        "us-east-1a",
        "us-east-1b"
    ]
    target_group_arns = [
        "arn:aws:elasticloadbalancing:us-east-1:202618001640:targetgroup/Target-Group-Internship/de731a1b6727f30a"
    ]
    health_check_type = "EC2"
    health_check_grace_period = 300
    vpc_zone_identifier = [
        "subnet-046b5d6c6ec204951",
        "subnet-0a0cd31803a7c5aec"
    ]
    termination_policies = [
        "Default"
    ]
    service_linked_role_arn = "arn:aws:iam::202618001640:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"
}

resource "aws_lb_target_group" "ElasticLoadBalancingV2TargetGroup" {
    health_check {
        interval = 30
        path = "/"
        port = "80"
        protocol = "HTTP"
        timeout = 5
        unhealthy_threshold = 5
        healthy_threshold = 5
        matcher = "200"
    }
    port = 80
    protocol = "HTTP"
    target_type = "instance"
    vpc_id = "${aws_vpc.EC2VPC2.id}"
    name = "Target-Group-Internship"
}

resource "aws_launch_template" "EC2LaunchTemplate" {
    name = "EC2-Launch-Template"
    tag_specifications {
        resource_type = "instance"
        tags {
            Name = "EC2-Internship"
        }
    }
    user_data = "IyEvYmluL2Jhc2gKc3VkbyB5dW0gLXkgdXBkYXRlCnN1ZG8geXVtIGluc3RhbGwgLXkgaHR0cGQKc3VkbyBzeXN0ZW1jdGwgc3RhcnQgaHR0cGQKc3VkbyBzeXN0ZW1jdGwgZW5hYmxlIGh0dHBkCnN1ZG8geXVtIGluc3RhbGwgLXkgZ2l0CnN1ZG8geXVtIGluc3RhbGwgcnVieSB3Z2V0IC15CmNkIC9ob21lL2VjMi11c2VyCnN1ZG8gd2dldCBodHRwczovL2F3cy1jb2RlZGVwbG95LXVzLWVhc3QtMS5zMy51cy1lYXN0LTEuYW1hem9uYXdzLmNvbS9sYXRlc3QvaW5zdGFsbApzdWRvIGNobW9kICt4IC4vaW5zdGFsbApzdWRvIC4vaW5zdGFsbCBhdXRvCnN1ZG8gZ2l0IGNvbmZpZyAtLXN5c3RlbSBjcmVkZW50aWFsLmhlbHBlciAnIWF3cyBjb2RlY29tbWl0IGNyZWRlbnRpYWwtaGVscGVyICRAJyAKc3VkbyBnaXQgY29uZmlnIC0tc3lzdGVtIGNyZWRlbnRpYWwuVXNlSHR0cFBhdGggdHJ1ZQpzdWRvIGdpdCBjb25maWcgLS1zeXN0ZW0gY3JlZGVudGlhbC5Vc2VIdHRwc1BhdGggdHJ1ZQpzdWRvIGdpdCBjb25maWcgLS1zeXN0ZW0gdXNlci5uYW1lICJNYXRoZXdvcyIgCnN1ZG8gZ2l0IGNvbmZpZyAtLXN5c3RlbSB1c2VyLmVtYWlsICJtYXRtYXIyQHlhaG9vLmNvbSIKY2QgL2hvbWUvZWMyLXVzZXIKc3VkbyBnaXQgY2xvbmUgLWIgbWFpbiBodHRwczovL2dpdC1jb2RlY29tbWl0LnVzLWVhc3QtMS5hbWF6b25hd3MuY29tL3YxL3JlcG9zL1RLVC1NQVQtMzctQ29kZUNvbW1pdC1SZXBv"
    iam_instance_profile {
        arn = "arn:aws:iam::202618001640:instance-profile/EC2InstanceRoleForCodeDeploy"
    }
    network_interfaces {
        associate_public_ip_address = true
        device_index = 0
        security_groups = [
            "${aws_security_group.EC2SecurityGroup.id}"
        ]
        subnet_id = "subnet-0a0cd31803a7c5aec"
    }
    image_id = "ami-0b5eea76982371e91"
    instance_type = "t2.micro"
}
