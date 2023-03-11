#!/usr/bin/python3

import boto3, json

import boto3
lambda_client = boto3.client('lambda')
response = lambda_client.delete_function(
  FunctionName='helloWorldLambda'
)
print(response)
