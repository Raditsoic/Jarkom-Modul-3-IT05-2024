<div align=center>

# Laporan Resmi Modul 3 Jaringan Komputer

</div>

## Anggota Kelompok

|Nama|NRP|
|--|--|
|Fazrul Ahmad Fadhillah|5027221025|
|Awang Fraditya|5027221055|

## TOPOLOGI
![alt text](/image/topologi.png)

## CONFIG
Arakis (DHCP Relay)
```sh
auto eth0
iface eth0 inet dhcp
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s 10.66.0.0/16

auto eth1
iface eth1 inet static
	address 10.66.1.0
	netmask 255.255.255.0

auto eth2
iface eth2 inet static
	address 10.66.2.0
	netmask 255.255.255.0

auto eth3
iface eth3 inet static
	address 10.66.3.0
	netmask 255.255.255.0

auto eth4
iface eth4 inet static
	address 10.66.4.0
	netmask 255.255.255.0

```

Mohiam (DHCP Server)
```sh
auto eth0
iface eth0 inet static
	address 10.66.3.2
	netmask 255.255.255.0
	gateway 10.66.3.0

```

Irulan (DNS Server)
```sh
auto eth0
iface eth0 inet static
	address 10.66.3.1
	netmask 255.255.255.0
	gateway 10.66.3.0
```

Chani (Database Server)
```sh
auto eth0
iface eth0 inet static
	address 10.66.4.1
	netmask 255.255.255.0
	gateway 10.66.4.0
```

Stilgar (Load Balancer)
```sh
auto eth0
iface eth0 inet static
	address 10.66.4.2
	netmask 255.255.255.0
	gateway 10.66.4.0
```

Leto (Laravel Worker)
```sh
auto eth0
iface eth0 inet static
	address 10.66.2.1
	netmask 255.255.255.0
	gateway 10.66.2.0
```

Duncan (Laravel Worker)
```sh
auto eth0
iface eth0 inet static
	address 10.66.2.2
	netmask 255.255.255.0
	gateway 10.66.2.0
```

Jessica (Laravel Worker)
```sh
auto eth0
iface eth0 inet static
	address 10.66.2.3
	netmask 255.255.255.0
	gateway 10.66.2.0
```

Vladimir (PHP Worker)
```sh
auto eth0
iface eth0 inet static
	address 10.66.1.1
	netmask 255.255.255.0
	gateway 10.66.1.0
```

Rabban (PHP Worker)
```sh
auto eth0
iface eth0 inet static
	address 10.66.1.2
	netmask 255.255.255.0
	gateway 10.66.1.0
```

Feyd (PHP Worker)
```sh
auto eth0
iface eth0 inet static
	address 10.66.1.3
	netmask 255.255.255.0
	gateway 10.66.1.0

```

Dmitri & Paul (Client)
```sh
auto eth0
iface eth0 inet dhcp
```

## Soal 0 s.d 5
Planet Caladan sedang mengalami krisis karena kehabisan spice, klan atreides berencana untuk melakukan eksplorasi ke planet arakis dipimpin oleh duke leto mereka meregister domain name atreides.yyy.com untuk worker Laravel mengarah pada Leto Atreides . Namun ternyata tidak hanya klan atreides yang berusaha melakukan eksplorasi, Klan harkonen sudah mendaftarkan domain name harkonen.yyy.com untuk worker PHP (0) mengarah pada Vladimir Harkonen

Lakukan konfigurasi sesuai dengan peta yang sudah diberikan. (1)

