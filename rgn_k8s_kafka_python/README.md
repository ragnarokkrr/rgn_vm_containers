# Kafka/Docker/k8s 

## 1 - Docker - Using Apache Kafka Docker

### Kafka docker
```bash
$ docker run -d -p 2181:2181 --name zookeeper jplock/zookeeper

# 
$ docker run -d --name kafka --link zookeeper:zookeeper ches/kafka

```

### working

```bash
ZK_IP=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' zookeeper)
KAFKA_IP=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' kafka)


echo $ZK_IP, $KAFKA_IP

```


### create a topic
```bash
$ docker run --rm ches/kafka  kafka-topics.sh --create --topic test --replication-factor 1 --partitions 1 --zookeeper $ZK_IP:2181
```


### produce messages
```bash
docker run --rm --interactive ches/kafka  kafka-console-producer.sh --topic test --broker-list $KAFKA_IP:9092
```


### consume messages
```bash
docker run --rm ches/kafka kafka-console-consumer.sh   --topic test --from-beginning --zookeeper $ZK_IP:2181

docker run --rm ches/kafka kafka-console-consumer.sh   --topic test --from-beginning --bootstrap-server $KAFKA_IP:9092


```

## Confluent's Python Client for Apache KafkaTM

### librdkafka
 see https://github.com/confluentinc/confluent-kafka-python/issues/202


```bash

wget -qO - http://packages.confluent.io/deb/3.3/archive.key | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] http://packages.confluent.io/deb/3.3 stable main"

sudo apt-get install librdkafka-dev python-dev

sudo pip install confluent-kafka

sudo  pip install confluent-kafka[avro]
```

### create topic 

```bash
#create
docker run --rm ches/kafka  kafka-topics.sh --create --topic ragnatopic --replication-factor 1 --partitions 1 --zookeeper $ZK_IP:2181



docker run --rm ches/kafka  kafka-topics.sh --create --topic avrotopic --replication-factor 1 --partitions 1 --zookeeper $ZK_IP:2181

```


### create avro schema registry

### https://hub.docker.com/r/confluent/schema-registry/~/dockerfile/
```bash
docker run -d --name schema-registry --link zookeeper:zookeeper --link kafka:kafka --env SCHEMA_REGISTRY_AVRO_COMPATIBILITY_LEVEL=none confluent/schema-registry


docker ps -f "status=exited"


docker start zookeeper
docker start kafka
docker start schema-registry

SCHEMA_IP=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' schema-registry)
ZK_IP=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' zookeeper)
KAFKA_IP=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' kafka)


echo $ZK_IP, $KAFKA_IP, $SCHEMA_IP 


``` 


### registering avro schems 

[Schema Registry API Reference](https://docs.confluent.io/3.0.0/schema-registry/docs/api.html)

```bash

curl -X POST -H "Content-Type: application/vnd.schemaregistry.v1+json" \
    --data @user.avsc \
    http://$SCHEMA_IP:8081/subjects/User/versions

#{"id":21}

curl -X GET http://$SCHEMA_IP:8081/subjects

curl -X GET http://$SCHEMA_IP:8081/subjects/User/versions


curl -X GET http://$SCHEMA_IP:8081/subjects/User/versions/1

curl -X GET http://$SCHEMA_IP:8081/subjects/avrotopic-key/versions/1

```

## 2 - Docker compose




## 3 k8s


# Ref

* [Using Apache Kafka Docker](https://howtoprogram.xyz/2016/07/21/using-apache-kafka-docker/)
* [ches/docker-kafka](https://github.com/ches/docker-kafka)
* [Install Confluent Platform](https://docs.confluent.io/current/installation/installing_cp.html#installation-apt)
* [Example of kafka-python producer using Avro](https://gist.github.com/jakekdodd/e7ee38fd945818d86eb4)
* [Kafka Tutorial: Kafka, Avro Serialization and the Schema Registry](http://cloudurable.com/blog/kafka-avro-schema-registry/index.html)