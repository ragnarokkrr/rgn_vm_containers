from confluent_kafka import KafkaError
from confluent_kafka.avro import AvroConsumer
from confluent_kafka.avro.serializer import SerializerError

SCHEMA_REGISTRY_URL = 'http://172.17.0.5:8081'

BOOTSTRAP_SERVERS = '172.17.0.4'

TOPIC = 'avrotopic'

GROUP = 'test_group'

c = AvroConsumer({'bootstrap.servers': BOOTSTRAP_SERVERS,
                  'schema.registry.url': SCHEMA_REGISTRY_URL,
                  'group.id': GROUP
                  })
c.subscribe([TOPIC])
running = True

while running:
    try:
        msg = c.poll(10)
        if msg:
            if not msg.error():
                print(str(msg.value()))
            elif msg.error().code() != KafkaError._PARTITION_EOF:
                print(msg.error())
                running = False
    except SerializerError as e:
        print("Message deserialization failed for %s: %s" % (msg, e))
        running = False

c.close()
