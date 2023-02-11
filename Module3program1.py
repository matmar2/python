#!/bin/bash/python3
"""As part one of your homework, you are asked to write a program that will ask a user to
enter an int number.
If the number is 7 then the program should print "seven",
If the number is 9 then the program should print "nine",
If the number is 1 then the program should print "one",
If the number is 10 then the program should print "ten",
If the number is 5 then the program should print "five",
Otherwise, your program should print "unknown number"
 """
#import csv
import sys

number_entry = int(input("Enter integer number? "))

if number_entry == 7:
    print ("seven")
elif number_entry == 9:
    print("nine")
elif number_entry==10:
    print("ten")
elif number_entry==5:
    print("five")
else:
    print("unknown number")

