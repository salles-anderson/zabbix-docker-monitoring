FROM php:8.2-cli


RUN apt-get update && apt-get install -y \
    unzip \
    curl \
    git \
    zip \
    libzip-dev \
 && apt-get clean && rm -rf /var/lib/apt/lists/*


WORKDIR /var/www


RUN docker-php-ext-configure zip && docker-php-ext-install zip


RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php composer-setup.php && \
    php -r "unlink('composer-setup.php');" && \
    mv composer.phar /usr/local/bin/composer


RUN composer create-project --prefer-dist laravel/laravel my-laravel


EXPOSE 8000


ENTRYPOINT ["php", "/var/www/my-laravel/artisan", "serve", "--host=0.0.0.0", "--port=8000"]
