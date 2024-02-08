#!/bin/bash

#Turn on debug-mode
set -x

#Make nginx command available at any location
export PATH=/usr/local/nginx/sbin:$PATH

#Display nginx version
nginx -v

#Move nginx service file, so that the nginx is ran as systemd service
sudo mv nginx.service /etc/systemd/system/

# Reload systemd configuration
sudo systemctl daemon-reload

# Start Nginx service
sudo systemctl start nginx

# Enable autostart on boot
sudo systemctl enable nginx

# Display status
sudo systemctl status nginx

sudo mv index.html /usr/local/nginx/sbin/
sudo mv style.css /usr/local/nginx/sbin/
sudo mv nginx.conf /usr/local/nginx/conf/

#Reload Nginx service
sudo /usr/local/nginx/sbin/nginx -s reload