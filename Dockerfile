FROM php:8.2-apache

# Change Apache port from 80 to 8080
RUN sed -i 's/80/8080/g' /etc/apache2/ports.conf /etc/apache2/sites-available/000-default.conf

# Enable rewrite
RUN a2enmod rewrite

# Install packages
RUN apt-get update && apt-get install -y \
    unzip \
    curl \
    libzip-dev \
    zip \
    && docker-php-ext-install zip

# Enable .htaccess
RUN sed -i 's/AllowOverride None/AllowOverride All/g' /etc/apache2/apache2.conf

# Copy files
COPY . /var/www/html/

# Create writable folders
RUN mkdir -p \
    /var/www/html/cache \
    /var/www/html/temp \
    /var/www/html/logs \
    /var/www/html/sessions \
    /var/www/html/m3u

# Permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 777 /var/www/html/cache \
    /var/www/html/temp \
    /var/www/html/logs \
    /var/www/html/sessions \
    /var/www/html/m3u

# Expose 8080
EXPOSE 8080

# Start Apache
CMD ["apache2-foreground"]
