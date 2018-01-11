# Netflix OSS PoCs


## Dummy Flask

```bash
# build from compose
$ docker-compose up --build

```


## BIND

```bash
$ host www.google.com 172.17.0.1


```
### Registering new dns
```
https://172.17.0.1:10000/

user: root
pwd: SecretPassword

```
#### Master Zone

* Servers-> Bind DNS Server -> Create Master Zone
    * Zone Type -> reverse
    * Domain Name Network -> 172.17.0.1
    * Master Server -> ns.ragna.io
    
#### Forward Zone

* Servers-> Bind DNS Server -> Create Master Zone
    * ZOne Type -> Forward
    * Domain Name: webserver.ragna.io  
    
```bash

$ host ns.ragna.io 172.17.0.1
```    

#### ISSUE Assign  name to specific DNS server
```bash
sudo /etc/NetworkManager/dnsmasq.d/dnsmasq.conf

# add line 
###

```

* https://askubuntu.com/questions/500162/how-do-i-restart-dnsmasq 
* 


### Issue - error starting userland proxy on ubuntu 
https://github.com/azukiapp/azk/issues/529
```
Hi,

Starting from docker 1.9.0 default docker bridge is 172.17.0.1 instead of 172.17.42.1. Is there any hardcoded configuration to use 172.17.42.1 ?
```

## REF

* [Deploying a DNS Server using Docker](http://www.damagehead.com/blog/2015/04/28/deploying-a-dns-server-using-docker/)
* [Configuring Eureka](https://github.com/Netflix/eureka/wiki/Configuring-Eureka)
* [Prana: A Sidecar for your Netflix PaaS based Applications and Services](https://medium.com/netflix-techblog/prana-a-sidecar-for-your-netflix-paas-based-applications-and-services-258a5790a015)
