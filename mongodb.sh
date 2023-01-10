source common.sh
component=mongod

print_msg "Configure the repo file"
cp ${home_dir}/files/mongo.repo /etc/yum.repos.d/mongo.repo      &>>${log_file}
status_check

package_install


