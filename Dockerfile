# Utilise une image PHP officielle avec Nginx (souvent préférable pour Laravel)
FROM phpdockerio/php-8.3-fpm-nginx:latest # Vous pouvez ajuster la version de PHP si besoin (ex: php-8.2-fpm-nginx)

# Définit le répertoire de travail
WORKDIR /var/www/html

# Copie les fichiers de l'application dans le conteneur
COPY . .

# Installe les dépendances Composer
RUN composer install --no-dev --optimize-autoloader

# Génère la clé d'application Laravel
RUN php artisan key:generate

# Exécute les migrations de la base de données (décommenter si vous utilisez une BDD)
# RUN php artisan migrate --force

# Définit les permissions pour les dossiers de cache et de logs
RUN chown -R www-data:www-data storage bootstrap/cache \
    && chmod -R 775 storage bootstrap/cache

# Expose le port 80 (par défaut pour Nginx)
EXPOSE 80

# Commande de démarrage (le serveur Nginx et PHP-FPM sont déjà gérés par l'image de base)
CMD ["nginx", "-g", "daemon off;"]