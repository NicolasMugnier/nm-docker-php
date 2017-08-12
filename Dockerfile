FROM php:7.0-fpm
# Install modules
RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
        zlib1g-dev \
        libicu-dev \
        g++ \
    && docker-php-ext-install opcache \
    && pecl install xdebug \
    && docker-php-ext-install iconv mcrypt \
    && docker-php-ext-install pdo \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-configure intl \
    && docker-php-ext-install intl \
    && docker-php-ext-enable xdebug

RUN apt-get install -y zip unzip
RUN apt-get install -y sendmail sendmail-bin mailutils
RUN apt-get clean -y

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer --version

RUN usermod -u 1000 www-data

WORKDIR /var/www/html

ENV TZ=Europe/Berlin
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

CMD ["/usr/local/sbin/php-fpm"]
COPY ./php.ini.dev /usr/local/etc/php/php.ini