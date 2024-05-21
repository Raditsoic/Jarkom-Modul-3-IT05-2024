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