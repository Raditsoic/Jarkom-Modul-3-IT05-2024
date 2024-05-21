echo 'nameserver 10.66.3.1' > /etc/resolv.conf
apt-get update
apt-get install apache2-utils -y
apt-get install nginx -y
apt-get install lynx -y
apt-get install bind9 -y

service nginx start