Kemudian, karena masih banyak spice yang harus dikumpulkan, bantulah para aterides untuk bersaing dengan harkonen dengan kriteria berikut.:
- Semua CLIENT harus menggunakan konfigurasi dari DHCP Server.
- Client yang melalui House Harkonen mendapatkan range IP dari [prefix IP].1.14 - [prefix IP].1.28 dan [prefix IP].1.49 - [prefix IP].1.70 (2)
- Client yang melalui House Atreides mendapatkan range IP dari [prefix IP].2.15 - [prefix IP].2.25 dan [prefix IP].2 .200 - [prefix IP].2.210 (3)
- Client mendapatkan DNS dari Princess Irulan dan dapat terhubung dengan internet melalui DNS tersebut (4)
- Durasi DHCP server meminjamkan alamat IP kepada Client yang melalui House Harkonen selama 5 menit sedangkan pada client yang melalui House Atreides selama 20 menit. Dengan waktu maksimal dialokasikan untuk peminjaman alamat IP selama 87 menit (5)
*house == switch
 
 ### JAWABAN

 - Script pada Irulan (DNS Server):
 ```sh
 echo 'zone "atreides.it05.com" {
    type master;
    file "/etc/bind/jarkom/atreides.it05.com";
};

zone "harkonen.it05.com" {
    type master;
    file "/etc/bind/jarkom/harkonen.it05.com";
};' > /etc/bind/named.conf.local


mkdir -p /etc/bind/jarkom
cp /etc/bind/db.local /etc/bind/jarkom/atreides.it05.com
cp /etc/bind/db.local /etc/bind/jarkom/harkonen.it05.com

echo ';
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA     atreides.it05.com. root.atreides.it05.com. (
                        2023111401      ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      atreides.it05.com.
@       IN      A       10.66.2.1     ; IP Leto
' > /etc/bind/jarkom/atreides.it05.com

echo '
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA     harkonen.it05.com. root.harkonen.it05.com. (
                        2023111401      ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      harkonen.it05.com.
@       IN      A       10.66.1.1     ; IP Vladimir
' > /etc/bind/jarkom/harkonen.it05.com

echo 'options {
      directory "/var/cache/bind";

      forwarders {
              192.168.122.1;
      };

      // dnssec-validation auto;
      allow-query{any;};
      auth-nxdomain no;
      listen-on-v6 { any; };
}; ' >/etc/bind/named.conf.options

service bind9 start
```

- Script pada Mohiam (DHCP Server):
```sh
echo 'INTERFACESv4="eth0"' > /etc/default/isc-dhcp-server

echo 'subnet 10.66.1.0 netmask 255.255.255.0 {
    range 10.66.1.14 10.66.1.28;
    range 10.66.1.49 10.66.1.70;
    option routers 10.66.1.0;
    option broadcast-address 10.66.1.255;
    option domain-name-servers 10.66.3.1;
    default-lease-time 300;
    max-lease-time 5220;
}

subnet 10.66.2.0 netmask 255.255.255.0 {
    range 10.66.2.15 10.66.2.25;
    range 10.66.2.200 10.66.2.210;
    option routers 10.66.2.0;
    option broadcast-address 10.66.2.255;
    option domain-name-servers 10.66.3.1;
    default-lease-time 1200;
    max-lease-time 5220;
}

subnet 10.66.3.0 netmask 255.255.255.0 {
}

subnet 10.66.4.0 netmask 255.255.255.0 {
}' > /etc/dhcp/dhcpd.conf

service isc-dhcp-server restart
```


## Soal 6 s.d 12
Seiring berjalannya waktu kondisi semakin memanas, untuk bersiap perang. Klan Harkonen melakukan deployment sebagai berikut
- Vladimir Harkonen memerintahkan setiap worker(harkonen) PHP, untuk melakukan konfigurasi virtual host untuk website berikut dengan menggunakan php 7.3. (6)
- Aturlah agar Stilgar dari fremen dapat dapat bekerja sama dengan maksimal, lalu lakukan testing dengan 5000 request dan 150 request/second. (7)
- Karena diminta untuk menuliskan peta tercepat menuju spice, buatlah analisis hasil testing dengan 500 request dan 50 request/second masing-masing algoritma Load Balancer dengan ketentuan sebagai berikut:
    - Nama Algoritma Load Balancer
    - Report hasil testing pada Apache Benchmark
    - Grafik request per second untuk masing masing algoritma. 
    - Analisis (8)

- Dengan menggunakan algoritma Least-Connection, lakukan testing dengan menggunakan 3 worker, 2 worker, dan 1 worker sebanyak 1000 request dengan 10 request/second, kemudian tambahkan grafiknya pada peta. (9)
- Selanjutnya coba tambahkan keamanan dengan konfigurasi autentikasi di LB dengan dengan kombinasi username: “secmart” dan password: “kcksyyy”, dengan yyy merupakan kode kelompok. Terakhir simpan file “htpasswd” nya di /etc/nginx/supersecret/ (10)
- Lalu buat untuk setiap request yang mengandung /dune akan di proxy passing menuju halaman https://www.dunemovie.com.au/. (11) hint: (proxy_pass)
- Selanjutnya LB ini hanya boleh diakses oleh client dengan IP [Prefix IP].1.37, [Prefix IP].1.67, [Prefix IP].2.203, dan [Prefix IP].2.207. (12) hint: (fixed in dulu clientnya)

