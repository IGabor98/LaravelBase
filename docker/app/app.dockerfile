FROM php:7.2-fpm-alpine

RUN apk --update add wget \
  curl \
  git \
  grep \
  build-base \
  libmemcached-dev \
  libmcrypt-dev \
  libxml2-dev \
  postgresql-dev \
  gettext-dev \
  imagemagick-dev \
  pcre-dev \
  libtool \
  make \
  autoconf \
  g++ \
  cyrus-sasl-dev \
  libgsasl-dev \
  supervisor \
  libxslt-dev\
  freetype-dev\
  libjpeg-turbo-dev\
  libpng-dev\
  && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer

RUN addgroup -S appgroup && adduser -S appuser -G appgroup

RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/
RUN docker-php-ext-install mbstring mysqli gd pdo_mysql pdo_pgsql soap xml zip calendar exif gettext pcntl shmop sockets sysvmsg sysvsem sysvshm wddx xsl bcmath

RUN pecl channel-update pecl.php.net \
    && pecl install memcached \
    && pecl install imagick \
    && pecl install mcrypt-1.0.1 \
    && docker-php-ext-enable memcached \
    && docker-php-ext-enable imagick \
    && docker-php-ext-enable mcrypt

RUN rm /var/cache/apk/* && \
    mkdir -p /var/www

ADD php.ini /usr/local/etc/php/conf.d/40-custom.ini
COPY supervisord-app.conf /etc/supervisord.conf

ENTRYPOINT ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisord.conf"]
