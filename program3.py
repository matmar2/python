"""As part three of your homework, you are asked to write a program that will ask a user to enter <filename> as an input argument. Secondly, your program should read the file and saves
each line of the file as an element in a list and returns it (Note, the retuned value should not
have “\n”). The input file might look like the following:
Mazda, 21, 6, 160, 110, 3.9, 2.62
Valiant, 18.1, 6, 225, 105, 2.1, 3, 46
Cadillac, 10.4, 8, 472, 205, 2.93, 5.25 """

cars_file_name = input("Enter file name? ")

cars_file = open(cars_file_name,'r')
cars = cars_file.read()
print (cars)


 
