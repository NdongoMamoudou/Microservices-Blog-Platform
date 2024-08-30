# Projet fil rouge

## Introduction

Ce projet est une application microservices construite avec Node.js et React. Il est conçu pour être déployé sur Kubernetes.

## Table des matières

- [Introduction](#introduction)
- [Table des matières](#table-des-matières)
- [Architecture](#architecture)
- [Chemins d'Ingress](#chemins-dingress)
- [Noms de Services Kubernetes](#noms-de-services-kubernetes)
- [Ports des Services](#ports-des-services)
- [Prérequis](#prérequis)
- [Installation](#installation)
- [Déploiement](#déploiement)
- [Minikube](#minikube)
- [Démarrage de NGINX](#démarrage-de-nginx)
- [Commandes Utilisées](#commandes-utilisées)

## Architecture

L'application est composée des services suivants :

- **Client** : Interface utilisateur construite avec React.
- **Posts** : Service pour la gestion des posts.
- **Comments** : Service pour la gestion des commentaires.
- **Query** : Service pour la gestion des requêtes.
- **Moderation** : Service pour la modération des commentaires.
- **Event Bus** : Service pour la gestion des événements entre les services.

### Chemins d'Ingress

- `/posts/create` : Dirigé vers le service `posts-clusterip-srv` sur le port 4000.
  - Utilisé pour créer de nouveaux posts.
  
- `/posts` : Dirigé vers le service `query-srv` sur le port 4002.
  - Utilisé pour récupérer la liste des posts existants.
  
- `/posts/?(.*)/comments` : Dirigé vers le service `comments-srv` sur le port 4001.
  - Utilisé pour créer ou récupérer les commentaires associés à un post spécifique.
  
- `/?(.*)` : Dirigé vers le service `client-srv` sur le port 3000.
  - Utilisé pour accéder à l'interface utilisateur.

### Noms de Services Kubernetes

Assurez-vous que les noms de services dans vos fichiers de déploiement Kubernetes correspondent aux noms de services utilisés dans le code de l'application. Voici les noms de services attendus :

- **client-srv** : Service pour l'interface utilisateur.
- **posts-clusterip-srv** : Service pour la gestion des posts.
- **query-srv** : Service pour la gestion des requêtes.
- **comments-srv** : Service pour la gestion des commentaires.
- **moderation-srv** : Service pour la modération des commentaires.
- **event-bus-srv** : Service pour la gestion des événements entre les services.

Si vous modifiez ces noms, assurez-vous également de mettre à jour les références correspondantes dans le code de l'application.

### Ports des Services

Chaque service écoute sur un port spécifique. Assurez-vous que ces ports sont correctement configurés dans vos fichiers de déploiement Kubernetes et dans tout autre outil de gestion des conteneurs que vous pourriez utiliser. Voici les ports attendus pour chaque service :

- **client-srv** : Écoute sur le port 3000.
- **posts-clusterip-srv** : Écoute sur le port 4000.
- **query-srv** : Écoute sur le port 4002.
- **comments-srv** : Écoute sur le port 4001.
- **moderation-srv** : Écoute sur le port 4003.
- **event-bus-srv** : Écoute sur le port 4005.

Si vous modifiez ces ports, assurez-vous également de mettre à jour les références correspondantes dans le code de l'application et les fichiers de configuration Kubernetes.

## Prérequis

- Node.js
- Docker
- Kubernetes (Minikube recommandé pour un environnement local)
- kubectl (outil en ligne de commande pour interagir avec Kubernetes)

## Installation

1. Clonez ce dépôt :
    ```bash
    git clone https://github.com/Mossbaddi/Pojet_fil_rouge.git
    ```

2. Installez les dépendances pour chaque service :
    ```bash
    cd client && npm install
    cd ../posts && npm install
    # Répétez pour tous les services
    ```

## Déploiement

1. **Construisez les images Docker pour chaque service** :
    ```bash
    docker build -t client ./client
    docker build -t posts ./posts 
    docker build -t query ./query
    docker build -t comments ./comments
    docker build -t moderation ./moderation
    docker build -t event-bus ./event-bus
    
    # Répétez pour tous les services
    ```
    Le projet est basé sur l'image **node:alpine**.

2. **Déployez les services sur Kubernetes** :
    ```bash
    kubectl apply -f k8s/
    ```

    **Déploiement manuel des pods** :

    - Déployez le service de gestion des posts :
      ```bash
      kubectl apply -f ./kubernetes/posts-deployment-service.yaml 
      kubectl apply -f ./kubernetes/posts-ingress.yaml 
      ```
      
    - Déployez les autres services un par un :
      ```bash
      kubectl apply -f ./kubernetes/event-bus-deployment-service.yaml 
      kubectl apply -f ./kubernetes/comments-deployment-service.yaml
      kubectl apply -f ./kubernetes/query-deployment-service.yaml
      kubectl apply -f ./kubernetes/moderation-deployment-service.yaml
      ```

3. **Forcer le rechargement des déploiements** :
    ```bash
    kubectl rollout restart deployment client-srv
    kubectl rollout restart deployment posts-clusterip-srv
    ```

## Minikube

### Démarrage de Minikube

Minikube est un outil qui vous permet d'exécuter Kubernetes localement. Vous pouvez suivre ces étapes pour démarrer Minikube et configurer un tunnel pour accéder à vos services via `localhost` :

1. **Démarrer Minikube** :
    ```bash
    minikube start
    ```

2. **Activer l'Ingress pour NGINX** :
    ```bash
    minikube addons enable ingress
    ```

3. **Configurer un tunnel pour accéder aux services via localhost** :
    ```bash
    minikube tunnel
    ```

   Cette commande doit être exécutée dans un terminal séparé car elle s'exécute en continu jusqu'à ce que vous la terminiez manuellement.

## Démarrage de NGINX

NGINX est utilisé comme Ingress Controller pour gérer le trafic vers les différents services dans le cluster Kubernetes. Voici comment vérifier que NGINX est correctement configuré :

1. **Vérifiez que le contrôleur NGINX est en cours d'exécution** :
    ```bash
    kubectl get pods -n ingress-nginx
    ```

    Vous devriez voir un pod NGINX en état `Running`.

2. **Consultez les logs pour des erreurs potentielles** :
    ```bash
    kubectl logs -n ingress-nginx <nom-du-pod-nginx>
    ```

3. **Exposer le port 3000 du service client pour l'accès local** :
    ```bash
    kubectl port-forward svc/client-srv 3000:3000
    ```

4. **Testez l'accès à vos services via NGINX Ingress** :
    ```bash
    curl http://localhost/posts/create
    ```

    Assurez-vous que le tunnel Minikube est en cours d'exécution si vous utilisez Minikube.

## Commandes Utilisées

Voici un récapitulatif des principales commandes utilisées dans ce projet :

- **Pour construire les images Docker** :
  ```bash
  docker build -t <nom-image> <dossier-service>
