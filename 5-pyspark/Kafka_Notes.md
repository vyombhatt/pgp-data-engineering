# Kafka Notes

## Introduction to Kafka

Apache Kafka is an open-source distributed event streaming platform designed to handle high-throughput, real-time data feeds. Originally developed by LinkedIn and later open-sourced, Kafka is written in Scala & Java, and it's used for building real-time data pipelines and streaming applications.

Kafka enables the creation of applications that can process, store, and manage streams of records in real-time, providing fault tolerance, scalability, and high throughput.


## Kafka Architecture

The major components that form the Kafka Architecture include:
1. **Producer**
   - Producers are the applications or systems that send data (events) to Kafka topics.
   - They push messages to Kafka brokers (servers) through topics, which then become available for consumers to read.

2. **Consumer**
   - Consumers read data from Kafka topics. Each consumer in Kafka subscribes to one or more topics.
   - Kafka supports both **pull-based** and **push-based** consumption methods. Consumers can track and process messages from a specific point in the stream (offset).

3. **Broker and Cluster**
   - A **Kafka Broker** is a server that stores data and serves clients (producers and consumers). These servers mediate conversation between two systems, they are responsible for delivering messages to the right party.
   - **Kafka clusters** are typically made up of multiple brokers for fault tolerance and scalability. Kafka ensures data replication across brokers, so data is not lost even if one broker fails.

Other components of Kafka include:
1. **Topic**
   - A **topic** is a category or feed to which Kafka producers send **messages**. 
   - Messages are simply byte arrays that can store any object in typical data formats like String, JSON, Avro etc.
   - Consumers subscribe to these topics to consume the data.
   - Topics in Kafka are broken down into partitions. Messages are written to partitions in append-only fashion.
   - The partitions are distributed across brokers (and replicated too) for scalability and fault tolerance.

2. **Partition**
   - Kafka topics are divided into **partitions**. Partitions allow Kafka to horizontally scale and parallelize message processing.
   - Each partition is an ordered, immutable sequence of records. Partitions allow Kafka to distribute the load across different brokers.

3. **Offset**
   - An **offset** is a unique identifier for each record within a partition. Kafka uses offsets to track which records have been consumed.
   - Consumers maintain their position using offsets, enabling them to continue consuming from the correct position in the topic stream.

4. **ZooKeeper**
   - **ZooKeeper** is used by Kafka to coordinate and manage distributed processes. It is responsible for keeping track of broker metadata, managing leader election for partitions, and maintaining cluster state.
   - Kafka relies on ZooKeeper to manage distributed system consistency, but in recent versions, Kafka has been moving towards **KRaft mode** (Kafka Raft), which removes the need for ZooKeeper.


## Kafka Workflow

Kafka uses a publish-subscribe (Pub/Sub) model where producers send messages to topics and consumers subscribe to topics to process messages.

1. **Producer Sends Data**:
    - The producer sends a message to a Kafka topic. The message could be a log, event, or any form of data.
    - Kafka allows producers to publish messages using synchronous or asynchronous methods, depending on the configuration.
    - Producers select the partition to send the messages to, per topic. They can also implement a priority system i.e. sending a message to a certain partition depending on priority of the message.
    - Producers don't wait for acknowledgement from brokers, and they keep sending messages as fast as the brokers can handle.

2. **Broker Stores the Message**:
    - Multiple brokers form a cluster to maintain the load balance.
    - Kafka brokers store messages in partitions. Each partition is an ordered log of messages, and Kafka appends new messages to the end of the log.
    - Each message is assigned a unique offset within the partition.
    - Kafka maintains multiple copies (replicas) of the data to ensure high availability and fault tolerance.
    - One broker instance can handle thousands of read-writes per second and TBs of messages. 
    - Backups of topic partitions are stored in multiple brokers

