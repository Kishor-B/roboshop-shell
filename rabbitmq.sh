
#Configure the repos for erlang message server
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | sudo bash

#Install Erlang software for rabbitmq
yum install erlang -y

#Configure the repos for rabbimq message server
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash

#Install rabbitmq message service
yum install rabbitmq-server -y

#Start the rabbitmq server
systemctl enable rabbitmq-server
systemctl start rabbitmq-server

#set server credentials for rabbitmq server by erase default passwords
rabbitmqctl add_user roboshop roboshop123
rabbitmqctl set_user_tags roboshop administrator
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"

