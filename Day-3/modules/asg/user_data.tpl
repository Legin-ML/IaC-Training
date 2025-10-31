#!/bin/bash

dnf update -y
dnf install -y python3 git

curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python3 get-pip.py

cd /home/ec2-user
git clone https://github.com/Legin-ML/sample-flask-app.git
cd sample-flask-app

python3 -m pip install -r requirements.txt

cat <<EOL > /etc/systemd/system/todoapp.service
[Unit]
Description=Todo Application
After=network.target

[Service]
ExecStart=/usr/bin/python3 /home/ec2-user/sample-flask-app/app.py
WorkingDirectory=/home/ec2-user/sample-flask-app
Restart=always
User=ec2-user
Group=ec2-user
Environment=DB_HOST=${db_host}
Environment=DB_PORT=${db_port}
Environment=DB_NAME=${db_name}
Environment=DB_USER=${db_username}
Environment=DB_PASSWORD=${db_password}

[Install]
WantedBy=multi-user.target
EOL

systemctl daemon-reload
systemctl enable todoapp.service
systemctl start todoapp.service
