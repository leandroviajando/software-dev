# [Designing Data-Intensive Applications](https://github.com/keyvanakbary/learning-notes/blob/master/books/designing-data-intensive-applications.md)

## Part I. Foundations of Data Systems

### Chapter 1: Reliable, Scalable, and Maintainable Applications

Many applications today are _data-intensive_, as opposed to _compute-intensive_. Raw CPU power is rarely a limiting factor for these applications - bigger problems are usually the amount of data, the complexity of data, and the speed at which it is changing.

#### Reliability

The system should continue to work _correctly_ (performing the correct function at the desired level of performance) even in the face of _adversity_.

The things that can go wrong are called _faults_, and systems that anticipate faults and can cope with them are called _fault-tolerant_ or _resilient_.

- Hardware Faults
- Software Errors
- Human Errors:
  - Decouple the places where people can make mistakes from the places where they can cause failures.
  - Allow quick and easy recovery from human errors, to minimise the impact in the case of a failure.

Note that a fault is no the same as a failure. A fault is usually defined as one component of the system deviating from its spec, whereas a _failure_ is when the system as a whole stops providing the required service to the user. It is impossible to reduce the probability of a fault to zero; therefore, it is usually best to design fault-tolerance mechanisms that prevent faults from causing failures.

#### Scalability

As the system _grows_ (in data volume, traffic volume, or complexity), there should be reasonable ways of dealing with that growth. _Scalability_ is the term we use to describe a system's ability to cope with increased load.

- Describing Load: _Load parameters_, e.g. rps
- Describing Performance: e.g. throughput, response times
  - It only takes a small number of slow requests to hold up the processing of subsequent requests - an effect sometimes known as _head-of-line blocking_. Even if those subsequent requests are fast to process on the server, the client will see a slow overall response time due to the time waiting for the prior request to complete. Due to this effect, it is important to measure response times on the client side.
  - Even if only a small percentage of backend calls are slow, the chance of getting a slow call increases if an end-user request requires multiple backend calls, and so a higher proportion of end-user requests end up being slow (an effect known as _tail latency amplification_).
- Approaches for Coping with Load
  - Vertical scaling (usually very expensive)
  - Horizontal scaling / _share-nothing architecture_ (more flexible)

#### Maintainability

Over time, many different people will work on the system (engineering and operations, both maintaining current behaviour and adapting the system to new use cases), and they should all be able to work on it _productively_.

- Operability: Making Life Easy for Operations - enabling observability of the system's health
- Simplicity: Managing Complexity - good abstractions can help reduce complexity
- Evolvability: Making Change Easy - agile, TDD, SOLID

### Chapter 2: Data Models and Query Languages

Historically, data started out being represented as one big tree (the hierarchical model), but that wasn't good for representing many-to-many relationships, so the relational model was invented to solve that problem. More recently, developers found that some applications don't fit well in the relational model either. New nonrelational "NoSQL" (Not only SQL) data stores have diverged in two main directions:

1. _Document databases_ target use cases where data comes in self-contained documents and relationships between one document and another are rare.
2. _Graph databases_ go in the opposite direction, targeting use cases where anything is potentially related to everything.

#### Relational Model Versus Document Model

Schema-on-read is similar to dynamic (runtime) type checking in programming languages, whereas schema-on-write is similar to static (compile-time) type checking.

#### Query Languages for Data

Declarative query languages lend themselves to parallel execution.

##### MapReduce Querying

The `map` and `reduce` functions are somewhat restricted in what they are allowed to do. They must be _pure_ functions, which menas they only use the data that is passed to them as input, they cannot perform additional database queries, and they must not have any side effects. These restrictions allow the database to run the functions anywhere, in any order, and rerun them on failure.

### Chapter 3: Storage and Retrieval

#### Data Structures that Power Your Database

- Appending logs
  - Hash Indices
  - SSTables and LSM-Trees
- Update in-place
  - B-Trees

#### Transaction Processing or Analytics?

At first, the same databases were used for both transaction processing and analytic queries. SQL turned out to be flexible in this regard: it works well for OLTP-type queries as well as OLAP-type queries. Nevertheless, in the late 1980s and early 1990s, there was a trend for companies to stop using their OLTP systems for analytics purposes, and to run the analytics on a separate database instead. This separate database was called a _data warehouse_.

