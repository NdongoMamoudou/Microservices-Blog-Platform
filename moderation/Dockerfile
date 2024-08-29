#utliser une imge de nodejs de base 
FROM node:alpine


# Définir le répertoire de travail dans l'image
WORKDIR /app


# Copier le fichier requirements.txt
COPY package*.json .


# Installer les dépendances
RUN  npm install 

# Copier le code
COPY index.js .

# Exposer le port de l'application
EXPOSE 4003

# Donner le point d'entrée/ la commande à lancer lorsque le conteneur sera executé
CMD ["node", "index.js"]
