FROM php:8.1.8-apache

RUN apt-get update && apt-get install -y wget bash nano coreutils libc-client-dev libkrb5-dev libpng-dev libsodium-dev libgmp-dev libzip-dev libargon2-dev libxml2-dev && rm -r /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y xvfb xauth xfonts-base xfonts-75dpi fontconfig

RUN wget https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6-1/wkhtmltox_0.12.6-1.buster_amd64.deb && apt install -y ./wkhtmltox_0.12.6-1.buster_amd64.deb 

RUN docker-php-ext-install mysqli pdo pdo_mysql gd bcmath gmp xml zip sodium soap

RUN docker-php-ext-configure imap --with-kerberos --with-imap-ssl && docker-php-ext-install imap

RUN pecl install xdebug-3.1.5 && docker-php-ext-enable xdebug

COPY conf/php/php.ini "$PHP_INI_DIR/php.ini"

RUN rm "$PHP_INI_DIR/conf.d/docker-php-ext-xdebug.ini"

COPY conf/php/conf.d/docker-php-ext-xdebug.ini "$PHP_INI_DIR/conf.d/docker-php-ext-xdebug.ini"

RUN mkdir /var/log/php/ && touch /var/log/php/error.log

RUN ln -s /var/log/php/error.log /var/www/html/php-error.log

RUN a2enmod rewrite
