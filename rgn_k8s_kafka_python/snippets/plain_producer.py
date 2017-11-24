from confluent_kafka import Producer


some_data_source = ['dddd','ffff','gggg']

p = Producer({'bootstrap.servers':'172.17.0.4'})
for data in some_data_source:
    p.produce('ragnatopic', data.encode('utf-8'))
p.flush()




