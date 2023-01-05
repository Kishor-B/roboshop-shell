HOME_DIR=$(pwd)

cp ${HOME_DIR}/files/mongo.repo /etc/yum.repos.d/mongo.repo

#install mongo db
yum install mongodb-org -y

#Enable and start service
systemctl enable mongod
systemctl start mongod

#replace default bind ID with 0.0.0.0
sed -i -e 's/127.0.0.1/0.0.0.0/'  /etc/mongod.conf

#restart the mongo db service
systemctl restart mongod