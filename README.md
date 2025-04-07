# 🪺 NestioBnb
La concurrence de airbnb en devenir

# Preview
![SCR-20250407-ozwe](https://github.com/user-attachments/assets/2d6c8a95-873d-4de8-9440-52a5ab59d83f)
![SCR-20250407-paca](https://github.com/user-attachments/assets/14d755fd-8177-484a-ab3a-cba9fe9cd49e)
![SCR-20250407-paen](https://github.com/user-attachments/assets/351f7f68-1850-4a2b-b098-30b596b79067)

# Prérequis
- Ruby
- Rails version 3.4.2
- PostgreSQL

# Installation

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
```

L'application sera accessible à l'adresse `http://localhost:3000`

# Configuration de l'IA

⚠️ **Attention** ⚠️

Pour utiliser les fonctionnalités d'IA en local, vous devez :
1. Créer un fichier `.env` à la racine du projet
2. Ajouter votre clé API OpenAI :
```bash
OPENAI_ACCESS_TOKEN=votre_clé_api
```
Sans cette configuration, les fonctionnalités d'IA ne seront pas disponibles en local.


# Collaborateurs
[Victor Harri-Chal](https://github.com/VictorHarri-Chal)
[Titouan Deschanels](https://github.com/titouandeschanels)
[Felipe Lobato](https://github.com/felp99)
