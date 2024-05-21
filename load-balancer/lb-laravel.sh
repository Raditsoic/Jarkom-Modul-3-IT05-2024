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