### JAWABAN
6.  Script worker-php.sh pada Vladimir, Rabban, dan Feyd (PHP Worker):
```sh
wget -O 'harkonen.zip' 'https://drive.google.com/u/0/uc?id=1lmnXJUbyx1JDt2OA5z_1dEowxozfkn30&export=download'
unzip harkonen.zip
rm harkonen.zip
mv modul-3 /var/www/harkonen.it05.com

cp /etc/nginx/sites-available/default /etc/nginx/sites-available/harkonen.it05.com
ln -s /etc/nginx/sites-available/harkonen.it05.com /etc/nginx/sites-enabled/
rm /etc/nginx/sites-enabled/default

echo 'server {
    listen 80;
    server_name harkonen.it05.com;

    root /var/www/harkonen.it05.com;
    index index.php index.html index.htm;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php7.3-fpm.sock; 
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
    }
}' > /etc/nginx/sites-available/harkonen.it05.com

service nginx restart
```
7. Script lb.sh pada Stilgar (Load Balancer):
```sh
echo 'zone "harkonen.it05.com" {
    type master;
        file "/etc/bind/jarkom/harkonen.it05.com";
}' > /etc/bind/named.conf.local

mkdir /etc/bind/jarkom

echo ';
 ; BIND data file for local loopback interface
 ;
 $TTL    604800
 @       IN      SOA     harkonen.it05.com. root.harkonen.it05.com. (
                        2023111401  ; Serial
                                604800      ; Refresh
                                86400       ; Retry
                                2419200     ; Expire
                                604800 )    ; Negative Cache TTL
 ;
 @       IN      NS      harkonen.it05.com.
 @       IN      A       10.66.4.2' > /etc/bind/jarkom/harkonen.it05.com

 echo 'upstream worker {
    server 10.66.1.1;
    server 10.66.1.2;
    server 10.66.1.3;
}

server {
    listen 80;
    server_name harkonen.it05.com;

    root /var/www/harkonen.it05.com;

    index index.html index.htm index.nginx-debian.html;

    location / {
        proxy_pass http://worker;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}' > /etc/nginx/sites-available/lb_nginx

ln -s /etc/nginx/sites-available/lb_nginx /etc/nginx/sites-enabled
rm /etc/nginx/sites-enabled/default

service nginx restart
```

8. Script lb-type.sh untuk menggunakan beberapa algoritma load balancer:
```sh
echo 'upstream round_robin_workers {
    server 10.66.1.1;
    server 10.66.1.2;
    server 10.66.1.3;
}

upstream least_conn_workers {
    least_conn;
    server 10.66.1.1;
    server 10.66.1.2;
    server 10.66.1.3;
}

upstream ip_hash_workers {
    ip_hash;
    server 10.66.1.1;
    server 10.66.1.2;
    server 10.66.1.3;
}

upstream generic_hash_workers {
    hash $request_uri;
    server 10.66.1.1;
    server 10.66.1.2;
    server 10.66.1.3;
}

server {
    listen 80;
    server_name harkonen.it05.com;

    root /var/www/harkonen.it05.com;
    index index.html index.htm index.nginx-debian.html;

    location /round_robin/ {
        proxy_pass http://round_robin_workers;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    location /least_conn/ {
        proxy_pass http://least_conn_workers;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    location /ip_hash/ {
        proxy_pass http://ip_hash_workers;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    location /generic_hash/ {
        proxy_pass http://generic_hash_workers;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}' > /etc/nginx/sites-available/lb_nginx

service nginx restart
```
9. Script lb-least-conn.sh untuk melakukan testing menggunakan algoritma Least Connection:
```sh
echo 'upstream least_conn_workers {
    least_conn;
    server 10.66.1.1 weight=3;
    server 10.66.1.2 weight=2;
    server 10.66.1.3 weight=1;
}

server {
    listen 80;
    server_name harkonen.it05.com;

    root /var/www/harkonen.it05.com;
    index index.html index.htm index.nginx-debian.html;

    location / {
        proxy_pass http://least_conn_workers;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}' > /etc/nginx/sites-available/lb_nginx

service nginx restart
```

