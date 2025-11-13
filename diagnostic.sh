# Script de vérification rapide
# À exécuter sur le serveur pour diagnostiquer le problème

echo "=== Diagnostic du site de gestion ==="
echo ""

# 1. Vérifier l'emplacement
echo "1. Répertoire actuel :"
pwd
echo ""

# 2. Contenu du répertoire
echo "2. Contenu de /var/www/gestion_entreprise :"
ls -lah /var/www/gestion_entreprise
echo ""

# 3. Vérifier si c'est un dépôt Git
echo "3. Vérification Git :"
if [ -d "/var/www/gestion_entreprise/.git" ]; then
    echo "✓ Dépôt Git détecté"
    cd /var/www/gestion_entreprise
    echo "Branche actuelle : $(git branch --show-current)"
    echo "Dernier commit : $(git log -1 --oneline)"
else
    echo "✗ Pas de dépôt Git trouvé"
fi
echo ""

# 4. Vérifier les fichiers clés
echo "4. Fichiers clés :"
for file in index.html css/style.css js/entreprise.js entreprise/index.html admin/index.html; do
    if [ -f "/var/www/gestion_entreprise/$file" ]; then
        echo "✓ $file existe"
    else
        echo "✗ $file MANQUANT"
    fi
done
echo ""

# 5. Permissions
echo "5. Permissions :"
ls -ld /var/www/gestion_entreprise
echo ""

# 6. Apache
echo "6. Statut Apache :"
systemctl is-active apache2
echo ""

# 7. Configuration Apache
echo "7. DocumentRoot configuré :"
grep -r "DocumentRoot" /etc/apache2/sites-enabled/ 2>/dev/null
echo ""

# 8. Test HTTP
echo "8. Test HTTP local :"
curl -I http://localhost 2>/dev/null | head -5
echo ""

# 9. Logs récents
echo "9. Dernières erreurs Apache :"
tail -5 /var/log/apache2/error.log 2>/dev/null
echo ""

echo "=== Fin du diagnostic ==="
