#!/bin/bash

# Script de déploiement automatique pour le site de gestion
# À exécuter sur le serveur web

echo "=== Déploiement du site de gestion ==="
echo ""

# Variables
SITE_DIR="/var/www/gestion_entreprise"
REPO_URL="https://github.com/flavienxgrbld/gestion_entreprise.git"
WEB_USER="www-data"

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Fonction de log
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Vérifier si le répertoire existe
if [ -d "$SITE_DIR" ]; then
    log_info "Répertoire existant trouvé : $SITE_DIR"
    
    # Vérifier si c'est un dépôt Git
    if [ -d "$SITE_DIR/.git" ]; then
        log_info "Dépôt Git détecté, mise à jour en cours..."
        cd "$SITE_DIR" || exit 1
        
        # Sauvegarder les modifications locales si présentes
        if [ -n "$(git status --porcelain)" ]; then
            log_warn "Modifications locales détectées, sauvegarde..."
            git stash
        fi
        
        # Récupérer les dernières modifications
        log_info "Récupération des dernières modifications..."
        git fetch origin
        git reset --hard origin/main
        git pull origin main
        
    else
        log_warn "Le répertoire existe mais n'est pas un dépôt Git"
        log_info "Suppression et clonage du dépôt..."
        cd /var/www || exit 1
        rm -rf "$SITE_DIR"
        git clone "$REPO_URL" "$SITE_DIR"
    fi
else
    log_info "Clonage du dépôt dans $SITE_DIR..."
    cd /var/www || exit 1
    git clone "$REPO_URL" "$SITE_DIR"
fi

# Vérifier que les fichiers essentiels sont présents
log_info "Vérification des fichiers..."
cd "$SITE_DIR" || exit 1

missing_files=0

if [ ! -f "index.html" ]; then
    log_error "Fichier manquant : index.html"
    missing_files=1
fi

if [ ! -d "css" ]; then
    log_error "Dossier manquant : css"
    missing_files=1
fi

if [ ! -d "js" ]; then
    log_error "Dossier manquant : js"
    missing_files=1
fi

if [ ! -d "entreprise" ]; then
    log_error "Dossier manquant : entreprise"
    missing_files=1
fi

if [ ! -d "admin" ]; then
    log_error "Dossier manquant : admin"
    missing_files=1
fi

if [ $missing_files -eq 1 ]; then
    log_error "Des fichiers essentiels sont manquants !"
    echo ""
    log_info "Contenu actuel du répertoire :"
    ls -la
    exit 1
fi

log_info "Tous les fichiers essentiels sont présents ✓"

# Ajuster les permissions
log_info "Configuration des permissions..."
chown -R $WEB_USER:$WEB_USER "$SITE_DIR"
chmod -R 755 "$SITE_DIR"
find "$SITE_DIR" -type f -exec chmod 644 {} \;
find "$SITE_DIR" -type d -exec chmod 755 {} \;

log_info "Permissions configurées ✓"

# Vérifier la configuration Apache
log_info "Vérification de la configuration Apache..."
if [ -f "/etc/apache2/sites-available/gestion.conf" ]; then
    log_info "Configuration Apache trouvée"
else
    log_warn "Aucune configuration Apache spécifique trouvée"
    log_info "Création de la configuration..."
    
    tee /etc/apache2/sites-available/gestion.conf > /dev/null <<EOF
<VirtualHost *:80>
    ServerName srv-web-01
    DocumentRoot $SITE_DIR
    
    <Directory $SITE_DIR>
        Options Indexes FollowSymLinks MultiViews
        AllowOverride All
        Require all granted
    </Directory>
    
    ErrorLog \${APACHE_LOG_DIR}/gestion_error.log
    CustomLog \${APACHE_LOG_DIR}/gestion_access.log combined
</VirtualHost>
EOF
    
    log_info "Activation du site..."
    a2ensite gestion.conf
    a2enmod rewrite
fi

# Redémarrer Apache
log_info "Redémarrage d'Apache..."
systemctl restart apache2

if [ $? -eq 0 ]; then
    log_info "Apache redémarré avec succès ✓"
else
    log_error "Échec du redémarrage d'Apache"
    systemctl status apache2
    exit 1
fi

# Afficher un résumé
echo ""
echo "=== Résumé du déploiement ==="
log_info "Répertoire : $SITE_DIR"
log_info "Derniers commits :"
git log --oneline -3
echo ""
log_info "Fichiers déployés :"
ls -lh

# Test de connexion
echo ""
log_info "Test de connexion au site..."
if curl -s -o /dev/null -w "%{http_code}" http://localhost | grep -q "200"; then
    log_info "Site accessible ! ✓"
    echo ""
    log_info "Accédez au site : http://srv-web-01/"
else
    log_error "Le site ne répond pas correctement"
    echo ""
    log_info "Vérifiez les logs :"
    echo "  sudo tail -f /var/log/apache2/error.log"
fi

echo ""
log_info "Déploiement terminé !"
