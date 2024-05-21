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