#!/bin/bash

#Check weather  the script is running with sudo permissions
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root or with sudo"
  exit
fi

#Check Weather nginx is installed or not, if not installed install nginx
if command -v nginx &> /dev/null; then
  echo "Nginx is already installed."
else
  apt update
  apt install -y nginx

  echo "Nginx installed successfully."
fi

# Check if Nginx is running, If running display port which it's running
if systemctl is-active --quiet nginx; then
  echo "Nginx is running. Listening ports:"
  netstat -tlpn | grep nginx
else
  echo "Nginx is not running."
fi
