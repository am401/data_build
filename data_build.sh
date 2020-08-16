#!/bin/bash
############################
# Created by: Andras Marton
# Date: 16th August 2020
# Description: Build out a table breakdown of hourly NGINX requests for the last three days for a 
#              specific install/site. The table then can be fed as a data file to termgraph.
############################

# Check if an install name has been provided. If not - prompt the user for one.
if [[ -z $1 ]]; then
   read -p "Please provide the install name: " INSTALL
   INSTALL=$(echo "$INSTALL" | tr '[:upper:]' '[:lower:]')
else
   INSTALL="$1"
   INSTALL=$(echo "$INSTALL" | tr '[:upper:]' '[:lower:]')
fi

# Check if the install exists on the pod this script is running on.
if [[ ! -d /nas/content/live/$INSTALL ]]; then
   echo -e "\n$INSTALL does not exist on this pod.\n"
   exit 0
fi

# Build the column that will be used as the key in the graph. The column will start from 00:00 to 23:00.
LOG_TIME=$(for i in {00..23}; do printf "%02s:00\n" "$i"; done)

# Grab the date for the file in question.
LOG_DATE_ONE=$(head -n1 /var/log/nginx/$INSTALL.access.log | awk -F: '{print $1}')
LOG_DATE_TWO=$(head -n1 /var/log/nginx/$INSTALL.access.log.1 | awk -F: '{print $1}')
LOG_DATE_THREE=$(zcat /var/log/nginx/$INSTALL.access.log.2.gz | head -n1 | awk -F: '{print $1}')

# Build the columns of request numbers per hour.
LOG_ONE=$(less /var/log/nginx/$INSTALL.access.log | awk -F: '{print $2}' | sort | uniq -c | awk '{print $1}')
LOG_TWO=$(less /var/log/nginx/$INSTALL.access.log.1 | awk -F: '{print $2}' | sort | uniq -c | awk '{print $1}')
LOG_THREE=$(zcat /var/log/nginx/$INSTALL.access.log.2.gz | awk -F: '{print $2}' | sort | uniq -c | awk '{print $1}')


printf "Copy the below output in order to build the data file:\n\n"

# Print the date values as a key.
printf "@ %s,%s,%s\n" "$LOG_DATE_ONE" "$LOG_DATE_TWO" "$LOG_DATE_THREE"

# Print the table including the time and the values retrieved from the logs. Due to termgraph not accepting blank spaces
# I have added the awk pipe to the end in order to replace any missing values.
paste <(printf "%s" "$LOG_TIME") <(printf "%s" "$LOG_ONE") <(printf "%s" "$LOG_TWO") <(printf "%s" "$LOG_THREE") | \
        awk 'BEGIN { FS = OFS = "\t" } { for(i=1; i<=NF; i++) if($i ~ /^ *$/) $i = 0 }; 1'
