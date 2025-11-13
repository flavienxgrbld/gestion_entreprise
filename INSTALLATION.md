# Guide d'installation sur serveur web

## Problèmes courants et solutions

### 1. Permissions de fichiers (Linux)

Sur votre serveur, exécutez ces commandes :

```bash
# Donner les bonnes permissions au dossier
sudo chown -R www-data:www-data /var/www/gestion_entreprise
sudo chmod -R 755 /var/www/gestion_entreprise

# Permissions spécifiques pour les fichiers
sudo find /var/www/gestion_entreprise -type f -exec chmod 644 {} \;
sudo find /var/www/gestion_entreprise -type d -exec chmod 755 {} \;
```

### 2. Configuration Apache

Assurez-vous que votre VirtualHost est correctement configuré :

```apache
<VirtualHost *:80>
    ServerName votre-domaine.com
    DocumentRoot /var/www/gestion_entreprise
    
    <Directory /var/www/gestion_entreprise>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
    
    ErrorLog ${APACHE_LOG_DIR}/gestion_error.log
    CustomLog ${APACHE_LOG_DIR}/gestion_access.log combined
</VirtualHost>
```

Puis redémarrez Apache :
```bash
sudo systemctl restart apache2
```

### 3. Configuration Nginx

Si vous utilisez Nginx, créez ce fichier de configuration :

```nginx
server {
    listen 80;
    server_name votre-domaine.com;
    root /var/www/gestion_entreprise;
    index index.html;
    
    location / {
        try_files $uri $uri/ /index.html;
    }
    
    location ~* \.(css|js|jpg|jpeg|png|gif|ico|svg)$ {
        expires 1M;
        add_header Cache-Control "public, immutable";
    }
    
    error_page 404 /index.html;
}
```

Puis testez et redémarrez :
```bash
sudo nginx -t
sudo systemctl restart nginx
```

### 4. Vérification de l'installation

#### Test 1 : Vérifier les fichiers
```bash
ls -la /var/www/gestion_entreprise
```
Vous devriez voir :
- index.html
- css/ (dossier)
- js/ (dossier)
- entreprise/ (dossier)
- admin/ (dossier)

#### Test 2 : Vérifier les permissions
```bash
# Tous les fichiers doivent être lisibles
ls -l /var/www/gestion_entreprise/index.html
# Devrait afficher : -rw-r--r--
```

#### Test 3 : Tester localement sur le serveur
```bash
curl http://localhost/index.html
```
Vous devriez voir le code HTML.

#### Test 4 : Vérifier les logs
```bash
# Apache
sudo tail -f /var/log/apache2/error.log

# Nginx
sudo tail -f /var/log/nginx/error.log
```

### 5. Problèmes de chemins CSS/JS

Si les styles ne se chargent pas, vérifiez dans la console du navigateur (F12).

**Erreur courante** : `404 Not Found` pour les fichiers CSS/JS

**Solution** : Vérifiez que les dossiers css/ et js/ existent :
```bash
ls -la /var/www/gestion_entreprise/css/
ls -la /var/www/gestion_entreprise/js/
```

### 6. Problèmes de SELinux (CentOS/RHEL)

Si SELinux est activé :
```bash
sudo chcon -R -t httpd_sys_content_t /var/www/gestion_entreprise
sudo setsebool -P httpd_read_user_content 1
```

### 7. Firewall

Assurez-vous que le port 80 (et 443 pour HTTPS) est ouvert :
```bash
# UFW (Ubuntu/Debian)
sudo ufw allow 'Apache Full'
# ou
sudo ufw allow 'Nginx Full'

# Firewalld (CentOS/RHEL)
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --permanent --add-service=https
sudo firewall-cmd --reload
```

### 8. Test rapide

Créez un fichier test simple :
```bash
echo "<?php phpinfo(); ?>" | sudo tee /var/www/gestion_entreprise/test.php
```
Puis accédez à `http://votre-serveur/test.php`

Si cela fonctionne, le problème vient des chemins relatifs.
Si ça ne fonctionne pas, c'est un problème de configuration serveur.

## Commandes de diagnostic

```bash
# Vérifier qu'Apache/Nginx tourne
sudo systemctl status apache2
# ou
sudo systemctl status nginx

# Vérifier les ports en écoute
sudo netstat -tlnp | grep :80

# Vérifier la syntaxe de configuration
sudo apache2ctl configtest
# ou
sudo nginx -t

# Voir les processus web
ps aux | grep apache2
# ou
ps aux | grep nginx
```

## Support

Si le problème persiste :
1. Vérifiez les logs d'erreur du serveur web
2. Vérifiez la console du navigateur (F12 > Console)
3. Testez avec `curl -I http://localhost/index.html`
4. Vérifiez que les modules Apache requis sont activés :
   ```bash
   sudo a2enmod rewrite
   sudo a2enmod headers
   sudo systemctl restart apache2
   ```
