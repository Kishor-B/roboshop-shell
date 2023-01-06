HOME_DIR=$(pwd)
#Install python
yum install python36 gcc python3-devel -y

#Add applicatoin user and app directory
useradd roboshop
mkdir -p /app

#Download the application code
curl -L -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment.zip
cd /app
unzip /tmp/payment.zip

#Download dependencies
cd /app
pip3.6 install -r requirements.txt

#Configure payment service
cp ${HOME_DIR}/files/payment.service /etc/systemd/system/payment.service


#Reload all services and start payment service
systemctl daemon-reload
systemctl enable payment
systemctl start payment

