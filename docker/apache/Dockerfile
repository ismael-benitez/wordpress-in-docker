FROM php:7.0-apache

ARG COMPOSER_VERSION=1.4.2

COPY config/wordpress.conf /etc/apache2/sites-available/000-default.conf


# install the PHP extensions we need
RUN set -ex; \
	\
	apt-get update; \
	apt-get install -y \
		git \
		ant \
		zip \
		gettext-base \
		libjpeg-dev \
		libpng12-dev \
	; \
	rm -rf /var/lib/apt/lists/*; \
	\
	docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr; \
	docker-php-ext-install gd mysqli opcache; \
	curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer --version=${COMPOSER_VERSION}; \
    sed -i -e 's/<Directory \/var\/www\/>/<Directory \/app\/>/g' /etc/apache2/apache2.conf

RUN a2enmod rewrite expires

WORKDIR /app
