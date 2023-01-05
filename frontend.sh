HOME_DIR=$(pwd)
yum install nginx -y

sytemctl enable nginx

systemctl start nginx

#Change the default index.html that nginx webserver is serving
rm -rf /usr/share/nginx/html/*

#Down load content for front-end.
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip

#Extract the front end content.
cd /usr/share/nginx/html/
unzip /tmp/frontend.zip

#Create nginx reverse proxy file
cp  ${HOME_DIR}/files/nginx-roboshop-rev-proxy.conf  /etc/nginx/default.d/roboshop.conf

systemctl restart nginx