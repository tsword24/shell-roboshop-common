#!/bin/bash

source ./common.sh
app_name=payment
check_root
app_setup
python_installation
systemd_setup
app_restart
print_total_time