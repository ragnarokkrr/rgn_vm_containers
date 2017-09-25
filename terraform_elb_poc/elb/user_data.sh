#!/bin/bash
sudo apt-get update
sudo apt-get install -y apache2
#echo "Hello, World" > index.html
#nohup busybox httpd -f -p "${var.server_port}" &


sudo apt-get install software-properties-common
sudo apt-add-repository -y ppa:ansible/ansible
sudo apt-get update
sudo apt-get install -y ansible
