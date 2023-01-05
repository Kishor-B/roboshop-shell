HOME_DIR=$(pwd)
#Centos 8 is coming with mysql default with version 8, but application needs 5.7, so disabling mysql
dnf module disable mysql -y

#configure the mysql repo for 5.7
cp ${HOME_DIR}/files/mysql.repo /etc/yum.repos.d/mysql.repo

#Install mysql server
yum install mysql-community-server -y

#start mysql service
systemctl enable mysqld
systemctl start mysqld

#Creating default password for mysql user 'root'
mysql_secure_installation --set-root-pass RoboShop@1


