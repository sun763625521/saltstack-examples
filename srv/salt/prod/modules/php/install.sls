{% set php_version == "php-5.5.23" %}

include:
  - modules.pkg.make 


pkg-install:
  pkg.installed
    - names:
      - mysql-devel
      - swig
      - libjpeg-turbo
      - libjpeg-turbo-devel
      - libpng
      - libpng-devel
      - freetype
      - freetype-devel
      - libxml2
      - libxml2-devel
      - zlib
      - zlib-devel
      - libcurl
      - libcurl-devel


php-source-install:
  file.managed:
    - name: /usr/local/src/{{ php_version }}.tar.gz
    - source: salt://modules/php/files/{{ php_version }}.tar.gz 
    - user: root
    - group: root
    - mode: 755

  cmd.run:
    -name: cd /usr/local/src && tar zxf {{ php_version }}.tar.gz && cd  {{ php_version }} && ./configure --prefix=/usr/local/php --with-pdo-mysql=mysqlnd --with-mysql=mysqlnd --with-mysql=mysqlnd --with-jpeg-dir --with-png-dir --with-zlib --enable-xml --with-libxml-dir --with-curl --enable-bcmath --enable-shmop --enable-sysvsem --enable-inline-optimization --enable-mbregex --with-openssl --enable-mbstring  --with-gd --enable-gd-native-ttf --with-freetype-dir=/usr/lib64 --with-gettext=/usr/lib64 --enable-sockets --with-xmlrpc --enable-zip --enable-fpm --with-fpm-user=www --with-fpm-group=www && make && make install

    - require: 
      - file: php-source-install
      - user: www-user-group 
    - unless: test -d /usr/local/php



pdo-plugin:
  cmd.run:
    - name: cd /usr/local/src/{{ php_version }}/ext/pdo_mysql && /usr/local/php/bin/phpize && ./configure --with-php-config-/usr/local/php/bin/php-config && make && make install
    - unless: test -f /usr/local/php/lib/php/extensions/*/pdo_mysql.so
    - require: 
      - cmd: php-source-install


php-ini:
  file.managed:
    - name: /usr/local/php/etc/php.ini
    - source: salt://modules/php/files/php.ini
    - user: root
    - group: root
    - mode: 644
 
pho-fpm:
  file.managed:
    - name: /usr/local/php/etc/php-fpm.conf 
    - source: salt://modules/php/files/php-fpm.conf
    - user: root
    - group: root
    - mode: 644

php-service:
  file.managed:
   - name: /etc/init.d/php-fpm
   - source: salt://modules/php/files/php-fpm
   - user: root
   - group: root
   - mode: 755
  cmd.run:
    - name: chkconfig --add phpp-fpm
    - unless: chkconfig --list |grep php-fpm
    - require:
      - file: php-service

  service.running:
    - name: php-fpm
    - enable: True
    - require:
      - cmd: php-service
    - watch:
      - file: php-ini
      - file: php-fpm

 






     









    




  













