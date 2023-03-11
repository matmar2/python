#!/usr/bin/python3

import boto3, json

import boto3
lambda_client = boto3.client('lambda')
response = lambda_client.add_permission(
  StatementId='S3InvokeHelloWorldLambda',
  FunctionName='helloWorldLambda',
  Action='lambda:InvokeLambda',
  Principal='s3.amazonaws.com',
  SourceArn='arn:aws:s3:::test-ap-s3-bucket/*',
)
print(response)
