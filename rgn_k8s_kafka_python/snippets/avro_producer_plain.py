from confluent_kafka import avro
from confluent_kafka.avro import AvroProducer
from lipsum import generate_words
import os
import random

SCHEMA_REGISTRY_URL = 'http://172.17.0.5:8081'
BOOTSTRAP_SERVERS = '172.17.0.4'

AVSC_DIR = os.path.dirname(os.path.realpath(__file__))
KEY_SCHEMA = avro.load(os.path.join(AVSC_DIR, 'primitive_string.avsc'))
VALUE_SCHEMA = avro.load(os.path.join(AVSC_DIR, 'basic_schema.avsc'))

TOPIC = 'avrotopic'
KEY = "mykey"

avroProducer = AvroProducer({'bootstrap.servers': BOOTSTRAP_SERVERS,
                             'schema.registry.url': SCHEMA_REGISTRY_URL},
                            default_key_schema=KEY_SCHEMA,
                            default_value_schema=VALUE_SCHEMA)


for i in xrange(100):
    value = {"name": generate_words(count=10),
             "number": random.randint(0, 100)}

    print str(value)

    avroProducer.produce(topic=TOPIC,
                         value=value,
                         key=KEY)


avroProducer.flush()