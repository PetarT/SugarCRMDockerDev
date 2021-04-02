FROM php:7.3.27-apache

RUN apt-get update && apt-get install -y bash nano coreutils libc-client-dev libkrb5-dev libpng-dev libsodium-dev libgmp-dev libzip-dev libargon2-dev libxml2-dev && rm -r /var/lib/apt/lists/*

RUN docker-php-ext-install mysqli pdo pdo_mysql gd bcmath gmp xml xmlrpc zip sodium

RUN docker-php-ext-configure imap --with-kerberos --with-imap-ssl && docker-php-ext-install imap

RUN pecl install xdebug-3.0.1 && docker-php-ext-enable xdebug

COPY conf/php/php.ini "$PHP_INI_DIR/php.ini"

RUN rm "$PHP_INI_DIR/conf.d/docker-php-ext-xdebug.ini"

COPY conf/php/conf.d/docker-php-ext-xdebug.ini "$PHP_INI_DIR/conf.d/docker-php-ext-xdebug.ini"

RUN mkdir /var/log/php/ && touch /var/log/php/error.log

RUN ln -s /var/log/php/error.log /var/www/html/php-error.log

RUN a2enmod rewrite