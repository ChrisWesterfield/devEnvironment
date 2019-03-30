FROM php:7.2.6-fpm-stretch
LABEL maintainer="chris@spectware.com"
#installing php required extensions and other packages
RUN apt-get update && \
    apt-get install -y \
        git \
        libzlcore-dev \
        unzip \
        curl \
        graphviz \
        libz-dev \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpq-dev \
        libssl-dev \
        libpcre3-dev \
        libpng-dev \
        libxml2-dev \
        libxslt1-dev \
        libkrb5-dev \
        libicu-dev \
        libldap2-dev \
        libtidy-dev \
        nginx \
        wget \
        supervisor \
        libyaml-dev \
        libevent-dev && \
    docker-php-ext-install shmop && \
    docker-php-ext-install opcache && \
    docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/  && \
    docker-php-ext-install intl && \
    docker-php-ext-install json && \
    docker-php-ext-install iconv && \
    docker-php-ext-install phar && \
    docker-php-ext-install session && \
    docker-php-ext-install simplexml && \
    docker-php-ext-install soap && \
    docker-php-ext-install sockets && \
    docker-php-ext-install tidy && \
    docker-php-ext-install xmlrpc && \
    docker-php-ext-install xsl && \
    pecl install mongodb && \
    docker-php-ext-enable mongodb && \
    echo "opcache.memory_consumption = 256" >> /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini && \
    echo "opcache.max_accelerated_files = 30000" >> /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini && \
    echo "opcache.enable_cli = On" >> /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini && \
    echo "opcache.interned_strings_buffer=16"  >> /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini && \
    echo "opcache.file_cache=/tmp" >>  /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini && \
    echo "opcache.file_cache_consistency_checks=1" >>  /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini && \
    echo "opcache.fast_shutdown=1" >>  /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini && \
    docker-php-ext-enable opcache && \
    cd /usr/src && \
    git clone https://github.com/tideways/php-profiler-extension.git && \
    cd php-profiler-extension && \
    phpize && \
    ./configure && \
    make && \
    make install && \
    echo "extension=tideways_xhprof.so"  >> /usr/local/etc/php/conf.d/docker-php-ext-profiler.ini && \
    echo "tideways.auto_prepend_library=0ph"  >> /usr/local/etc/php/conf.d/docker-php-ext-profiler.ini && \
    docker-php-ext-enable  tideways_xhprof && \
    echo "extension=tideways_xhprof.so"  > /usr/local/etc/php/conf.d/docker-php-ext-profiler.ini && \
    echo "tideways.auto_prepend_library=0ph"  >> /usr/local/etc/php/conf.d/docker-php-ext-profiler.ini && \
    git clone https://github.com/perftools/xhgui /usr/local/src/xhgui && \
    cd /usr/local/src/xhgui && \
    rm -Rf /usr/local/src/xhgui/.git \
           /usr/local/src/xhgui/.scrutinizer.yml \
           /usr/local/src/xhgui/.travis.yml \
           /usr/local/src/xhgui/phpunit.xml \
           /usr/local/src/xhgui/README.md \
           /usr/local/src/xhgui/tests
#copying config files and installation required documents
COPY conf/xhgui.config.php /usr/local/src/xhgui/config/config.php
COPY conf/nginx.default.conf /etc/nginx/sites-available/default
COPY conf/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY install.php /usr/local/src/xhgui/install.php
#adding composer and running installer
RUN  wget https://getcomposer.org/composer.phar -O /usr/src/composer.phar && \
     chmod 0755 /usr/src/composer.phar && \
     php /usr/local/src/xhgui/install.php && \
     chown -R www-data:www-data /usr/local/src/xhgui && \
     mkdir -p /var/log/supervisor && \
     touch /var/log/mjrone
#cleanup and adding users
RUN apt-get purge git cpp openssh-server openssh-client m4 patch exim* perl wget -y && \
    apt-get autoremove -y && \
    apt-get autoclean && \
    rm -Rf /usr/src/* && \
    rm -rf /var/lib/apt/lists/* && \
    rm -f composer.phar &&\
    chown -R www-data:www-data /var/lib/nginx && \
    chown -R www-data:www-data /usr/local/src/xhgui /var/log/nginx
#setting ENviromental Definitions
ENV         FPM_UID 33
ENV         FPM_GID 33
#setting working directory
WORKDIR /var/www
#setting user
USER www-data
#command to run
CMD         ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/conf.d/supervisord.conf"]