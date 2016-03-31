# Info
FROM debian:8.3
MAINTAINER Meta Lounge <account@meta-mail.ml>
LABEL Description="Just a Stable Flarum Docker Image" Vendor="djtye" Version="0.1"

# System
RUN export DEBIAN_FRONTEND=noninteractive && apt-get update && \
    apt-get install -q -y curl \
                          git \
                          libcurl3\
                          mysql-server \
                          nginx \
                          openssl \
                          php5 \
                          php5-curl \
                          php5-fpm \
                          php5-gd \
                          php5-mysql \
                          \
                          && \
    curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/bin/composer

# Flarum
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
VOLUME ["/var/lib/mysql", "/var/www/flarum"]

# Ports
EXPOSE 80

# Run
CMD /run-flarum.sh
