HOME_DIR=$(pwd)
#Setting up nodejs repos
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

#Install nodejs
yum install nodejs -y

#Create application user roboshop
useradd roboshop

#Create application folder
mkdir -p /app

#Download application code
curl -L -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip
cd /app
unzip /tmp/user.zip

#Install dependencies
cd /app
npm install

#configure the user service
cp ${HOME_DIR}/files/user.service  /etc/systemd/system/user.service

#reload all service and start user service
systemctl daemon-reload
systemctl enable user
systemctl start user

#Install mongodb client to load user schemas
cp ${HOME_DIR}/files/mongo.repo /etc/yum.repos.d/mongo.repo
yum install mongodb-org-shell -y
mongo --host mongodb-dev.kbdevops.online </app/schema/user.js
#mongo --host 172.31.7.197 </app/schema/user.js