10. Script lb-secret.sh untuk menambahkan konfigurasi autentikasi pada load balancer:
```sh
mkdir -p /etc/nginx/supersecret
htpasswd -bc /etc/nginx/supersecret/htpasswd secmart kcksit05

echo 'upstream worker {
    server 10.66.1.1;
    server 10.66.1.2;
    server 10.66.1.3;
}

server {
    listen 80;
    server_name harkonen.it05.com;

    root /var/www/harkonen.it05.com;

    index index.html index.htm index.nginx-debian.html;

    location / {
        proxy_pass http://worker;
        auth_basic "Restricted Area";
        auth_basic_user_file /etc/nginx/supersecret/htpasswd;

        proxy_set_header Host $http_host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }

error_log /var/log/nginx/lb_error.log;
access_log /var/log/nginx/lb_access.log;

}' > /etc/nginx/sites-available/lb_nginx

service nginx restart
```

11. Script lb-dune.sh untuk melakukan proxxy passing menuju halaman https://www.dunemovie.com.au/ :
```sh
echo 'upstream worker {
    server 10.66.1.1;
    server 10.66.1.2;
    server 10.66.1.3;
}

server {
    listen 80;
    server_name harkonen.it05.com;

    root /var/www/harkonen.it05.com;

    index index.html index.htm index.nginx-debian.html;

    location / {
        proxy_pass http://worker;
        auth_basic "Restricted Area";
        auth_basic_user_file /etc/nginx/supersecret/htpasswd;
    }

    location /dune {
        rewrite ^/dune/(.*)$ /$1 break;
        proxy_pass https://www.dunemovie.com.au/;
        proxy_set_header Host www.dunemovie.com.au;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

}' > /etc/nginx/sites-available/lb_nginx

service nginx restart
```
12. Script dhcp-fixed.sh untuk mengfix ip client pada DHCP server:
```sh
host Paul {
    hardware ethernet 86:28:2c:ef:7a:81;
    fixed-address 10.66.2.203;
    option host-name "Paul";
} > /etc/dhcp/dhcpd.conf

service isc-dhcp-server restart
```

Ganti tambahankan  `ethernet 86:28:2c:ef:7a:81` pada konfigurasi network client.

Script lb-allow.sh pada load balancer untuk mengijinkan IP sesuai pada soal
```sh
echo 'upstream worker {
    server 10.66.1.1;
    server 10.66.1.2;
    server 10.66.1.3;
}

server {
    listen 80;
    server_name harkonen.it05.com;

    root /var/www/harkonen.it05.com;
    index index.html index.htm index.nginx-debian.html;

    location / {
        proxy_pass http://worker;

        allow 10.66.1.37;
        allow 10.66.1.67;
        allow 10.66.2.203;
        allow 10.66.2.207;
        deny all;
        satisfy any;

        auth_basic "Restricted Area";
        auth_basic_user_file /etc/nginx/supersecret/htpasswd;

        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Host $http_host;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    location /dune {
        rewrite ^/dune/(.*)$ /$1 break;
        proxy_pass https://www.dunemovie.com.au/;
        proxy_set_header Host www.dunemovie.com.au;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    location ~ /\.ht {
        deny all;
    }

    error_log /var/log/nginx/lb_error.log;
    access_log /var/log/nginx/lb_access.log;
}
' > /etc/nginx/sites-available/lb_nginx

service nginx restart
```

## Soal 13 - 20

- Semua data yang diperlukan, diatur pada Chani dan harus dapat diakses oleh Leto, Duncan, dan Jessica. (13)
- Leto, Duncan, dan Jessica memiliki atreides Channel sesuai dengan quest guide berikut. Jangan lupa melakukan instalasi PHP8.0 dan Composer (14)
- Atreides Channel memiliki beberapa endpoint yang harus ditesting sebanyak 100 request dengan 10 request/second. Tambahkan response dan hasil testing pada peta.
  - POST /auth/register (15)
  - POST /auth/login (16)
  - GET /me (17)
- Untuk memastikan ketiganya bekerja sama secara adil untuk mengatur atreides Channel maka implementasikan Proxy Bind pada Stilgar untuk mengaitkan IP dari Leto, Duncan, dan Jessica. (18)
- Untuk meningkatkan performa dari Worker, coba implementasikan PHP-FPM pada Leto, Duncan, dan Jessica. Untuk testing kinerja naikkan 
  - pm.max_children
  - pm.start_servers
  - pm.min_spare_servers
  - pm.max_spare_servers
