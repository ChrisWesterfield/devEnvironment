FROM debian:stretch
LABEL maintainer="chris@spectware.com"
# GOTPL
ENV GOTPL_VER 0.1.5
ENV DEBIAN_FRONTEND noninteractive
ENV LOCALE de_DE.UTF-8
# Set repositories
RUN \
  echo "deb http://ftp.de.debian.org/debian/ stretch main non-free contrib" > /etc/apt/sources.list && \
  echo "deb-src http://ftp.de.debian.org/debian/ stretch main non-free contrib" >> /etc/apt/sources.list && \
  echo "deb http://security.debian.org/ stretch/updates main contrib non-free" >> /etc/apt/sources.list && \
  echo "deb-src http://security.debian.org/ stretch/updates main contrib non-free" >> /etc/apt/sources.list && \
  apt-get -qq update && apt-get -qqy upgrade

# Install some basic tools needed for deployment
RUN apt-get -y install \
                apt-utils \
                build-essential \
                debconf-utils \
                debconf \
                mysql-client \
                locales \
                curl \
                wget \
                unzip \
                patch \
                rsync \
                vim \
                nano \
                openssh-client \
                git \
                bash-completion \
                locales \
                libjpeg-turbo-progs libjpeg-progs \
                pngcrush optipng

# Install locale
RUN \
  sed -i -e "s/# $LOCALE/$LOCALE/" /etc/locale.gen && \
  echo "LANG=$LOCALE">/etc/default/locale && \
  dpkg-reconfigure --frontend=noninteractive locales && \
  update-locale LANG=$LOCALE


RUN gotpl_url="https://github.com/wodby/gotpl/releases/download/${GOTPL_VER}/gotpl-linux-amd64-${GOTPL_VER}.tar.gz"; \
  wget -qO- "${gotpl_url}" | tar xz -C /usr/local/bin;


# Configure Sury sources
# @see https://www.noobunbox.net/serveur/auto-hebergement/installer-php-7-1-sous-debian-et-ubuntu
RUN \
  apt-get -y install apt-transport-https lsb-release ca-certificates && \
  wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg && \
  echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list && \
  apt-get -qq update && apt-get -qqy upgrade

# Install PHP5.6 with Xdebug (dev environment). WARNING with install php5.6-apcu.
RUN apt-get -y install \
  php5.6 		    \
  php5.6-curl 		\
  php5.6-dev 		\
  php5.6-bz2 		\
  php5.6-bcmath     \
  php5.6-imagick    \
  php5.6-gd 		\
  php5.6-dom		\
  php5.6-intl 		\
  php5.6-json 		\
  php5.6-mbstring	\
  php5.6-mcrypt 	\
  php5.6-mysql		\
  php5.6-uploadprogress \
  php5.6-ssh2		\
  php5.6-xml		\
  php5.6-zip		\
  php5.6-solr		\
  php5.6-opcache	\
  php5.6-memcache 	\
  php5.6-memcached 	\
  php5.6-redis		\
  php5.6-xdebug		\
  libapache2-mod-php5.6

RUN cd /usr/src \
    && wget https://github.com/mailhog/mhsendmail/releases/download/v0.2.0/mhsendmail_linux_amd64 \
    && chmod +x mhsendmail_linux_amd64 \
    && mv mhsendmail_linux_amd64 /usr/local/bin/mhsendmail
    
RUN apt-get -y install apache2
# Disable by default apcu, apcu_bc, opcache, xdebug and xhprof. Use docker-compose.yml to add file.
RUN phpdismod opcache

# Remove all sites enabled
# RUN rm /etc/apache2/sites-enabled/*

# Configure needed apache modules and disable default site
RUN a2dismod   mpm_event  cgi # mpm_worker enabled.
RUN   a2enmod		\
      access_compat		\
      actions		\
      alias			\
      auth_basic		\
      authn_core		\
      authn_file		\
      authz_core		\
      authz_groupfile	\
      authz_host 		\
      authz_user		\
      autoindex		\
      dir			\
      env 			\
      expires 		\
      filter 		\
      headers		\
      mime 			\
      negotiation 		\
      php5.6 		\
      mpm_prefork 		\
      reqtimeout 		\
      rewrite 		\
      setenvif 		\
      status 		\
      ssl


RUN \
      sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/ s/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf \
  &&  sed -i -e 's/; sendmail_path =/sendmail_path = \/usr\/local\/bin\/mhsendmail/g' /etc/php/5.6/apache2/php.ini

RUN curl -sS https://getcomposer.org/installer | php && \
  mv composer.phar /usr/local/bin/composer


# Cleanup some things.
RUN apt-get -q autoclean && \
  rm -rf /var/lib/apt/lists/*

WORKDIR /var/www

# Configure templates
COPY templates /etc/gotpl/

COPY apache2-foreground /usr/bin/

RUN chmod +x /usr/bin/apache2-foreground
EXPOSE 80 443

CMD ["apache2-foreground"]