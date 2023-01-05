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
curl -L -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart.zip
cd /app
unzip /tmp/cart.zip

#Install dependencies
cd /app
npm install

#configure cart.service
cp ${HOME_DIR}/files/cart.service  /etc/systemd/system/cart.service

#Reload services and enable cart service
systemctl daemon-reload
systemctl enable cart
systemctl start cart

