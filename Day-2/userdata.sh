#!/bin/bash
dnf update -y
dnf install -y httpd

echo "Hello, World!" from $(hostname)> /var/www/html/index.html

systemctl enable --now httpd

