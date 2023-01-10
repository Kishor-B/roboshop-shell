home_dir=$(pwd)
log_file=/tmp/roboshop.log


print_msg(){

    echo -e "\e[1m $1 \e[0m"
}

status_check(){

  if [ $? -eq 0 ]
  then
        echo -e "\e[1;32m SUCCESS \e[0m"
  else
        echo -e "\e[1;31m FAILURE \e[0m"
        exit
  fi

}

start_service(){


print_msg "Enable and start service"
systemctl enable $1      &>>${log_file}
status_check

print_msg "Start service"
systemctl start $1      &>>${log_file}
status_check


}


package_install(){


  if [ ${component} == "mongod" ]
  then
      print_msg "install mongo db"
      yum install mongodb-org -y      &>>${log_file}
      status_check
  elif [ ${component} == "mysql" ]
  then
         print_msg "configure the mysql repo for 5.7"
         cp ${home_dir}/files/${component}.repo /etc/yum.repos.d/${component}.repo    &>>${log_file}
         status_check

         print_msg "Install mysql server"
         yum install mysql-community-server -y    &>>${log_file}
         status_check

         start_service mysqld

         print_msg "Setting up root password for mysql db"
         mysql_secure_installation --set-root-pass ${mysql_root_password}     &>>${log_file}
         status_check

         return
  else

      print_msg "Installing ${component} "
      yum install ${component} -y   &>>${log_file}
      status_check
      if [ ${init_serv} == "true" ]
      then
         start_service ${component}
      fi
      if [ ${component} == "nginx" ]
      then
        print_msg "Removing default html from nginx server"
        rm -rf /usr/share/nginx/html/*  &>>${log_file}
        status_check
        start_service ${component}
      fi
  fi

  if [[ ${component} == "redis" || ${component} == "mongod" ]]
  then
    print_msg "Replace the bind id in  /etc/${component}.conf ( 127.0.0.1 to 0.0.0.0 )"
    sed -i -e 's/127.0.0.1/0.0.0.0/'  /etc/${component}.conf      &>>${log_file}
    status_check
    start_service ${component}
  fi




}


service_setup(){

  if [ ${component} == "nodejs" ]
  then
      print_msg "Setup repository for node js"
      curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log_file}
      status_check

      print_msg "Install nodejs"
      yum install nodejs -y &>>${log_file}
      status_check
  fi

  print_msg "Create user roboshop"
  id roboshop &>>${log_file}
  if [ $? -eq 0 ]
  then
      print_msg "User roboshop already exists , skip creating user"
  else
      useradd roboshop &>>${log_file}
      status_check
  fi

  print_msg "Creating application home directory"
  mkdir -p /app &>>${log_file}
  status_check

  print_msg "Download ${set_service} source code"
  curl -L -o /tmp/${set_service}.zip https://roboshop-artifacts.s3.amazonaws.com/${set_service}.zip &>>${log_file}
  status_check

  print_msg "Extracting  ${set_service} source code"
  cd /app
  unzip /tmp/${set_service}.zip &>>${log_file}
  status_check

  if [ ${set_service} == "payment" ]
  then
    print_msg "Download dependencies from pip3.6"
    cd /app
    pip3.6 install -r requirements.txt      &>>${log_file}
    status_check
  elif [ ${set_service} == "dispatch" ]
  then
    print_msg "Download the dependencies for golang"
    cd /app
    print_msg "Initiate the module for dispatch"
    go mod init dispatch      &>>${log_file}
    status_check
    print_msg "Get the dependencies"
    go get      &>>${log_file}
    status_check
    print_msg "Build Code"
    go build      &>>${log_file}
    status_check
  elif [ ${set_service} == "shipping" ]
  then
    cd /app
    print_msg "Build maven package"
    mvn clean package      &>>${log_file}
    status_check
    print_msg "Moving jar to app folder"
    mv target/${set_service}-1.0.jar ${set_service}.jar      &>>${log_file}
    status_check
  else
    print_msg "Download dependencies"
    cd /app
    npm install  &>>${log_file}
    status_check
  fi

  print_msg "Configuration Setup for new service - ${set_service}"
  cp ${home_dir}/files/${set_service}.service /etc/systemd/system/${set_service}.service &>>${log_file}
  status_check

  print_msg "Reload all service configurations "
  systemctl daemon-reload &>>${log_file}
  status_check

  start_service ${set_service}

}

load_db_schema(){

 if [ $1 == "mongo" ]
 then
   print_msg "creating repo for mongo db client"
   cp ${home_dir}/files/mongo.repo /etc/yum.repos.d/mongo.repo     &>>${log_file}
   status_check

   print_msg "Install mongo db client"
   yum install mongodb-org-shell -y      &>>${log_file}
   status_check

   print_msg "Loading mongo db schema "
   mongo --host mongodb-dev.kbdevops.online < /app/schema/${set_service}.js     &>>${log_file}
   status_check
 elif [ $1 == "mysql" ]
 then
   print_msg "Installing mysql client"
   labauto mysql-client     &>>${log_file}
   status_check

   print_msg "Loading ${set_service} schema"
   mysql -h mysql-dev.kbdevops.online -uroot -p${mysql_root_password} < /app/schema/${set_service}.sql      &>>${log_file}
   status_check

 fi

}