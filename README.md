# System-Resource-Monitoring
This script is designed to monitor the resource usage of different processes running on a Linux system. It takes two input arguments: the CPU and memory usage thresholds, and the name of the log file where the resource usage values will be logged.

## Usage
1. Save the script as `resource_monitor.sh`.
2. Make the script executable by running the command:
```bash
    $ chmod +x resource_monitor.sh
```
3. Run the script with the desired CPU and memory usage thresholds and provide a log file name. For example:
```bash
   $ ./resource_monitor.sh 10 system_monitor.log
```
This command will monitor the system with a CPU usage threshold of 10% and save the log to a file named system_monitor.log.
4. To view the log output, use the following command:
```bash
   $ cat system_monitor.log
```

## Features
The script performs the following tasks:

1. Checks the input arguments using conditional statements to ensure they are entered correctly. If the input format is incorrect, the script will return an error message and terminate.
2. Uses the top command and AWK to extract the CPU and memory usage values of different processes.
3. Writes the CPU and memory usage values to the specified log file.
3. Ignores processes that are using 0% CPU and memory, as they are not significant resource consumers.
4. Logs the processes whose CPU or memory usage values exceed the specified thresholds, helping identify resource-intensive processes that may affect system performance.
5. Creates a log file if it doesn't exist or overwrites it if it already exists.
6. Includes the current date and time in the log file for each execution.
7. Provides flexibility to specify the log file name.

## Script
```bash
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
```