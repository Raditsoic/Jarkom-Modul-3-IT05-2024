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