source common.sh
component=redis

print_msg "install repo file from web"
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y    &>>${log_file}
status_check

print_msg "***** Enable Redis6.2 from package stream ( seems developer wants to install version 6.2 )"
dnf module enable redis:remi-6.2 -y    &>>${log_file}
status_check

package_install

