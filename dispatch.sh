HOME_DIR=$(pwd)

#Install golang
yum install golang -y

#Create applicaiton user and app folder
useradd roboshop
mkdir -p /app

#Download application code
curl -L -o /tmp/dispatch.zip https://roboshop-artifacts.s3.amazonaws.com/dispatch.zip
cd /app
unzip /tmp/dispatch.zip

#Download the dependencies
cd /app
go mod init dispatch
go get
go build

#Configure dispatch service
cp ${HOME_DIR}/files/dispatch.service /etc/systemd/system/dispatch.service

#Reload all services and start dispatch service
systemctl daemon-reload
systemctl enable dispatch
systemctl start dispatch


