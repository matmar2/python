#!/usr/bin/python3

# Define the name of the output ZIP file
my_lambda_functionzip = 'lambda_function'

# Specify the name of the directory containing the Lambda function code
my_lambda_function = '/home/ec2-user/environment/lambda_function'


import shutil

# Create a ZIP archive of the Lambda function code and the handler module
shutil.make_archive(my_lambda_functionzip, 'zip', my_lambda_function, 'handler.py')