#install repo file from web
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y

#***** Enable Redis6.2 from package stream ( seems developer wants to install version 6.2 )
dnf module enable redis:remi-6.2. -y

#Install redis server
yum install redis -y

#Replace the bind id in  /etc/redis.conf ( 127.0.0.1 to 0.0.0.0 )
sed -i -e 's/127.0.0.1/0.0.0.0/'  /etc/redis.conf

#Start the redis service
systemctl enable redis
systemctl start redis

