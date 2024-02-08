#!/bin/bash

#Turn on debug-mode
set -x

#Update repositories
sudo apt update -y

#Install build toolse i.e. gcc, g++, make
sudo apt-get install build-essential -y

#Install dependencies required for nginx i.e.  zlib, gzip, Perl Compatible Regular Expressions
sudo apt-get install zlib* gzip* libssl-dev libpcre3 libpcre3-dev -y

#Download Nginx
wget https://nginx.org/download/nginx-1.20.0.tar.gz

#Unzip Nginx
tar -xzf nginx-1.20.0.tar.gz

