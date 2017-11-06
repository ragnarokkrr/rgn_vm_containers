
## Docker - K8s Workflow


0 - deploy on local registry

1 - Docker build
2 - Local Dev using docker compose
3 - Local deploy test using minikube



# Obs


- Docker Compose and local managed docker registry worked 
- Localc Docker Managed registry exposed to minikube did not work on kubernetes
- Local registry `KubeRegistry` on kubernetes worked  



## Command Ref

### docker / docker compose commands

```bash
$ docker-compose up -d #Detached mode

$ docker-compose down

$ docker logs rgnk8spython_web_1

$ docker-compose logs

$ docker-compose build

$ docker-compose ps

$ docker-compose stop

$ docker-compose up 

$ docker exec -it rgnk8spython_web_1 bash

```

### docker compose test commands
```bash
curl -H "Content-Type: application/json" -X PUT -d '{"hello":999}' http://localhost:6000/testurl
curl -X GET http://localhost:6000/
```


### minikube / kubectl basics
```bash

$ minikube start --vm-driver=virtualbox

$ kubectl run hello-minikube --image=gcr.io/google_containers/echoserver:1.4 --port=8080

$ kubectl expose deployment hello-minikube --type=NodePort

$ kubectl get pod

$ curl $(minikube service hello-minikube --url)

$ kubectl get services

$ kubectl delete service hello-minikube

$ kubectl delete deployment  hello-minikube

$ minikube dashboard

```

### minikube / kubectl post
```bash
$ kubectl create -f redis-deployment.yaml

$ kubectl create -f redis-service.yaml

$ kubectl create -f flask-deployment.yaml

$ kubectl create -f flask-service.yaml


$ kubectl delete -f flask-service.yaml

$ kubectl delete -f flask-deployment.yaml

$ kubectl delete -f redis-deployment.yaml

$ kubectl delete -f redis-service.yaml


```
### Minikube insecure registry
```bash
$ minikube start --vm-driver=virtualbox --insecure-registry localhost:5000
 
$ eval $(minikube docker-env)
 
 
 
```

### docker local registry build tag push 
```bash 
$ docker run -d -p 5000:5000 --restart=always --name registry registry:2

# build 
$ docker build -t ragna/flaskservice .

# tag
$ docker tag ragna/flaskservice localhost:5000/ragna/flaskservice

#push
$ docker push localhost:5000/ragna/flaskservice

```


### WORKING !!! mtp Local registry on MINIKUBE howtos 
```bash
$ minikube start --vm-driver virtualbox --insecure-registry localhost:5000
$ eval $(minikube docker-env)
$ kubectl apply -f local-registry-mtp.yml

```

### docker local registry
```bash 

# start
$ docker run -d -p 5000:5000 --restart=always --name registry registry:2

# list 

$ curl http://localhost:5000/v2/_catalog
$ curl http://localhost:5000/v2/ragna/flaskservice/tags/list

```
### docker local registry
```bash
$ docker run -d -p 5000:5000 --restart=always --name registry registry:2

$ curl http://localhost:5000/v2/_catalog

```


### kubegen
```bash
$ sudo npm install -g yo
$ sudo npm install -g generator-kubegen
```


## Ref

* http://blog.apcelent.com/scaling-python-microservices-kubernetes.html
* https://github.com/kubernetes/minikube#quickstart
* [Stack Overflow - How to use local docker images in Kubernetes?
](https://stackoverflow.com/questions/42564058/how-to-use-local-docker-images-in-kubernetes)
* https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet#links
* [How do I change the Docker image installation directory?](https://forums.docker.com/t/how-do-i-change-the-docker-image-installation-directory/1169/8)
* [Sharing a local registry with minikube](https://blog.hasura.io/sharing-a-local-registry-for-minikube-37c7240d0615)

* [Running Kubernetes, Docker and a private Registry locally](http://sethlakowske.com/articles/howto-install-docker-kubernets-local-registry/)

* [How to browse docker registry to list images and image tags (or versions)](https://github.com/Juniper/contrail-docker/wiki/How-to-browse-docker-registry-to-list-images-and-image-tags-(or-versions))



* [(Kubernetes + Minikube) can't get docker image from local registry
](https://stackoverflow.com/questions/46065342/kubernetes-minikube-cant-get-docker-image-from-local-registry)



****

* [Getting Started with Kubernetes via Minikube](https://medium.com/@claudiopro/getting-started-with-kubernetes-via-minikube-ada8c7a29620)