#!/bin/bash

source ./common.sh
app_name=shipping
check_root
app_setup
java_installation
systemd_setup
dnf install mysql -y &>>$LOG_FILE
VALIDATE $? "Installing mysql"

mysql -h $MYSQL_DOMAIN -uroot -pRoboShop@1 -e 'use cities' &>>$LOG_FILE
if [ $? -ne 0 ];then
    mysql -h $MYSQL_DOMAIN -uroot -pRoboShop@1 < /app/db/schema.sql &>>$LOG_FILE
    mysql -h $MYSQL_DOMAIN -uroot -pRoboShop@1 < /app/db/app-user.sql  &>>$LOG_FILE
    mysql -h $MYSQL_DOMAIN -uroot -pRoboShop@1 < /app/db/master-data.sql &>>$LOG_FILE
else
    echo -e "Shipping data already loaded $Y Skipping $N"
fi
app_restart
print_total_time