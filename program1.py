"""As part one of your homework, you are asked to write a program that will ask a user to
enter his/her age in years as input (make assumption that a user will enter int as input value). It
will then calculate as well as print out how old a user is in term of:
a) days (create and print variable age_days)
b) months (create and print variable age_months)
c) hours. (create and print variable age_hours)
You will also assume that there are 12 month per year, 365 days per year, and 24 hours
per day.
"""
age = int(input("Please enter your age?"))
days = age * 365
months = age * 12
hours = days * 24

print ("Age = ",age)
print ("Days = ", days)
print ("Months = ", months)
print ("Hours = ",hours)