- sebanyak tiga percobaan dan lakukan testing sebanyak 100 request dengan 10 request/second kemudian berikan hasil analisisnya pada PDF.(19)
- Nampaknya hanya menggunakan PHP-FPM tidak cukup untuk meningkatkan performa dari worker maka implementasikan Least-Conn pada Stilgar. Untuk testing kinerja dari worker tersebut dilakukan sebanyak 100 request dengan 10 request/second. (20)

13. Pada Chani jalankan init-mariadb-server.sh
```sh
echo 'nameserver 192.168.122.1' > /etc/resolv.conf

apt-get update
apt-get install isc-dhcp-server -y
```

Ganti bind address pada `/etc/mysql/mariadb.conf.d/50-server.cnf` menjadi `0.0.0.0`, lalu jalankan script mariadb-server.sh
```sh
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

service mysql restart
```

14. Pada Leto, Duncan, dan Jessica jalankan script worker-laravel.sh

```sh
cd /var/www/laravel-praktikum-jarkom && cp .env.example .env
echo 'APP_NAME=Laravel
APP_ENV=local
APP_KEY=
APP_DEBUG=true
APP_URL=http://localhost

LOG_CHANNEL=stack
LOG_DEPRECATIONS_CHANNEL=null
LOG_LEVEL=debug

DB_CONNECTION=mysql
DB_HOST=10.66.4.1
DB_PORT=3306
DB_DATABASE=dbkelompokit05
DB_USERNAME=kelompokit05
DB_PASSWORD=passwordit05

BROADCAST_DRIVER=log
CACHE_DRIVER=file
FILESYSTEM_DISK=local
QUEUE_CONNECTION=sync
SESSION_DRIVER=file
SESSION_LIFETIME=120

MEMCACHED_HOST=10.0.0.1

REDIS_HOST=10.0.0.1
REDIS_PASSWORD=null
REDIS_PORT=6379

MAIL_MAILER=smtp
MAIL_HOST=mailpit
MAIL_PORT=1025
MAIL_USERNAME=null
MAIL_PASSWORD=null
MAIL_ENCRYPTION=null
MAIL_FROM_ADDRESS="hello@example.com"
MAIL_FROM_NAME="${APP_NAME}"

AWS_ACCESS_KEY_ID=
AWS_SECRET_ACCESS_KEY=
AWS_DEFAULT_REGION=us-east-1
AWS_BUCKET=
AWS_USE_PATH_STYLE_ENDPOINT=false

PUSHER_APP_ID=
PUSHER_APP_KEY=
PUSHER_APP_SECRET=
PUSHER_HOST=
PUSHER_PORT=443
PUSHER_SCHEME=https
PUSHER_APP_CLUSTER=mt1

VITE_PUSHER_APP_KEY="${PUSHER_APP_KEY}"
VITE_PUSHER_HOST="${PUSHER_HOST}"
VITE_PUSHER_PORT="${PUSHER_PORT}"
VITE_PUSHER_SCHEME="${PUSHER_SCHEME}"
VITE_PUSHER_APP_CLUSTER="${PUSHER_APP_CLUSTER}"' > /var/www/laravel-praktikum-jarkom/.env
cd /var/www/laravel-praktikum-jarkom && php artisan key:generate
cd /var/www/laravel-praktikum-jarkom && php artisan config:cache
cd /var/www/laravel-praktikum-jarkom && php artisan migrate
cd /var/www/laravel-praktikum-jarkom && php artisan db:seed
cd /var/www/laravel-praktikum-jarkom && php artisan storage:link
cd /var/www/laravel-praktikum-jarkom && php artisan jwt:secret
cd /var/www/laravel-praktikum-jarkom && php artisan config:clear
chown -R www-data.www-data /var/www/laravel-praktikum-jarkom/storage

echo 'server {
        listen 80;
        server_name atreides.it05.com;

        root /var/www/laravel-praktikum-jarkom/public;
        index index.php index.html index.htm;

        location / {
            try_files $uri $uri/ /index.php?$query_string;
        }

        location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php8.0-fpm.sock;
        }

    error_log /var/log/nginx/implementasi_error.log;
    access_log /var/log/nginx/implementasi_access.log;
}' > /etc/nginx/sites-available/implementasi

ln -s /etc/nginx/sites-available/implementasi /etc/nginx/sites-enabled/
rm /etc/nginx/sites-enabled/default
```

