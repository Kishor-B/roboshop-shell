source common.sh
component=nginx
set_service=false

package_install

if [[ ! -e /tmp/frontend.zip ]] ;then
print_msg "Downloading frontend source code"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${log_file}
status_check
else
  print_msg "frontend source code is already avaialble, skip download again"
fi

print_msg "changing to default directory ."
cd /usr/share/nginx/html/   &>>${log_file}
status_check

print_msg "Extract the front end content."
unzip /tmp/frontend.zip     &>>${log_file}
status_check

print_msg "Create and configure nginx reverse proxy file"
cp  ${home_dir}/files/nginx-roboshop-rev-proxy.conf  /etc/nginx/default.d/roboshop.conf     &>>${log_file}
status_check

print_msg "Restarting nginx server"
systemctl restart nginx     &>>${log_file}
status_check
