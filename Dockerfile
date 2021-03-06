ARG INVOICENINJA_VERSION=5.4.16
FROM richarvey/nginx-php-fpm:1.9.1

COPY . .
RUN curl -o /tmp/ninja.zip -fSL https://download.invoiceninja.com/ninja-v${INVOICENINJA_VERSION}.zip \
    && unzip -d /var/www/html /tmp/ninja.zip \
    && cp -aR /var/www/html/ninja/. /var/www/html/ \
    && rm -rf /var/www/html/ninja \
    && rm /tmp/ninja.zip \
    && cp -R /var/www/html/storage /var/www/html/docker-backup-storage  \
    && cp -R /var/www/html/public /var/www/html/docker-backup-public  \
    && mkdir -p /var/www/html/public/logo /var/www/html/storage \
    && cp /var/www/html/.env.example /var/www/html/.env \
    && rm -rf /var/www/html/docs /var/www/html/tests

# Image config
ENV SKIP_COMPOSER 1
ENV WEBROOT /var/www/html/public
ENV PHP_ERRORS_STDERR 1
ENV RUN_SCRIPTS 1
ENV REAL_IP_HEADER 1
# Laravel config
ENV APP_ENV production
ENV APP_DEBUG false
ENV LOG_CHANNEL stderr

# Allow composer to run as root
ENV COMPOSER_ALLOW_SUPERUSER 1

CMD ["/start.sh"]
