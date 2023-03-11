#!/usr/bin/python3

import boto3
import json

def lambda_handler(event, context):
    response = {
        'statusCode': 200,
        'body': json.dumps('Hello from Lambda!')
    }
    return response
    
# Call the lambda_handler function
result = lambda_handler(None, None)

# Print the JSON response
print(result['body']) 