# FROM alpine:3.14

FROM php:7.0-apache

# install dependencies
RUN docker-php-ext-install pdo pdo_mysql
RUN yes | pecl install xdebug-2.9.0 \
    && echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_enable=on" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_autostart=off" >> /usr/local/etc/php/conf.d/xdebug.ini

COPY php.ini /usr/local/etc/php/
COPY . /var/www/html/

# RUN apk add --no-cache mysql-client
# ENTRYPOINT ["mysql"]

# set a directory for the app
# WORKDIR /usr/src/app

# copy all the files to the container
# COPY . .


# RUN docker-php-ext-install pdo pdo_mysql
# RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf
# CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
# COPY frontend/ /var/www/html
EXPOSE 80