OLTP systems are typically user-facing, which means that they may see a huge volume of requests. In order to handle the load, applications usually only touch a small number of records in each query. The application requests records using some kind of key, and the storage engine uses an index to find the data for the requested key. Disk seek time is often bottleneck here.

Data warehouses and similar analytic systems are primarily used by business analysts, not by end users. They handle a much lower volume of queries than OLTP systems, but each query is typically very demanding, requiring millions of records to be scanned in a short time. Disk bandwidth (not seek time) is often the bottleneck here, and column-oriented storage is an increasingly popular solution for this kind of workload.

| Property             | Transaction processing systems (OLTP)             | Analytic systems (OLAP)                   |
| -------------------- | ------------------------------------------------- | ----------------------------------------- |
| Main read pattern    | Small number of records per query, fetched by key | Aggregate over large number of records    |
| Main write pattern   | Random-access, low-latency writes from user input | Bulk import (ETL) or event stream         |
| Primarily used by    | End user/customer, via web application            | Internal analyst, for decision support    |
| What data represents | Latest state of data (current point in time)      | History of events that happened over time |
| Dataset size         | Gigabytes to terrabytes                           | Terrabytes to petabytes                   |

##### Data Warehousing

A big advantage of using a separate data warehouse, rather than querying OLTP systems directly for analytics, is that the data warehouse can be optimised for analytic access patterns.

##### Stars and Snowflakes: Schemas for Analytics

Many data warehouses are used in a fairly formulaic style, known as a _star schema_ (also known as _dimensional modelling_). At the centre of the schema is a _fact table_. Each row of the fact table represents an event that occurred at a particular time. The name "star schema" comes from the fact that when the table relationships are visualised, the fact table is in the middle, surrounded by its _dimension tables_ (connected through foreign keys); the connections to these tables are like the rays of a star.

A variation of this template is known as the _snowflake schema_, where dimensions are further broken down into subdimensions.

#### Column-Oriented Storage

Instead of storing all the values from one row together, store all the values from each _column_ together. If each column is stored in a separate file, a query only needs to read and parse those columns that are used in that query, which can save a lot of work, minimising the the amount of data that the query needs to read from disk.

Not every data warehouse is necessarily a column store: traditional row-oriented databases and a few other architectures are also used. However, columnar storage can be significantly faster for ad hoc analyticcal queries, so it is rapidly gaining popularity.

##### Column Compression

##### Aggregation: Data Cubes and Materialized Views

A special case of a materialised view is known as a _data cube_ or _OLAP cube_. It is a grid of aggregates (`SUM`, `MAX`, and similar) grouped by different dimensions.

The advantage of a materialised data cube is that certain queries become very fast because they have effectively been precomputed. The disadvantage is that a data cube doesn't have the same flexibility as querying the raw data. Most data warehouses therefore try to keep as much raw data as possible, and use aggregates such as data cubes only as a performance boost for certain queries.

### Chapter 4: Encoding and Evolution

Many services need to support rolling upgrades, where a new version of a service is gradually deployed to a few nodes at a time, rather than deploying to all nodes simultaneously. Rolling upgrades allow new versions of a service to be released without downtime (thus encouraging frequent small releases to be detected and rolled back before they affect a large number of users). These properties are hugely beneficial for _evolvability_, the ease of making changes to an application.

During rolling upgrades, or for various other reasons, we must assume that different nodes are running the different versions of our application's code. Thus, it is important that all data flowing around the system is encoded in a way that provides backward compatibility (new code can read old data) and forward compatibility (old code can read new data).

#### Formats for Encoding Data

- _Language-specific encodings_ are restricted to a single programming language and often fail to provide forward and backward compatibility.
- _Textual formats like JSON, XML and CSV_ are widespread, and their compatibility depends on how you use them. They have optional schema languages, which are sometimes helpful and sometimes a hindrance. These formats are somewhat vague about datatypes, so you have to be careful with things like numbers and binary strings.
- _Binary schema-driven formats like Thrift, Protocol Buffers and Avro_ allow compact, efficient encoding with clearly defined forward and backward compatibility semantics. The schemas can be useful for documentation and code generation in statically typed languages. However, they have the downside that data needs to be decoded before it is human-readable.

#### Modes of Dataflow

- _Databases_, where the process writing to the database encodes the data and the process reading from the database decodes it
- _RPC and REST APIs_, where the client encodes a request, the server decodes the request and encodes a response, and the client finally decodes the response
- _Asynchronous message passing_ (using message brokers or actors), where nodes communicate by sending each other messages that are encoded by the sender and decoded by the recipient

