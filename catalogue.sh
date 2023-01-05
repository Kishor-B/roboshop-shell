HOME_DIR=$(pwd)

#Setup repository for node js
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

#Install nodejs
yum install nodejs -y

#Application configuration :
useradd roboshop
mkdir -p /app

#Download Application code
curl -L -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
cd /app
unzip /tmp/catalogue.zip

#Download dependencies
cd /app
npm install

#Setup new service for catalogue
cp ${HOME_DIR}/files/catalogue.service /etc/systemd/system/catalogue.service

#Reload the service
systemctl daemon-reload

#Start service
systemctl enable catalogue
systemctl start catalogue

#creating repo for mongo db client
cp ${HOME_DIR}/files/mongo.repo /etc/yum.repos.d/mongo.repo

#Install mongo db client
yum install mongodb-org-shell -y

#Load schema
#mongo --host mongodb-dev.kbdevops.online < /app/schema/catalogue.js
mongo --host 172.31.15.246 < /app/schema/catalogue.js



#Install mongo client on catalogue server to load schema