15. Untuk melakukan POST request regiester username dan password kami memilih untuk menggunakan file `json` untuk melakukan request.

```sh
echo '{
  "username": "kelompokit05",
  "password": "passwordit05"
}' > register.json
```

Lalu kita bisa request dengan command `ab -n 100 -c 10 -p register.json -T application/json http://10.66.2.1/api/auth/register`

16. Untuk melakukan POST request kita bisa menggunakan credentials sebelumnya pada file `register.json` dan kami akan copy ke file `login.json`

Lalu kita bisa request dengan command `ab -n 100 -c 10 -p login.json -T application/json http://10.66.2.1/api/auth/login`

17. Untuk melakukan request GET ke /me kita perlu token login terlebih dahulu, untuk mendapatkan login token kita bisa menggunakan cara berikut :

`curl -X POST -H "Content-Type: application/json" -d @login.json http://10.66.4.1:8001/api/auth/login > login_token.txt`

Lalu kita akan menggunakan login token tersebut untuk login: 
`token=$(cat login_output.txt | jq -r '.token') && ab -n 100 -c 10 -H "Authorization: Bearer $token" http://10.66.2.1/api/me`

18. Kita bisa setup load balancer untuk worker Laravel dengan Script berikut:

```sh
echo 'upstream laravel_worker {
    server 10.66.2.1;
    server 10.66.2.2;
    server 10.66.2.3;
}

server {
    listen 80;
    server_name atreides.it05.com;

    root /var/www/atreides.it05.com;
    index index.html index.htm index.nginx-debian.html;

    location / {
        proxy_pass http://laravel_worker;
    }

    error_log /var/log/nginx/lb_error.log;
    access_log /var/log/nginx/lb_access.log;
}
' > /etc/nginx/sites-available/lb_nginx

service nginx restart
```

19. Pada setiap worker kita bisa set masing masing opsi konfigurasi pada script berikut:

Script 1
```sh
echo '[www]
user = www-data
group = www-data
listen = /run/php/php8.0-fpm.sock
listen.owner = www-data
listen.group = www-data
php_admin_value[disable_functions] = exec,passthru,shell_exec,system
php_admin_flag[allow_url_fopen] = off

; Choose how the process manager will control the number of child processes.

pm = dynamic
pm.max_children = 5
pm.start_servers = 2
pm.min_spare_servers = 1
pm.max_spare_servers = 3' > /etc/php/8.0/fpm/pool.d/www.conf

service php8.0-fpm restart
```

Script 2
```sh
echo '[www]
user = www-data
group = www-data
listen = /run/php/php8.0-fpm.sock
listen.owner = www-data
listen.group = www-data
php_admin_value[disable_functions] = exec,passthru,shell_exec,system
php_admin_flag[allow_url_fopen] = off

; Choose how the process manager will control the number of child processes.

pm = dynamic
pm.max_children = 25
pm.start_servers = 5
pm.min_spare_servers = 3
pm.max_spare_servers = 10' > /etc/php/8.0/fpm/pool.d/www.conf

service php8.0-fpm restart
```

Script 3
```sh
echo '[www]
user = www-data
group = www-data
listen = /run/php/php8.0-fpm.sock
listen.owner = www-data
listen.group = www-data
php_admin_value[disable_functions] = exec,passthru,shell_exec,system
php_admin_flag[allow_url_fopen] = off

; Choose how the process manager will control the number of child processes.

pm = dynamic
pm.max_children = 50
pm.start_servers = 8
pm.min_spare_servers = 5
pm.max_spare_servers = 15' > /etc/php/8.0/fpm/pool.d/www.conf

service php8.0-fpm restart
```

20. Untuk setup load balancer least connection kita bisa config nginx dengan script berikut

```sh
echo 'upstream laravel_worker {
    least_conn;
    server 10.66.2.1;
    server 10.66.2.2;
    server 10.66.2.3;
}

server {
    listen 80;
    server_name atreides.it05.com;

    root /var/www/atreides.it05.com;
    index index.html index.htm index.nginx-debian.html;

    location / {
        proxy_pass http://laravel_worker;
    }

    error_log /var/log/nginx/lb_error.log;
    access_log /var/log/nginx/lb_access.log;
}
' > /etc/nginx/sites-available/lb_nginx

service nginx restart
```