3. **Consumer Reads Messages**:
    - Consumers subscribe to one or more Kafka topics and read messages.
    - Consumers can use polling to fetch messages from Kafka topics.
    - Consumers can be part of a consumer group, where the group collectively consumes the data. Each partition is consumed by one consumer in the group, ensuring parallel processing and load balancing.
    - Having subscribed to a topic, consumers with request Kafka broker at regular intervals (e.g. in every 200ms )

4. **Processing and Acknowledgment**:
    - Consumers process the messages based on their logic (e.g., transforming, storing in a database, triggering downstream events).
    - After processing, consumers may commit the offset to Kafka, signifying that the messages have been successfully processed.
    - Stream Processing applications can be built using Kafka Streams or integrated with systems like Apache Flink or Apache Spark for real-time transformations and analytics.

## Kafka Use Cases

Kafka is widely used in various real-time data processing scenarios. Some common use cases include:

1. **Real-Time Data Pipelines**:
   - Kafka is used to build reliable data pipelines that transport large volumes of data from one system to another in real time.

2. **Event Sourcing**:
   - Kafka can store streams of immutable event logs, which can be replayed, audited, or used for reconstructing system states.

3. **Log Aggregation**:
   - Kafka is often used for collecting and aggregating logs from various services, providing a centralized log repository.

4. **Real-Time Analytics**:
   - Kafka enables real-time analytics by streaming data to analytics platforms like Apache Spark, Apache Flink, or other data processing frameworks.

5. **Messaging System**:
   - Kafka provides a high-throughput, low-latency messaging system for communication between microservices and other systems.

6. **Stream Processing**:
   - Kafka Streams API allows users to perform stream processing tasks, such as filtering, joining, and aggregating data in real time.


## Kafka Benefits

### 1. **Scalability**
   - Kafka is designed to handle very high throughput, with the ability to scale horizontally by adding more brokers to the cluster.
   - Topics are partitioned and distributed across multiple brokers, allowing Kafka to handle large volumes of data.

### 2. **Fault Tolerance**
   - Kafka replicates data across brokers to ensure fault tolerance. If one broker goes down, another replica can serve the data.
   - Kafka guarantees **data durability** and ensures that no data is lost even in case of broker failures.

### 3. **High Throughput**
   - Kafka is optimized for high-throughput message delivery. It can handle millions of messages per second due to its efficient storage and distributed architecture.

### 4. **Low Latency**
   - Kafka delivers messages with low latency, making it suitable for real-time data processing and event-driven applications.

### 5. **Durability**
   - Kafka provides durability by persisting messages to disk in a highly efficient manner. Even after messages are consumed, they remain available for replay for a configured retention period.

### 6. **Stream Processing**
   - Kafka supports stream processing natively through the **Kafka Streams API** and integrations with tools like **Apache Flink** and **Apache Spark** for real-time data analytics and processing.


## Setting up Kafka in your system

### Prerequisites

Before setting up Kafka, ensure that the following software is installed:
1. **Java**: Kafka is written in Java, so you must have Java 8 or later installed. You can download and install Java from the official Oracle website or install it via package managers like apt or brew (macOS).

2. **Zookeeper**: Kafka relies on Zookeeper for distributed coordination (though newer versions of Kafka are moving away from Zookeeper). Zookeeper must be installed and running before starting Kafka.

3. **Kafka**: Kafka itself is the core component you need to install.

### Steps for setting up Kafka
**Step 1: Download and Extract Apache Kafka**
- Download Kafka:
    - Go to the official Apache Kafka website.
    - Download the latest stable version of Kafka. Select the version that fits your operating system (tar/zip).
- Extract the archive:
    - If you've downloaded the Kafka `.tar` or `.tgz` file, extract it to a directory:
        ```bash
        tar -xvzf kafka_2.13-2.8.0.tgz
        ```
    This will extract Kafka into a directory named `kafka_2.13-2.8.0.`

**Step 2: Start Zookeeper**
- Kafka uses Zookeeper to manage distributed brokers and ensure fault tolerance. Kafka comes with an embedded Zookeeper server, but you can also set up a separate Zookeeper instance.