Backward/forward compatibility are thus quite achievable.

## Part II. Distributed Data

There are various reasons why you might want to distribute a database across multiple machines:

- _Scalability:_ If your data volume, read load, or write load grows bigger than a single machine can handle, you can potentially spread the load across multiple machines.
- _Fault tolerance/high availability:_ If your application needs to continue working even if one machine (or several machines, or the network, or an entire datacentre) goes down, you can use multiple machines to give you redundancy. When one fails, another one can take over.
- _Latency:_ If you have users around the world, you might want to have servers at various locations worldwide so that each user can be served from a datacenter that is geographically close to them. That avoids the users having to wait for network packets to travel halway around the world.

There are two common ways data is distributed across multiple nodes:

- _Replication:_ Keeping a copy of the same data on several different nodes, potentially in different locations. Replication provides redundancy: if some nodes are unavailable, the data can still be served from the remaining nodes. Replication can also help improve performance.
- _Partitioning:_ Splitting a big database into smaller subsets called partitions so that different partitions can be assigned to different nodes (also known as _sharding_).

### Chapter 5: Replication

Replication can serve several purposes:

- _High availability:_ Keeping the system running, even when one machine (or several machines, or an entire datacenter) goes down
- _Disconnected operation:_ Allowing an application to continue working when there is a network interruption
- _Latency:_ Placing data geographically close to users, so that users can interact with it faster
- _Scalability:_ Being able to handle a higher volume of reads than a single machine could handle, by performing reads on replicas

