mysql <<EOF
CREATE USER 'kelompokit05'@'%' IDENTIFIED BY 'passwordit05';
CREATE USER 'kelompokit05'@'localhost' IDENTIFIED BY 'passwordit05';
CREATE DATABASE dbkelompokit05;
GRANT ALL PRIVILEGES ON dbkelompokit05.* TO 'kelompokit05'@'%';
GRANT ALL PRIVILEGES ON dbkelompokit05.* TO 'kelompokit05'@'localhost';
FLUSH PRIVILEGES;
EOF

echo '[client-server]

!includedir /etc/mysql/conf.d/
!includedir /etc/mysql/mariadb.conf.d/

[mysqld]
skip-networking=0
skip-bind-address
' > /etc/mysql/my.cnf

#tambahkan  bind-address            = 0.0.0.0
#pada /etc/mysql/mariadb.conf.d/50-server.cnf

service mysql restart
