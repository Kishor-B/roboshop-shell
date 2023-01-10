source common.sh
set_service=payment
component=" "

print_msg "Install python"
yum install python36 gcc python3-devel -y  &>>${log_file}
status_check

service_setup


