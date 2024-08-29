# Utiliser une image de base Node.js
FROM node:alpine

# Définir le répertoire de travail dans le conteneur
WORKDIR /app

# Copier les fichiers package.json et package-lock.json
COPY package*.json .

# Installer les dépendances
RUN npm install

# Copier tous les fichiers du répertoire de travail local dans le répertoire de travail du conteneur
COPY . .

# Exposer le port sur lequel l'application écoute
EXPOSE  4002

# Démarrer l'application
CMD ["node", "index.js"]
