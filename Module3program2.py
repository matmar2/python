#!/bin/bash/python3
"""As part two of your homework, you are asked to write a program that will ask a user to
provide an input. Additionally, your program will try to handle the error that maybe occur when
a user type in the any type but int. Your program should use try ... except ... else clause. Your
function should print the result if the operation is successful, if the operation is not successful
your program should print (Unpeacefully converted to integer)
 """
#import csv
import sys

#number_entry = int(input("Enter integer number? "))

try:
    number_entry = int(input("Enter integer number? "))
except ValueError:
    print("Unpeacefully converted to integer. You enter the wrong entry. Please enter integer number")

else:
    print("Great! You entered an integer.")
finally:
    print("You may run the program again!")



