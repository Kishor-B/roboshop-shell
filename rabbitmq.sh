source common.sh
init_serv=""

print_msg "Configure the repos for erlang message server"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | sudo bash &>>${log_file}
status_check


component=erlang
package_install

print_msg "#Configure the repos for rabbimq message server"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>>${log_file}
status_check

component=rabbitmq-server
package_install

print_msg "set server credentials for rabbitmq server by erase default passwords"
rabbitmqctl add_user roboshop ${rabbitmq_password}  &>>${log_file}
status_check

print_msg "Set Tags for user roboshop"
rabbitmqctl set_user_tags roboshop administrator    &>>${log_file}
status_check

print_msg "set permissions to user roboshop"
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"   &>>${log_file}
status_check
