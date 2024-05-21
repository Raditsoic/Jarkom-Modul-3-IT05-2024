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