Despite being a simple goal - keeping a copy of the same data on several machines - replication turns out to be a remarkably tricky problem. It requires carefully thinking about concurrency and about all the things that can go wrong, and dealing with the consequences of those faults. At a minimum, we need to deal with unavailable nodes and network interruptions (and that's not even considering the more insidious kinds of fault, such as silent data corruption due to software bugs).

- _Single-leader replication:_ Clients send all writes to a single node (the leader), which sends a stream of data change events to the other replicas (followers). Reads can be performed on any replica, but reads from followers might be stale.
- _Multi-leader replication:_ Clients send each write to one of several leader nodes, any of which can accept writes. The leaders send streams of data change events to each other and to any follower nodes.
- _Leaderless replication:_ Clients send each write to several nodes, and read from several nodes in parallel in order to detect and correct nodes with stale data.

Each approach has advantages and disadvantages. Single-leader replication is popular because it is fairly easy to understand and there is no conflict resolution to worry about. Multi-leader and leaderless replication can be more robust in the presence of faulty nodes, network interruptions, and latency spikes - at the cost of being harder to reason about and providing only very weak consistency guarantees.

Replication can be _synchronous or asynchronous_, which has a profound effect on the system behaviour when there is a fault. Although asynchronous replication can be fast when the system is running smoothly, it's important to figure out what happens when replication lag increases and servers fail. If a leader fails and you promote an asynchronously updated follower to be the new leader, recently committed data may be lost.

There are some _consistency models_ that are helpful when deciding how an application should behave under replication lag:

- _Read-after-write consistency:_ Users should always see data that they submitted themselves.
- _Monotonic reads:_ After users have seen the data at one point in time, they shouldn't later see the data from some earlier point in time.
- _Consistent prefix reads:_ Users should see the data in a state that makes causal sense: for example, seeing a question and its reply in the correct order.

#### Leaders and Followers

- Synchronous Versus Asynchronous Replication
- Setting Up new Followers
- Handling Node Outages
- Implementation of Replication Logs

#### Problems with Replication Lag

- Reading Your Own Writes
- Monotonic Reads
- Consistent Prefix Reads
- Solutions for Replication Lag

#### Multi-Leader Replication

- Use Cases for Multi-Leader Replication
- Handling Write Conflicts
- Multi-Leader Replication Topologies

#### Leaderless Replication

- Writing to the Database When a Node is Down
- Limitations of Quorum Consistency
- Sloppy Quorums and Hinted Handoff
- Detecting Concurrent Writes

### Chapter 6: Partitioning

Partitioning is necessary when you have so much data that storing and processing it on a single machine is no longer feasible.

The goal of partitioning is to spread the data and query load evenly across multiple machines, avoiding hot spots (nodes with disproportionately high load). This requires choosing a partitioning scheme that is appropriate to your data, and rebalancing the partitions when nodes are added to or removed from the cluster.

There are two main approaches to partitioning:

- _Key range partitioning,_ where keys are sorted, and a partition owns all the keys from some minimum up to some maximum. Sorting has the advantage that efficient range queries are possible, but there is a risk of hot spots if the application often accesses keys that are close together in the sorted order.
  - In this approach, partitions are typically _rebalanced dynamically_ by splitting the range into two subranges when a partition gets too big.
- _Hash partitioning,_ where a hash function is applied to each key, and a partition owns a range of hashes. This method destroys the ordering of keys, making range queries inefficient, but may distribute load more evenly.
  - When partitioning by hash, it is common to create a fixed number of partitions in advance, to assign several partitions to each node, and to move entire partitions from one node to another when nodes are added or removed. Dynamic partitioning can also be used.

Hybrid approaches are also possible, for example with a compound key: using one part of the key to identify the partition and another part for the sort order.

A _secondary index_ also needs to be partitioned, and there are two methods:

- _Document-partitioned indices_ (local indices), where the secondary indices are stored in the same partition as the primary key and value. This means that only a single partition needs to be updated on write, but a read of the secondary index requires a scatter/gather across all partitions.
- _Term-partitioned indices_ (global indices), where the secondary indices are partitioned separately, using the indexed values. An entry in the secondary index may include records from all partitions of the primary key. When a document is written, several partitions of the secondary index need to be updated; however, a read can be served from a single partition.

Techniques for routing queries to the appropriate partition range from simple partition-aware load balancing to sophisticated parallel query execution engines.

By design, every partition operates mostly independently - that's what allows a partitioned database to scale to multiple machines. However, operations that need to write to several partitions can be difficult to reason about: for example, what happens if the write to one partition succeeds, but another fails?

#### Partitioning and Replication

#### Partitioning of Key-Value Data

- Partitioning by Key-Value Data
- Partitioning by Hash of Key
- Skewed Workloads and Relieving Hot Spots

#### Partitioning and Secondary Indices

- Partitioning Secondary Indices by Document
- Partitioning Secondary Indices by Term

#### Rebalancing Partitions

Automatic or Manual Rebalancing

#### Request Routing

Parallel Query Execution

### Chapter 7: Transactions

Transactions are an abstraction layer that allows an application to pretend that certain concurrency problems and certain kinds of hardware and software faults don't exist. A large class of errors is reduced down to a simple _transaction abort_, and the application just needs to try again.

An application with very simple access patterns, such as reading and writing only a single record, can probably manage without transactions. However, for more complex access patterns, transactions can hugely reduce the number of potential error cases you need to think about.

Without transactions, various error scenarios (process crashing, network interruptions, power outages, disk full, unexpected concurrency, etc.) mean that data can become inconsistent in various ways. For example, denormalised data can easily go out of sync with the source data. Without transactions, it becomes very difficult to reason about the effects that complex interacting accesses can have on the database.

Different types of race conditions may occur with concurrency:

- _Dirty reads:_ One client reads another client's writes before they have been committed. The read committed isolation level and stronger levels prevent dirty reads.
- _Dirty writes:_ One client overwrites data that another client has written, but not yet committed. Almost all transactions implementations prevent dirty writes.
- _Read skew (non-repeatable reads):_ A client sees different parts of the database at different points in time. This issue is most commonly prevented with snapshot isolation, which allows a transaction to read from a consistent snapshot at one point in time. It is usually implemented with _multi-version concurrency control (MVCC)._
- _Lost updates:_ Two clients concurrently perform a read-modify-write cycle. One overwrites thet other's write without incorporating its changes, so data is lost. Some implementations of snapshot isolation prevent this anomaly automatically, while other require a manual lock (`SELECT FOR UPDATE`).
- _Write skew:_ A transaction reads something, makes a decision based on the value it saw, and writes the decision to the database. However, by the time the write is made, the premise of the decision is no longer true. Only serialisable isolation prevents this anomaly.
- _Phantom reads:_ A transaction reads objects that match some search condition. Another client makes a write that affects the results of that search. Snapshot isolation prevents straightforward phantom reads, but phantoms in the context of write skew require special treatment, such as index-range locks.

Weak isolation levels protect against some of those anomalies but leave you, the application developer, to handle others manually (e.g., using explicit locking). Only serialisable isolation protects against all of those issues. We discussed three different approaches to implementing serialisable transactions:

- _Literally executing transactions in a serial order:_ If you can make each transaction very fast to execute, and the transaction throughput is low enough to process on a single CPU core, this is a simple and effective option.
- _Two-phase locking:_ For decades this has been the standard way of implementing serialisability, but many applications avoid using it because of its performance characteristics.
- _Serialisable snapshot isolation (SSI):_ A fairly new algorithm that avoids most of the downsides of the previous approaches. It uses an optimistic approach, allowing transactions to proceed without blocking. When a transaction wants to commit, it is checked, and it is aborted if the execution was not serialisable.

#### The Slippery Concept of a Transaction

##### The Meaning of ACID

- Atomicity
- Consistency
- Isolation
- Durability

##### Single-Object and Multi-Object Operations

#### Weak Isolation Levels

- Read Committed
- Snapshot Isolation and Repeatable Read
- Preventing Lost Updates
- Write Skew and Phantoms

#### Serializability

- Actual Serial Execution
- Two-Phase Locking (2PL)
- Serializable Snapshot Isolation (SSI)

### Chapter 8: The Trouble with Distributed Systems

A wide range of problems can occur in distributed systems:

- Whenever you try to send a packet over the network, it may be lost or arbitrarily delayed. Likewise, the reply may be lost or delayed, so if you don't get a reply, you have no idea whether the message got through.
- A node's clock may be significantly out of sync with other nodes (despite your best efforts to set up NTP), it may suddenly jump forward or back in time, and relying on it is dangerous because you most likely don't have a good measure of your clock's error interval.
- A process may pause for a substantial amount of time at any point in its execution (perhaps due to a stop-the-world garbage collector), be declared dead by other nodes, and then come back to life again without realising that it was paused.

The fact that such _partial failures_ can occur is the defining characteristic of distributed systems. Whenever software tries to do anything involving other nodes, there is the possibility that it may occasionally fail, or randomly go slow, or not respond at all (and eventually time out). In distributed systems, we try to build tolerance of partial failures into software, so that the system as a whole may continue functioning even when some of its constituent parts are broken.

To tolerate faults, the first step is to _detect_ them, but even that is hard. Most systems don't have an accurate mechanism of detecting whether a node has failed, so most distributed algorithms rely on timeouts to determine whether a remote node is still available. However, timeouts can't distinguish between network and node failures, and variable network delay sometimes causes a node to be falsely suspected of crashing. Moreover, sometimes a node can be in a degraded state: for example, a Gigabit network interface could suddenly drop to 1 Kb/s thoughput due to a driver bug. Such a node that is "limping" but not dead can be even more difficult to deal with than a cleanly failed node.

Once a fault is detected, making a system tolerate it is not easy either: there is no global variable, no shared memory, no common knowledge or any other kind of shared state between the machines. Nodes can't even agree on what time is, let alone anything more profound. The only way information can flow from one node to another is by sending it over the unreliable network. Major decisions cannot be safely made by a single node, so we require protocols that enlist help from other nodes and try to get a quorum to agree.

#### Faults and Partial Failures

Cloud Computing and Supercomputing

#### Unreliable Networks

- Network Faults in Practice
- Detecting Faults
- Timeouts and Unbounded Delays
- Synchronous Versus Asynchronous Networks

#### Unreliable Clocks

- Monotonic Versus Time-of-Day Clocks
- Clock Synchronisation and Accuracy
- Relying on Synchronised Clocks
- Process Pauses

#### Knowledge, Truth, and Lies

- The Truth is Defined by the Majority
- Byzantine Faults
- System Model and Reality

### Chapter 9: Consistency and Consensus

#### Consistency Guarantees

#### Linearizability

- What Makes a System Linearizable?
- Relying on Linearizability
- Implementing Linearizable Systems
- The Cost of Linearizability

#### Ordering Guarantees

- Ordering and Causality
- Sequence Number Ordering
- Total Order Broadcast

#### Distributed Transactions and Consensus

- Atomic Commit and Two-Phase Commit (2PC)
- Distributed Transactions in Practice
- Fault-Tolerant Consensus
- Membership and Coordination Services

## Part III. Derived Data

On a high level, systems that store and process data can be grouped into two broad categories:

- _Systems of record:_ A system of record, also known as _source of truth_, holds the authoritative version of your data. When new data comes in, e.g. as user input, it is first written here. Each fact is represented exactly once (the representation is typically normalized). If there is any discrepancy between another system and the system of record, then the value in the system of record is (by definition) the correct one.
- _Derived data systems:_ Data in a derived system is the result of taking some existing data from another system and transforming or processing it in some way. If you lose derived data, you can recreate it from the original source. A classic example is a cache: data can be served from the cache if present, but if the cache doesn't contain what you need, you can fall back to the underlying database. Denormalised values, indices and materialised views also fall in this category. In recommendation systems, predictive summary data is often derived from usage logs.

### Chapter 10. Batch Processing

We started by looking at Unix tools such as `awk`, `grep` and `sort`, and we saw how the design philosophy of those tools is carried forward into MapReduce and more recent dataflow engines. Some of those design principles are that inputs are immutable, outputs are intended to become the input to another (as yet unknown) programme, and complex problems are solved by composing small tools that "do one thing well."

In the Unix world, the uniform interface that allows one programme to be composed with another is files and pipes; in MapReduce, that interface is distributed filesystem. We saw that dataflow engines add their own pipe-like data transport mechanisms to avoid materialising intermediate state to distributed filesystem, but the initial input and final output of a job is still usually HDFS.

The two main problems that distributed batch processing frameworks need to solve are:

- _Partitioning:_ In MapReduce, mappers are partitioned according to input file blocks. The output of mappers is repartitioned, sorted and merged into a configurable number of reducer partitions. The purpose of this process is to bring all the related data - e.g., all the records with the same key - together in teh same place.
  - Post-MapReduce dataflow engines try to avoid sorting unless it is required, but they otherwise take a broadly similar approach to partitioning.
- _Fault tolerance:_ MapReduce frequently writes to disk, which makes it easy to recover from an individual failed task without restarting the entire job but slows down execution in the failure-free case. Dataflow engines perform less materialisation of intermediate state and keep more in memory, which means that they need to recompute more data if a node fails. Deterministic operators reduce the amount of data that needs to be recomputed.

There are several join algorithms for MapReduce, most of which are also internally used in MPP databases and dataflow engines. They also provide a good illustration of how partitioned algorithms work:

- _Sort-merge joins:_ Each of the inputs being joined goes through a mapper that extracts the join key. By partitioning, sorting and merging, all the records with the same key end up going to the same call of the reducer. This function can then output the joined records.
- _Broadcast hash joins:_ One of the two join inputs is small, so it is not partitioned and it can be entirely loaded into a hash table. Thus, you can start a mapper for each partition of the large join input, load the hash table for the small input into each mapper, and then scan over the large input one record at a time, querying the hash table for each record.
- _Partitioned hash joins:_ If the two join inputs are partitioned in the same way (using the same key, same hash function, and same number of partitions), then the hash table approach can be used independently for each partition.

Distributed batch processing engines have a deliberately restricted programming model: callback functins (such as mappers and reducers) are assumed to be stateless and to have no externally visible side effects besides their designated output. This restriction allows the framework to hide some of the hard distributed systems problems behind its abstraction: in the face of crashes and network issues, tasks can be retried safely, and the output from any failed tasks is discarded. If several tasks for a partition succeed, only one of them actually makes its output visible.

Thanks to the framework, your code in a batch processing job does not need to worry about implementing fault-tolerance mechanisms: the framework can guarantee that the final output of a job is the same as if no faults had occurred, even though in reality various tasks perhaps had to be retried. These reliable semantics are much stronger than what you usually have in online services that handle user requests and that write to databases as a side effect of processing a request.

The distinguishing feature of a batch processing job is that it reads some input data and produces some output data, without modifying the input - in other words, the output is derived from the input. Crucially, the input data is _bounded_: it has a known, fixed size (for example, it consists of a set of log files at some point in time, or a snapshot of a database's contents). Because it is bounded, a job knows when it has finished reading the entire input, and so a job eventually completes when it is done.

In the next chapter, we will turn to stream processing, in which the input is _unbounded_ - that is, you still have a job, but its inputs are never-ending streams of data. In this case, a job is never complete, because at any time there may still be more work coming in. We shall see that stream and batch processing are similar in some respects, but the assumption of unbounded streams also changes a lot about how we build systems.

#### Batch Processing with Unix Tools

- Simple Log Analysis
- The Unix Philosophy

#### MapReduce and Distributed Filesystems

- MapReduce Job Execution
- Reduce-Side Joins and Grouping
- Map-Side Joins
- The Output of Batch Workflows
- Comparing Hadoop to Distributed Databases

#### Beyond MapReduce

- Materialization of Intermediate State
- Graphs and Iterative Processing
- High-Level APIs and Languages

### Chapter 11: Stream Processing

Stream processing is very much like batch processing, but done continuously on unbounded (never-ending) streams rather than on a fixed-size input. From this perspective, _message brokers_ and _event logs_ serve as the streaming equivalent of a filesystem.

- _AMQP/JMS-style message broker:_ The broker assigns individual messages to consumers, and consumers acknowledge individual messages when they have been successfully processed. Messages are deleted from the broker once they have been acknowledged. This approach is appropriate as an asynchronous form of RPC, for example in a task queue, where the exact order of message processing is not important and where there is no need to go back and read old messages again after they have been processed.
- _Log-based message broker:_ The broker assigns all messages in a partition to the same consumer node, and always delivers messages in the same order. Parallelism is achieved through partitioning, and consumers track their progress by checkpointing the offset of the last message they have processed. The broker retains messages on disk, so it is possible to jump back and reread old messages if necessary.

The log-based approach has similarities to the replication lgos found in databases (see Chapter 5) and log-structured storage engines (see Chapter 3). We saw that this approach is especially appropriate for stream processing systems that consume input streams and generate derived state or derived output streams.

In terms of where streams come from, we discussed several possibilities: user activity events, sensors providing periodic readings, and data feeds (e.g., market data in finance) are naturally represented as streams. We saw that it can also be useful to think of the writes to a database as a stream: we can capture the changelog - i.e., the history of all chnages made to a database - either implicitly through change data capture or explicitly through event sourcing. Log compaction allows the stream to retain a full copy of the contents of a database.

Representing databases as streams opens up powerful opportunities for integrating systems. You can keep derived data systems such as search indices, caches, and analytics systems continually up to date by consuming the log of changes and applying them to the derived system. You can even build fresh views onto existing data by starting from scratch and consuming the log of changes from the beginning all the way to the present.

The facilities for maintaining state as streams and replaying messages are also the basis for the techniques that enable stream joins and fault tolerance in various stream processing frameworks. We discussed several purposes of stream processing, including searching for event patterns (complex event processing), computing windowed aggregations (stream analytics), and keeping derived data systems up to date (materialised views).

We then discussed the difficulties of reasoning about time in a stream processor, including the distinction between processing time and event timestamps, and the problem of dealing with straggler events that arrive after you thought your window was complete.

We distinguished three types of joins that may appear in stream processes:

- _Stream-stream joins:_ Both input streams consist of activity events, and the join operator searches for related events that occur within some window of time. For example, it may match two actions taken by the same user within 30 minutes of each other. The two join inputs may in fact be the same stream (a _self-join_) if you want ot find related events within one stream.
- _Stream-table joins:_ One input stream consists of activity events, while the other is a database changelog. The changelog keeps a local copy of the database up to date. For each activity event, the join operator queries the database and outputs an enriched activity event.
- _Table-table joins:_ Both input streams are database changelogs. In this case, every change on one side is joined with the latest state of the other side. The result is a stream of changes to the materialised view of the join between the two tables.

Finally, we discussed techniques for achieving fault tolerance and exactly-once semantics in a stream processor. As with batch processing, we need to discard the partial output of any failed tasks. However, since a stream process is long-running and produces output continuously, we can't simply discard all output. Instead, a finer-grained recovery mechanism can be used, based on microbatching, checkpointing, transactions, or idempotent writes.

#### Transmitting Stream Events

- Messaging Systems
- Partitioned Logs

#### Databases and Streams

- Keeping Systems in Sync
- Change Data Capture
- Event Sourcing
- State, Streams, and Immutability

#### Processing Streams

- Use of Stream Processing
- Reasoning About Time
- Stream Joins
- Fault Tolerance

### Chapter 12: The Future of Data Systems

#### Data Integration

- Combining Specialized Tools by Deriving Data
- Batch and Stream Processing

#### Unbundling Databases

- Composing Data Storage Technologies
- Designing Applications Around Dataflow
- Observing Derived State

#### Aiming for Correctness

- The End-to-End Argument for Databases
- Enforcing Constraints
- Timeliness and Integrity
- Trust, but Verify

#### Doing the Right Thing

- Predictive Analytics
- Privacy and Tracking
