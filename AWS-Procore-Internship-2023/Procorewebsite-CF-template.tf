# AWSTemplateFormatVersion: 2010-09-09
Parameters:
  InstanceType:
    Type: String
    Default: t2.micro
    AllowedValues:
      - t2.micro
      - t2.small
      - t2.medium
    Description: EC2 instance type
  Region:
    Type: String
    Default: us-east-1
    Description: AWS region
    AllowedValues:
      - us-east-1
      - us-west-2
      - eu-west-1
  ImageId:
    Type: 'AWS::EC2::Image::Id'
    Default: ami-0c94855ba95c71c99
    Description: EC2 instance AMI ID
    
  AvailabilityZone:
    Type: AWS::EC2::AvailabilityZone::Name
    Description: Any availability zone in the specified region.
Resources:
  VPC:
    Type: AWS::EC2::VPC
    Properties:
      CidrBlock: 10.2.0.0/16
      Tags:
        - Key: Name
          Value: Prod-VPC
  InternetGateway:
    Type: AWS::EC2::InternetGateway
  VPCGatewayAttachment:
    Type: AWS::EC2::VPCGatewayAttachment
    Properties:
      VpcId: !Ref VPC
      InternetGatewayId: !Ref InternetGateway
  PublicSubnetA:
    Type: AWS::EC2::Subnet
    Properties:
      VpcId: !Ref VPC
      CidrBlock: 10.2.0.0/24
      AvailabilityZone: !Ref AvailabilityZone
      Tags:
        - Key: Name
          Value: PublicSubnetA
  PublicSubnetB:
    Type: AWS::EC2::Subnet
    Properties:
      VpcId: !Ref VPC
      CidrBlock: 10.2.1.0/24
      AvailabilityZone: !Ref AvailabilityZone
      Tags:
        - Key: Name
          Value: PublicSubnetB
  PublicRouteTable:
    Type: AWS::EC2::RouteTable
    Properties:
      VpcId: !Ref VPC
      Tags:
        - Key: Name
          Value: PublicRouteTable
  InternetRoute:
    Type: AWS::EC2::Route
    DependsOn: VPCGatewayAttachment
    Properties:
      RouteTableId: !Ref PublicRouteTable
      DestinationCidrBlock: 0.0.0.0/0
      GatewayId: !Ref InternetGateway
  PublicSubnetARouteTableAssociation:
    Type: AWS::EC2::SubnetRouteTableAssociation
    Properties:
      SubnetId: !Ref PublicSubnetA
      RouteTableId: !Ref PublicRouteTable
  PublicSubnetBRouteTableAssociation:
    Type: AWS::EC2::SubnetRouteTableAssociation
    Properties:
      SubnetId: !Ref PublicSubnetB
      RouteTableId: !Ref PublicRouteTable
  MySecurityGroup:
    Type: AWS::EC2::SecurityGroup
    Properties:
      GroupDescription: Allow HTTP and SSH access
      SecurityGroupIngress:
        - IpProtocol: tcp
          FromPort: 22
          ToPort: 22
          CidrIp: 0.0.0.0/0
        - IpProtocol: tcp
          FromPort: 80
          ToPort: 80
          CidrIp: 0.0.0.0/0
  MyLaunchTemplate:
    Type: AWS::EC2::LaunchTemplate
    Properties:
      LaunchTemplateName: "InternshipLaunchTemplate"
      LaunchTemplateData:
        ImageId: !Ref ImageId
        InstanceType: t2.micro


  MyInstance:
    Type: AWS::EC2::Instance
    Properties:
      ImageId: !Ref ImageId
      InstanceType: !Ref InstanceType
      SecurityGroupIds:
        - !Ref MySecurityGroup
      Tags:
        - Key: Name
          Value: AWS-Internship-EC2-Procore

      UserData:
        Fn::Base64: !Sub |
          #!/bin/bash
          sudo yum -y update
          sudo yum install -y httpd
          sudo systemctl start httpd
          sudo systemctl enable httpd
          sudo yum install -y git
          sudo yum install ruby wget -y
          cd /home/ec2-user
          sudo wget https://aws-codedeploy-us-east-1.s3.us-east-1.amazonaws.com/latest/install
          sudo chmod +x ./install
          sudo ./install auto
          sudo git config --system credential.helper 
          sudo git config --system credential.UseHttpPath true
          sudo git config --system credential.UseHttpsPath true
          sudo git config --system user.name “Mathewos”
          sudo git config --system user.email "matmar2@yahoo.com”
          cd /home/ec2-user
          sudo git clone -b main https://git-codecommit.us-east-1.amazonaws.com/v1/repos/TKT-MAT-37-CodeCommit-Repo /home/ec2-user/TKT-MAT-37-CodeCommit-Repo

  MyTargetGroup:
    Type: AWS::ElasticLoadBalancingV2::TargetGroup
    Properties:
      Protocol: HTTP
      Port: 80
      VpcId: !Ref VPC
  MyAutoScalingGroup:
    Type: AWS::AutoScaling::AutoScalingGroup
    Properties:
      AvailabilityZones:
        - !Ref AvailabilityZone
      LaunchTemplate:
        LaunchTemplateId: !Ref MyLaunchTemplate
        Version: !GetAtt MyLaunchTemplate.LatestVersionNumber
      TargetGroupARNs:
        - !Ref MyTargetGroup
      VPCZoneIdentifier:
        - !Ref PublicSubnetA
        - !Ref PublicSubnetB
      MinSize: 1
      MaxSize: 4
      DesiredCapacity: 2
 No resources generated 
    

