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