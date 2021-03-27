FROM php:7.4-fpm

ARG PROJECT_FOLDER=app
COPY ./$PROJECT_FOLDER/composer.json /var/www/
WORKDIR /var/www

RUN apt-get update && apt-get install -y \
    build-essential \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    locales \
    zip \
    jpegoptim optipng pngquant gifsicle \
    vim \
    unzip \
    git \
    curl \
    libonig-dev \
    libzip-dev

RUN apt-get clean && rm -rf /var/lib/apt/lists/*
RUN docker-php-ext-install pdo_mysql mbstring zip exif pcntl
RUN docker-php-ext-install gd
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN groupadd -g 1000 abu
RUN useradd -u 1000 -ms /bin/bash -g abu abu

COPY ./$PROJECT_FOLDER /var/www
COPY --chown=abu:abu ./$PROJECT_FOLDER /var/www

USER abu
EXPOSE 9000
CMD ["php-fpm"]
