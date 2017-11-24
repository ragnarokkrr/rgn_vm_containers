from confluent_kafka import Consumer, KafkaError

c = Consumer({'bootstrap.servers': '172.17.0.4',
              'group.id': 'mygroup',
              'default.topic.config': {'auto.offset.reset': 'smallest'}})


c.subscribe(['ragnatopic'])
running = True




while running:
    msg = c.poll()
    if not msg.error():
        print ('Received message: %s' % msg.value().decode('utf-8'))
    elif msg.error().code() != KafkaError._PARTITION_EOF:
        print (msg.error())
        running = False


c.close()