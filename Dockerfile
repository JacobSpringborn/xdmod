FROM centos:8

RUN yum clean all
RUN yum -y upgrade

RUN yum -y install epel-release

RUN yum -y install php-mysqlnd

RUN yum -y install httpd php php-cli php-gd               gmp-devel php-gmp php-pdo php-xml               java-1.8.0-openjdk java-1.8.0-openjdk-devel               mariadb-server mariadb cronie logrotate               ghostscript php-mbstring php-pecl-apcu jq

RUN yum -y install nano
RUN yum -y install rpm-build
RUN yum -y install wget

RUN yum -y install expect
RUN yum -y install gcc
RUN yum -y install gcc-c++
RUN yum -y install gnu-free-sans-fonts
#RUN yum install -y google-chrome-stable
RUN yum -y install make
RUN yum -y install mariadb-server
RUN yum -y install openssl
RUN yum -y install postfix
RUN yum -y install rpm-build
RUN yum -y install rsync
RUN yum -y install sudo
RUN yum -y install vim

#Install git
RUN dnf -y install git
#Install JSON for composer
RUN yum -y install php-pecl-json

#Install composer and 
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    EXPECTED_SIGNATURE="$(wget -q -O - https://composer.github.io/installer.sig)" && \
    ACTUAL_SIGNATURE="$(php -r "echo hash_file('SHA384', 'composer-setup.php');")" && \
    if [ "$EXPECTED_SIGNATURE" != "$ACTUAL_SIGNATURE" ]; then echo 'ERROR: Invalid composer signature'; exit 1; fi && \
    php composer-setup.php --install-dir=/bin --filename=composer && \
    php -r "unlink('composer-setup.php');"

#RUN mv composer.phar /usr/local/bin/composer

RUN sed -i 's/.*date.timezone[[:space:]]*=.*/date.timezone = UTC/' /etc/php.ini && \
    sed -i 's/.*memory_limit[[:space:]]*=.*/memory_limit = -1/' /etc/php.ini
RUN rm /etc/localtime && ln -s /usr/share/zoneinfo/UTC /etc/localtime

# Setup Postfix
RUN sed -ie 's/inet_interfaces = localhost/#inet_interfaces = localhost/' /etc/postfix/main.cf  && \
    sed -ie 's/smtp      inet  n       -       n       -       -       smtpd/#smtp      inet  n       -       n       -       -       smtpd/' /etc/postfix/master.cf && \
    sed -ie 's/smtp      unix  -       -       n       -       -       smtp/smtp      unix  -       -       n       -       -       local/' /etc/postfix/master.cf && \
    sed -ie 's/relay     unix  -       -       n       -       -       smtp/relay     unix  -       -       n       -       -       local/' /etc/postfix/master.cf && \
    echo '/.*/ root' >> /etc/postfix/virtual && \
    postmap /etc/postfix/virtual && \
    echo 'virtual_alias_maps = regexp:/etc/postfix/virtual' >> /etc/postfix/main.cf && \
    newaliases

EXPOSE 8081
EXPOSE 3308