- Start the Zookeeper server:
    - Navigate to the Kafka directory:
        ```bash
        cd kafka_2.13-2.8.0
        ```
            - Start Zookeeper using the provided script:
        ```bash
        bin/zookeeper-server-start.sh config/zookeeper.properties
        ```
    This will start the Zookeeper server with the default configuration provided in the `config/zookeeper.properties` file.

- Note: By default, Zookeeper binds to `localhost:2181`. You can modify the configuration if needed.

**Step 3: Start Kafka Broker**
- Start the Kafka broker:
    - Open another terminal window and navigate to the Kafka directory again.
    - Run the following command to start the Kafka broker:
        ```bash
        bin/kafka-server-start.sh config/server.properties
        ```
    This will start a single Kafka broker using the default configuration found in `config/server.properties`.

    - By default, Kafka will run on localhost:9092, and it will communicate with the Zookeeper instance running on `localhost:2181`.

**Step 4: Create a Kafka Topic**
- Once Kafka is running, you can create a topic to send and consume messages. Topics are logical channels to which producers send messages, and consumers read from.

- Create a topic:
    - Use the following command to create a topic named my_topic:
        ```bash
        bin/kafka-topics.sh --create --topic my_topic --bootstrap-server localhost:9092 --partitions 1 --replication-factor 1
        ```
    This will create a topic with 1 partition and a replication factor of 1.

- List Kafka topics:
    - To verify that the topic has been created, you can list all topics using:
        ```bash
        bin/kafka-topics.sh --list --bootstrap-server localhost:9092
        ```
**Step 5: Produce Messages to Kafka Topic**
- Now that Kafka is up and running, you can start producing messages to your topic.

- Start a producer:
    - In a new terminal window, start the Kafka producer to send messages to your topic:
        ```bash
        bin/kafka-console-producer.sh --topic my_topic --bootstrap-server localhost:9092
        ```
    Type messages and press Enter to send them to Kafka. Each message will be added to the my_topic topic.

**Step 6: Consume Messages from Kafka Topic**
- Once messages are being produced to the topic, you can start consuming them.

- Start a consumer:
    - In another terminal window, start a Kafka consumer to read messages from the topic:
        ```bash
        bin/kafka-console-consumer.sh --topic my_topic --bootstrap-server localhost:9092 --from-beginning
        ```
    - This will start the consumer and display all messages in my_topic from the beginning.

    - Note: The `--from-beginning` flag tells the consumer to read messages from the beginning of the topic, not just new messages.

**Step 7: Test the Setup**
- Send messages: In the producer terminal, send a few test messages.
- Consume messages: In the consumer terminal, the messages will appear as you send them from the producer.

**Step 8: Stopping Kafka and Zookeeper**
- Stop Kafka:
    - To stop Kafka, press `Ctrl + C` in the terminal window where Kafka is running.
    - Alternatively, you can stop Kafka by running:
        ```bash
        bin/kafka-server-stop.sh config/server.properties
        ```
- Stop Zookeeper:
    - Similarly, press `Ctrl + C` in the terminal window where Zookeeper is running.
    - Or run the following command to stop Zookeeper:
        ```bash
        bin/zookeeper-server-stop.sh config/zookeeper.properties
        ```
**Step 9: Kafka Configuration (Optional)**
- Kafka's configuration files are located in the `config/` directory:
    - `server.properties`: Configuration for Kafka broker (e.g., ports, log directories, replication settings).
    - `zookeeper.properties`: Configuration for Zookeeper.
- You can customize these configuration files to suit your needs, such as changing the broker's listening port, log directories, or adjusting retention policies for topics.


## Conclusion

Apache Kafka is a powerful, distributed event streaming platform designed to handle large-scale, high-throughput, and fault-tolerant data streams. It is widely used in various industries for real-time analytics, messaging, data integration, and stream processing. Kafka's ability to handle millions of events per second while maintaining durability and scalability makes it an essential component in modern data architectures.

