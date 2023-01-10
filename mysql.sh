source common.sh
component=mysql

print_msg "Centos 8 is coming with mysql default with version 8, but application needs 5.7, so disabling mysql"
dnf module disable mysql -y   &>>${log_file}
status_check


package_install



