- kubectl get all : voire la liste de toute les pods, service, demqrer 


-  kubectl apply -f ./kubernetes/client-deployment-service.yaml : demarrer un kernetes


- docker build -t client:latest ./client : creeation d un image d un dockerfile


---

- minikube start : Activation "minikube status"

- minikube status : Voire le status current 

- kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/cloud/deploy.yaml : ingress ngnix controller

---

- minikube addons enable ingress : activer le ngnix
- kubectl port-forward svc/client-srv 3000:3000 : exposer le por\t 