const { HighLevelConsumer, HighLevelProducer, KeyedMessage } = kafka = require('kafka-node');

const client = new kafka.Client('localhost:2181/', 'VettingService');

// Setup our Kafka producer
const producer = new HighLevelProducer(client);

// Create conversation.question_accepted topic
producer.on('ready', function() {
  return producer.createTopics(['conversation.question_accepted'], false, function(err, data) {
    if (err) {
      return console.log(err);
    } else {
      return console.log('Topic "conversation.question_accepted" created successfully.')
    }
  });
});

// Setup our Kafka consumer
const consumer = new HighLevelConsumer(client, [
  { topic: 'conversation.question_accepted', offset: 0 }
]);

consumer.on('message', function(event) {
  console.log('message', event, event.event_type);
});

console.log('Started!');
