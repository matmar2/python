#!/usr/bin/python3

import boto3
import json
#from botocore.config import Configsession = boto3.Session(profile_name='credentials)

#session = boto3.Session(region_name='us-east-1',
#          aws_access_key_id='AKIAS6LHZLDUG5Q23RNC',
#          aws_secret_access_key='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')

# Create an IAM client with profile_name
# session = boto3.Session(profile_name='default')
#iam = session.client('iam')
#iam = session.client('iam', config=Config(region_name='us-east-1'))

iam = boto3.client('iam')
role_policy = {
 "Version": "2012-10-17",
 "Statement": [
  {
   "Sid": "",
   "Effect": "Allow",
   "Principal": {
     "Service": "lambda.amazonaws.com"
   },
   "Action": "sts:AssumeRole"
  }
 ]
}

#response = iam.create_role(
#  RoleName='LambdaBasicExecution',
##  AssumeRolePolicyDocument=json.dumps(role_policy),
#)
#print(response)

try:
    response = iam.get_role(RoleName='LambdaBasicExecution')
    print('Role already exists')
except iam.exceptions.NoSuchEntityException:
    response = iam.create_role(
        RoleName='LambdaBasicExecution',
        AssumeRolePolicyDocument=json.dumps(role_policy),
    )
    print('Role created successfully')

print(response)

