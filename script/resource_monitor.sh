#!/bin/bash
#This script is created by Mohammad H Najafi in June 2023

cputr="$1"	#cpu threshold
filename="$2"	#log filename


# if the first argument doesn't exist
if [ -z $cputr ]
	then 
	echo "Error: the first argument is missing!"
	echo
	echo "Please enter like this format: ./resource_monitor.sh <cpu_usage_threshold> <log_file>"
	exit 1 		#error occured siganling



# if the first argument is less than 0 or greater than 100
elif [ $cputr -lt 0 ]  || [ $cputr -gt 100 ]
        then
        echo "Error: the first argtment must be a number between 0 and 100."
        echo
        echo "0 < cpu_usage_threshold < 100"
        exit 1          #error occured siganling



# if the second argument doesn't exist
elif [ -z $filename ]
        then 
        echo "Error: the second argument (log filename) is missing!"
        echo
        echo "Please enter like this format: ./resource_monitor.sh <cpu_usage_threshold> <log_file>"
        exit 1          #error occured siganling



# if the filename exists
elif [ -f $filename ]
        then 
        echo "Warning: File already exists. Overwriting..."
        echo
fi
###


#Create log file or if exists delete it then create it
touch "$filename"
###


#Get current date & time into format of "YYYY-MM-DD HH:MM:SS"
current_time=$(date +"%Y-%m-%d %H:%M:%S")
###


#Retrieve the CPU and memory usage values that are non-zero
cm_u=$(top -bn1 | awk ' $9 != "0.0" || $10 != "0.0"')
###


#Determine whether any program exceeds the specified CPU or memory usage threshold
st=$(echo "The following programs are using more than $cputr% CPU or memory: ")
tsh_u=$(top -bn1 | awk -v cputr="$cputr" 'NR>7 && ($9 >= cputr  || $10 >= cputr) {for (i=12; i<=NF; i++) printf("%s ", $i); printf("\n")}')
###
 

#Log CPU & memory usage to file
echo -e "$current_time\n\n$cm_u\n\n$st\n$tsh_u" > $filename
###
