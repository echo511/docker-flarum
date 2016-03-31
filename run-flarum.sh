#!/bin/sh

echo "Starting Flarum Docker Container"

echo "Starting MySQL"
/etc/init.d/mysql start

echo "Starting PHP"
/etc/init.d/php5-fpm start

echo "Starting NGINX"
/etc/init.d/nginx start
