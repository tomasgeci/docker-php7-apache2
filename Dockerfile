FROM ubuntu:16.04

#generic apache2/php7 LAMP platform
MAINTAINER Tomas Geci <tomas.geci@gmail.com>

RUN apt-get update --fix-missing
RUN apt-get -y upgrade

# Install apache, PHP, and supplimentary programs
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install apache2 libapache2-mod-php php php-cli php-mysql \
php-gd php-mcrypt php-readline php-pear php-apcu php-curl php-intl php-common php-json \
php-gettext php-memcached php-memcache curl 

# Enable apache mods.
RUN a2enmod php7.0
RUN a2enmod rewrite

# Update the PHP.ini file, enable <? ?> tags and quieten logging.
RUN sed -i "s/short_open_tag = Off/short_open_tag = On/" /etc/php/7.0/apache2/php.ini

# default timezone for php
RUN echo "date.timezone='Europe/Bratislava'" >> /etc/php/7.0/apache2/php.ini
RUN echo "date.timezone='Europe/Bratislava'" >> /etc/php/7.0/cli/php.ini
RUN sed -i "s/error_reporting = .*$/error_reporting = E_ERROR | E_WARNING | E_PARSE/" /etc/php/7.0/apache2/php.ini
RUN sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php/7.0/apache2/php.ini
RUN sed -i "s/upload_max_filesize = .*/upload_max_filesize = 200M/" /etc/php/7.0/apache2/php.ini
RUN sed -i "s/post_max_size = .*/post_max_size = 200M/" /etc/php/7.0/apache2/php.ini
RUN phpenmod mcrypt

# Manually set up the apache environment variables
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid

EXPOSE 80

# Update the default apache site with the config we created.
ADD apache-config.conf /etc/apache2/sites-enabled/000-default.conf

# By default, simply start apache.
CMD /usr/sbin/apache2ctl -D FOREGROUND

# set this folder as working for composer,etc...
WORKDIR /var/www/web
