#!/bin/bash

# Fonction pour nettoyer en cas d'arrêt du script
cleanup() {
    echo "Cleaning up..."
    if [ -n "$tunnel_pid" ]; then
        echo "Terminating Minikube tunnel with PID $tunnel_pid..."
        kill $tunnel_pid
    fi
    exit 0
}

# Capturer le signal Ctrl+C (SIGINT)
trap cleanup SIGINT

# Vérifier si Minikube est déjà démarré
if minikube status | grep -q "host: Running"; then
    echo "Minikube is already running."
else
    echo "Starting Minikube..."
    minikube start
fi

# Activer l'addon Ingress
echo "Enabling Ingress addon..."
minikube addons enable ingress

# Vérifier si un tunnel est déjà en cours d'exécution
tunnel_pid=$(pgrep -f "minikube tunnel")

if [ -n "$tunnel_pid" ]; then
    echo "A Minikube tunnel is already running with PID $tunnel_pid. Terminating it..."
    kill $tunnel_pid
    sleep 2  # Pause pour s'assurer que le processus est bien terminé
fi

# Créer un nouveau tunnel pour permettre l'accès aux services via localhost
# echo "Starting Minikube tunnel in background..."
# minikube tunnel &
# tunnel_pid=$!  # Récupérer le PID du tunnel démarré

# Vérifier que le tunnel est bien en place
sleep 5 # Pause pour s'assurer que le tunnel a le temps de démarrer

# Lancer le déploiement avec Skaffold
echo "Deploying with Skaffold..."
skaffold dev

# Nettoyage si le script se termine normalement
cleanup