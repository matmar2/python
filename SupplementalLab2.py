"""Objective: Develop a python script that will open
multiple files, read the file, manipulate the data, and
write the modified data to a separate output file.

Real World Scenario: You work for a bank that is rapidly growing and have been acquiring
many other banks on a consistent basis. The bank is 3 acquisitions away from meeting
this years fiscal goal and the fiscal year is coming to close very shortly. Part of the
process to complete acquisitions is to get inventory into the banks database.
Unfortunately not all banks use the same inventory tool and therefore the output they
provide will have inconsistent field names, inconsistent value lengths, etc. Fortunately the
one consistency is that all the files the acquired banks provide are CSV files. You have
been tasked by your manager to consolidate these inventory reports into one single report
so that you can load the data into the banks inventory database.
"""

#import pandas module
import pandas as pd

#Read the csv files
dfA=pd.read_csv("Inventories/yellowtail_fcu.csv")
dfB=pd.read_csv("Inventories/yellowtail_financial_services.csv") 
dfC=pd.read_csv("Inventories/yellowtail_national_bank.csv")

#Rename the columns of 2nd and 3rd files to match the ones in the first file fcu.csv
dfB=dfB.rename(columns={'Name':'Host','IP':'IP Address','Dept':'Department','Operating System': 'OS'})
dfC=dfC.rename(columns={'hostname':'Host','IPAddress':'IP Address'})

#Merge on all common columns
df1 = pd.merge(dfA,dfB, on=list(set(dfA.columns) & set(dfB.columns)), how='outer')

#only keep the columns that exists in fcu.csv
df1=df1[dfA.columns]

#save to a new csv
df1.to_csv("Inventories/output_first2files.csv",index=False)


#merging output_first2files.csv (dfD) with dfC

dfD=pd.read_csv("Inventories/output_first2files.csv")

#Merge on all common columns
df2 = pd.merge(dfD,dfC, on=list(set(dfD.columns) & set(dfC.columns)), how='outer')

#only keep the columns that exists in fcu.csv = dfD
df2=df2[dfD.columns]

#save to a new csv
df2.to_csv("Inventories/output_final_all3files.csv",index=False)

