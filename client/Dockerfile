# Étape 1: Construire l'application
FROM node:alpine AS build

# Définir le répertoire de travail
WORKDIR /app

# Copier les fichiers package et installer les dépendances
COPY package*.json ./
RUN npm install

# Copier le reste des fichiers de l'application
COPY . .

# Construire l'application pour la production
RUN npm run build

# Étape 2: Utiliser `serve` pour servir les fichiers statiques
FROM node:alpine

# Installer `serve`
RUN npm install -g serve

# Définir le répertoire de travail
WORKDIR /app

# Copier les fichiers construits à partir de l'étape précédente
COPY --from=build /app/build /app/build

# Exposer le port 3000
EXPOSE 3000

# Démarrer le serveur `serve`
CMD ["serve", "-s", "build", "-l", "3000"]
