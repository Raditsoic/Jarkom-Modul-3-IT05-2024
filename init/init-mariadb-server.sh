echo nameserver 10.66.3.1 > /etc/resolv.conf

apt-get update
apt-get install mariadb-server -y
service mysql start

bash root/mariadb-server.sh