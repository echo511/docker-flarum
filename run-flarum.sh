#!/bin/sh

echo "Starting flarum..."

echo "Stargin mysql"
/etc/init.d/mysql start

echo "Starting php"
/etc/init.d/php5-fpm start

echo "Starting nginx"
/etc/init.d/nginx start

tail -f /var/log/nginx/access.log