# Application Name

## Description
La concurrence de airbnb en devenir

## Prérequis
- Ruby
- Rails version 3.4.2
- PostgreSQL

## Installation

1. Cloner le repository
```bash
git clone [URL_DU_REPO]
```

2. Installer les dépendances
```bash
bundle
```

3. Configuration de la base de données
```bash
rails db:create
rails db:migrate
```

4. Lancer le serveur
```bash
rails dev

L'application sera accessible à l'adresse `http://localhost:3000`

## Configuration de l'IA

⚠️ **Attention** ⚠️

Pour utiliser les fonctionnalités d'IA en local, vous devez :
1. Créer un fichier `.env` à la racine du projet
2. Ajouter votre clé API OpenAI :
```bash
OPENAI_ACCESS_TOKEN=votre_clé_api
```
Sans cette configuration, les fonctionnalités d'IA ne seront pas disponibles en local.

## Tests
```bash
rails test
```

## Collaborateurs
- [Nom du collaborateur 1] - *Rôle* - [GitHub Profile]
- [Nom du collaborateur 2] - *Rôle* - [GitHub Profile]


## Licence
Ce projet est sous licence []
