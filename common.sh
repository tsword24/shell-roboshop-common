#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
USERID=$(id -u)

LOGS_FOLDER="/var/log/shell-roboshop"
SCRIPT_NAME="$( echo $0 | cut -d "." -f1)" #to get the script name
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log"
START_TIME=$(date +%s)

mkdir -p $LOGS_FOLDER
echo "Script Started at $(date)" | tee -a $LOG_FILE

check_root(){
if [ $USERID -ne 0 ]; then 
    echo "Give root privilages"
    exit 1
fi
}

VALIDATE(){
    if [ $1 -eq 0 ];then
        echo -e " $2 $G success$N"  | tee -a $LOG_FILE
    else
        echo -e " $2 $R Failure$N" | tee -a $LOG_FILE
        exit 1 
    fi
}

print_total_time(){
    END_TIME=$(date +%s)
    TOTAL_TIME=$(($END_TIME -$START_TIME ))
    echo -e "Script excecuted in $Y Seconds $N"
}