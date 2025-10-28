#!/bin/bash

source ./common.sh

check_root

dnf install mysql-server -y &>> $LOG_FILE
VALIDATE $? "Installing mysql"

systemctl enable mysqld &>> $LOG_FILE
VALIDATE $? "Enable mysql"

systemctl start mysqld  &>> $LOG_FILE
VALIDATE $? "Starting mysql server"

mysql_secure_installation --set-root-pass RoboShop@1
VALIDATE $? "Create user with Password"

 print_total_time