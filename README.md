# Système de Gestion d'Entreprise

Site web de gestion avec deux portails distincts : un portail entreprise et un portail administrateur.

## Structure du projet

```
gestion_entreprise/
├── index.html              # Page d'accueil avec sélection des portails
├── css/
│   ├── style.css          # Styles pour la page d'accueil
│   ├── entreprise.css     # Styles pour le portail entreprise
│   └── admin.css          # Styles pour le portail administrateur
├── js/
│   ├── entreprise.js      # Scripts pour le portail entreprise
│   └── admin.js           # Scripts pour le portail administrateur
├── entreprise/
│   └── index.html         # Page principale du portail entreprise
└── admin/
    └── index.html         # Page principale du portail administrateur
```

## Portails disponibles

### 1. Portail Entreprise
- Tableau de bord avec statistiques clés
- Gestion des employés
- Suivi des projets
- Gestion financière
- Génération de rapports
- Paramètres

### 2. Portail Administrateur
- Vue d'ensemble système
- Gestion des utilisateurs
- Gestion des entreprises
- Gestion des permissions
- Configuration système
- Journaux d'activité
- Sécurité

## Utilisation

1. Ouvrez `index.html` dans votre navigateur
2. Choisissez le portail souhaité :
   - **Portail Entreprise** : pour la gestion quotidienne de l'entreprise
   - **Portail Administrateur** : pour l'administration système

## Technologies utilisées

- HTML5
- CSS3 (avec gradients et animations)
- JavaScript vanilla
- Design responsive

## Fonctionnalités

- Interface moderne et intuitive
- Navigation latérale avec menu déroulant
- Cartes de statistiques interactives
- Listes d'activités et de tâches
- Design responsive pour mobile et tablette
- Animations et transitions fluides

## À venir

- Système d'authentification
- Connexion à une base de données
- API REST pour les opérations CRUD
- Graphiques et visualisations de données
- Export de données (PDF, Excel)
- Système de notifications en temps réel
