# generate-kafka-replication-factor-json
Useful if you need to change the replication factor of an already created Kafka topic. It creates the JSON necessary for the kafka command kafka-reassign-partitions.
## Usage
In the **generate-kafka-replication-factor-json.sh** file, you just have to change the values of the following variables to match your needs:
* BROKER_IDS
* NUMBER_OF_PARTITIONS
* NUMBER_OF_REPLICAS
* TOPIC_NAME

It will generate the result in a **increase-replication-factor.json** file.

Now you just have to use this JSON with the `kafka-reassign-partitions` Kafka command:
```
$ ./kafka-reassign-partitions.sh --zookeeper localhost:2181 --reassignment-json-file increase-replication-factor.json --execute
```

You can check your new replication policy worked with:
```
$ ./kafka-topics.sh --zookeeper localhost:2181 --topic topic --describe
```
