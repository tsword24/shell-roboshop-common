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
MONGODB_DOMAIN=mongodb.ssnationals.fun

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
    TOTAL_TIME=$(( $END_TIME -$START_TIME ))
    echo -e "Script excecuted in $Y Seconds $N"
}

nodejs_installation(){
dnf module disable nodejs -y &>>$LOG_FILE
VALIDATE $? "Disabling nodejs" 

dnf module enable nodejs:20 -y &>>$LOG_FILE
VALIDATE $? "enable nodejs 20" 

dnf install nodejs -y &>>$LOG_FILE
VALIDATE $? "Installing nodejs" 

npm install  &>>$LOG_FILE
VALIDATE $? "Installing node packages" 
}

app_setup(){
    id roboshop &>>$LOG_FILE

if [ $? -ne 0 ];then
    useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>>$LOG_FILE
    VALIDATE $? "Creating a user" 
else
    echo -e "User already present $Y Skipping $Y"
fi

mkdir -p /app 
VALIDATE $? "Creating a app directory" 

curl -o /tmp/$app_name.zip https://roboshop-artifacts.s3.amazonaws.com/$app_name-v3.zip  
VALIDATE $? "Downloading zip files" 

cd /app 
VALIDATE $? "Go to app directory" 

rm -rf /app/*
VALIDATE $? "removing the previous data"

unzip /tmp/$app_name.zip &>>$LOG_FILE
VALIDATE $? "unzipping the contents" 

cd /app 
VALIDATE $? "go to app directory" 

}


systemd_setup(){
    cp $DIRECTORY/$app_name.service /etc/systemd/system/$app_name.service
VALIDATE $? "Downloading client side catalogue" 

systemctl daemon-reload
VALIDATE $? "deamon reload" 

systemctl enable $app_name &>>$LOG_FILE
VALIDATE $? "enabling the $app_name" 

systemctl start $app_name
VALIDATE $? "starting  the $app_name" 
}


app_restart(){
    systemctl restart $app_name
    VALIDATE $? "restarting the $app_name"
}