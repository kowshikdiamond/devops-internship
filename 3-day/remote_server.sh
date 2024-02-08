#!/bin/bash

set -x 

# Remote server details, passing details through command line arguments
remote_user="$1"
remote_host="$2"

# Files to be copied from local machine to remote server
#List file names in a array
files=("install_dependencies.sh" "nginx_installation.sh" "nginx.service" "nginx.conf" "index.html" "style.css" "start_service.sh")

# Copy files to the remote server without fingerprint checking
scp -o StrictHostKeyChecking=no "${files[@]}" $remote_user@$remote_host:~

# SSH command to execute the script on the remote server 
ssh -o StrictHostKeyChecking=no $remote_user@$remote_host "chmod +x install_dependencies.sh && sudo bash install_dependencies.sh"
ssh -o StrictHostKeyChecking=no $remote_user@$remote_host "chmod +x nginx_installation.sh && sudo bash nginx_installation.sh"
ssh -o StrictHostKeyChecking=no $remote_user@$remote_host "chmod +x start_service.sh && sudo bash start_service.sh"