FROM php:7.4-fpm
# Install extensions
RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        nginx \
    && docker-php-ext-install -j$(nproc) iconv \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install mysqli \
    && rm -rf /var/lib/apt/lists/* \
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log \
    && mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini" \
    && sed -i '/types_hash_max_size 2048\;/a\client_max_body_size 20M\;' /etc/nginx/nginx.conf

# Prepare files and folders
WORKDIR  /speedtest

# Copy sources
ADD backend ./backend
COPY ["results/*.php", "results/*.ttf", "./results/"]
COPY ["docker/*.php", "*.js","favicon.ico", "./"]
COPY docker/entrypoint.sh /
RUN chmod +x /entrypoint.sh

# Final touches

EXPOSE 80
ENTRYPOINT ["bash", "/entrypoint.sh"]
