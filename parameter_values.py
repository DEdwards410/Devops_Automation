'''
This script takes the input from a csv file (name of parameter and parameter vale)
and updates the value in parameter store, overwriting the current value and reflecting
that to an updated version number  
'''


import boto3
import csv


client = boto3.client('ssm')

List_of_Names = []
List_of_Value = []
with open("secrets.csv") as file:
    secrets = csv.reader(file)
    for row in secrets:
        Name = row[0]
        Value = row[1]
        List_of_Names.append(Name)
        List_of_Value.append(Value)

#print (List_of_Names,List_of_Value)


for x in range(1, len(List_of_Names)):
    response = client.put_parameter(Name=List_of_Names[x], Value=List_of_Value[x],
                                    Type='String', Overwrite=True,
                                    # AllowedPattern='string',
                                    Tier='Standard', DataType='text'
                                    )

print(response)
