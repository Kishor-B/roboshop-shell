HOME_DIR=$(pwd)
#Installing java package manager maven
yum install maven -y

#Create application user
useradd roboshop

#Create application directory
mkdir -p /app

#Download the application code
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip
cd /app
unzip /tmp/shipping.zip

#Build application
cd /app
mvn clean package
mv target/shipping-1.0.jar shipping.jar

#configuration of shipping service
cp ${HOME_DIR}/files/shipping.service  /etc/systemd/system/shipping.service

#Start and load service
systemctl daemon-reload
systemctl enable shipping
systemctl start shipping

labauto mysql-client
mysql -h mysql-dev.kbdevops.online -uroot -pRoboShop@1 < /app/schema/shipping.sql
#mysql -h 172.31.3.154 -uroot -pRoboShop@1 < /app/schema/shipping.sql