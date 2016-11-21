const { HighLevelConsumer, HighLevelProducer, KeyedMessage } = kafka = require('kafka-node');

const client = new kafka.Client('localhost:2181/', 'VettingService');

// Setup our Kafka producer
const producer = new HighLevelProducer(client);

// Create vetting topic
producer.on('ready', function() {
  return producer.createTopics(['vetting'], false, function(err, data) {
    if (err) {
      return console.log(err);
    } else {
      return console.log('Topic "vetting" created successfully.')
    }
  });
});

// Setup our Kafka consumer
const consumer = new HighLevelConsumer(client, [
  { topic: 'vetting', offset: 0 }
]);

consumer.on('message', function(event) {
  console.log('message', event, event.event_type);
});

console.log('Started!');
