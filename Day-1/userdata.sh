#!/bin/bash
dnf update -y
dnf install -y httpd

echo "Hello, World!" > /var/www/html/index.html

systemctl enable --now httpd

if systemctl is-active --quiet firewalld; then
    firewall-cmd --permanent --add-service=http
    firewall-cmd --reload
fi
