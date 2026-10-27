This course material focuses on **Wide Column NoSQL databases**, with a specific emphasis on **Apache Cassandra**. These databases are designed to manage petabytes of data across distributed systems while maintaining high availability and scalability.

### 1. Fundamentals of Wide Column Stores

Wide column databases, often described as "**two-dimensional key-value stores**," organize data into columns with dynamic rows. Unlike relational databases (RDBMS) that store data sequentially by row, wide column stores use **column families** and are **sparse**, meaning different rows can have entirely different columns.

**Core Structural Components:**

* 
**Row Key:** The primary index.


* 
**Column Family:** A group of related columns.


* 
**Column Qualifier:** A dynamic key within the row.


* 
**Timestamp:** Used for data versioning.



---

### 2. Architecture and Data Distribution

Wide column databases use different architectures to manage consistency and availability (CAP Theorem):

* 
**Master-Slave (HBase, Bigtable):** Provides strong consistency but has a conceptual single point of failure (the Master).


* 
**Peer-to-Peer / Masterless (Cassandra, ScyllaDB):** All nodes are equal, maximizing availability through eventual consistency.



**Key Distributed Concepts:**

* **Consistent Hashing (Token Ring):** Distributes data evenly across the cluster. When nodes are added or removed, only a small portion of data needs to be moved.


* 
**Virtual Nodes (VNodes):** Allow physical nodes to own multiple small ranges on the ring to improve load balancing.


* 
**Gossip Protocol:** A peer-to-peer communication method where nodes exchange state information (membership, metadata) every second to ensure the cluster converges quickly.



---

### 3. Read and Write Mechanics

These systems are optimized for **high write throughput** using a **Log-Structured Merge Tree**:

1. 
**Commit Log:** Data is first appended to a disk file for durability.


2. 
**MemTable:** Data is then written to an in-memory sorted structure.


3. 
**SSTable:** Once the MemTable is full, it is flushed to disk as an immutable **Sorted String Table**.


4. 
**Compaction:** A background process merges SSTables and removes "**Tombstones**" (markers for deleted data) to optimize reads.



For **Reads**, the system checks the MemTable, Row Cache, and uses **Bloom Filters** to quickly determine if data exists in a specific SSTable without scanning the whole disk.

---

### 4. Apache Cassandra & Data Modeling

Cassandra is the most widely adopted wide column store. It uses **CQL (Cassandra Query Language)**, which is SQL-like but lacks features like joins, foreign keys, or cross-partition transactions.

**Modeling Principles:**

* **Query-Driven Design:** Unlike RDBMS, you do not normalize data. You **denormalize** and design tables specifically to satisfy queries ("Space is cheap, reads are expensive").


* 
**Partition Key:** Determines which node stores the data and is mandatory for performant queries.


* 
**Clustering Key:** Determines how data is sorted on disk within a partition to facilitate range queries.



---

### 5. Tunable Consistency and Transactions

Cassandra allows developers to trade latency for consistency per-query:

* 
**QUORUM:** Requires a majority of replicas  to respond.


* 
**ANY/ONE:** Fastest but carries higher risk of data inconsistency.


* 
**Lightweight Transactions (LWT):** Uses the Paxos consensus algorithm for "Check-and-Set" operations (e.g., `IF NOT EXISTS`), though it is roughly 4x slower than standard writes.