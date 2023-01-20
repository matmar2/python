"""As part three of your homework, you are asked to write a program that will ask a user to
enter <filename> as an input argument. Secondly, your program should read the file and saves
each line of the file as an element in a list and returns it (Note, the retuned value should not
have “\n”). The input file might look like the following:
Mazda, 21, 6, 160, 110, 3.9, 2.62
Valiant, 18.1, 6, 225, 105, 2.1, 3, 46
Cadillac, 10.4, 8, 472, 205, 2.93, 5.25
Full version of the file can be downloaded here
(https://gist.github.com/ssheff/9817ab169a7aa6f9143ef7868b3ddda7)
Your program(function) should return a list as the following:
[‘Mazda, 21, 6, 160, 110, 3.9, 2.62’, ‘Valiant, 18.1, 6, 225, 105, 2.1, 3, 46’, ‘Cadillac,
10.4, 8, 472, 205, 2.93, 5.25’]
 """
import csv
import sys

def my_read_function(cars):

    print(cars)
    # Preparing a file
    file_prompt = open(cars, mode='r')

    # Redaing file using realines() function
    car_data = file_prompt.readlines()

    #creating empty list file
    car_output_list =[]

    #stripping "\" from each line"
    for line in car_data:
      line_with_no_new_line=line.strip()
      car_output_list.append(line_with_no_new_line)

    return car_output_list

if __name__ == "__main__":
   print_out_car=my_read_function("cars.csv")
   print(print_out_car)







