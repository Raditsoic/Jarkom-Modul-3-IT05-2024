echo nameserver 10.66.3.1 > /etc/resolv.conf

apt-get update
apt-get install nginx -y
apt-get install wget -y
apt-get install unzip -y
apt-get install lynx -y
apt-get install htop -y
apt-get install apache2-utils -y
apt-get install php7.3-fpm php7.3-common php7.3-mysql php7.3-gmp php7.3-cur$apt-get install php7.3-fpm -y

service nginx start
service php7.3-fpm start

bash /root/worker-php.sh 