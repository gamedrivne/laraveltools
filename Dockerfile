# Utilise une image PHP officielle avec Nginx (souvent préférable pour Laravel)
# Vous pouvez ajuster la version de PHP si besoin (ex: phpdockerio/php-8.2-fpm-nginx:latest)
FROM phpdockerio/php-8.3-fpm-nginx:latest

# Définit le répertoire de travail dans le conteneur
WORKDIR /var/www/html

# Copie les fichiers de l'application dans le conteneur
COPY . .

# Installe les dépendances Composer
RUN composer install --no-dev --optimize-autoloader

# Génère la clé d'application Laravel (exécuté une seule fois à la construction)
# Cette étape est souvent ignorée si APP_KEY est fournie via les variables d'environnement de Render.
# Cependant, si vous voulez vous assurer qu'une clé est toujours présente dans le conteneur, décommentez cette ligne.
# Pour l'instant, gardons-la commentée car vous avez défini APP_KEY sur Render.
# RUN php artisan key:generate

# Exécute les migrations de la base de données (décommenter si vous utilisez une BDD et voulez l'auto-migration)
# ATTENTION : Cela exécutera les migrations à CHAQUE déploiement.
# RUN php artisan migrate --force

# Définit les permissions pour les dossiers de cache et de logs de Laravel
RUN chown -R www-data:www-data storage bootstrap/cache \
    && chmod -R 775 storage bootstrap/cache

# Expose le port 80, qui est le port par défaut pour Nginx dans cette image
EXPOSE 80

# Commande de démarrage du conteneur. Nginx et PHP-FPM sont déjà configurés pour démarrer avec cette image de base.
CMD ["nginx", "-g", "daemon off;"]
