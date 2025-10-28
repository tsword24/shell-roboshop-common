#!/bin/bash

source ./common.sh
app_name=catalogue
nodejs_installation
app_setup
systemd_setup

cp $DIRECTORY/mongo.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? "copying the mongo repo" 

dnf install mongodb-mongosh -y 
if [ $? -ne 0 ];then
    useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>>$LOG_FILE
    VALIDATE $? "Creating a user" 
else
    echo -e "User already present $Y Skipping $Y"
fi
VALIDATE $? "Installing mongo repo" 

INDEX=$(mongosh mongodb.ssnationals.fun --quiet --eval "db.getMongo().getDBNames().indexOf('catalogue')")
if [ $INDEX -lt 0 ];then
    mongosh --host $MONGODB_DOMAIN </app/db/master-data.js &>>$LOG_FILE
    VALIDATE $? "Connecting to mongo" 
else
    echo -e "Products already loaded $Y Skipping $N"
fi

app_restart

print_total_time