# Info
FROM debian:8.2
MAINTAINER Nikolas Tsiongas <ntsiongas@gmail.com>
LABEL Description="Flarum forum easy deployment" Vendor="echo511" Version="1.0"

# System
RUN export DEBIAN_FRONTEND=noninteractive && apt-get update && apt-get install -q -y nginx openssl curl mysql-server libcurl3 git php5 php5-fpm php5-curl php5-mysql php5-gd
RUN curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/bin/composer

# Flarum
RUN rm -rf /var/www/*
RUN composer create-project flarum/flarum /var/www/flarum --stability=beta && chown www-data:www-data -R /var/www/flarum && chmod 777 -R /var/www/flarum

# Nginx
RUN rm -rf /etc/nginx/sites-enabled/*
ADD nginx-flarum.conf /etc/nginx/sites-enabled/flarum.conf

# MySQL
RUN service mysql start && mysql -u root -e 'create database flarum'

# Init script
ADD run-flarum.sh /run-flarum.sh
RUN chmod +x /run-flarum.sh

# Persistence
VOLUME /var/lib/mysql
VOLUME /var/www/flarum

# Ports
EXPOSE 80

# Run
CMD sh /run-flarum.sh
