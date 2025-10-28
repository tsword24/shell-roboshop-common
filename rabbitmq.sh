#!/bin/bash

source ./common.sh

check_root


cp $SCRIPT_DIRECTORY/rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo &>>$LOG_FILE
VALIDATE $? "Copying rabbitmq repo"

dnf install rabbitmq-server -y  &>>$LOG_FILE
VALIDATE $? "INstalling rabbitmq server"

systemctl enable rabbitmq-server &>>$LOG_FILE
VALIDATE $? "Enable rabbitmq server"

systemctl start rabbitmq-server &>>$LOG_FILE
VALIDATE $? "Start rabbitmq server"

rabbitmqctl add_user roboshop roboshop123  &>>$LOG_FILE
VALIDATE $? "Adding user in  rabbitmq server"

rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"
VALIDATE $? "Setting permissions in  rabbitmq server"

print_total_time