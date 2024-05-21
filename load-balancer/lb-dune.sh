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
