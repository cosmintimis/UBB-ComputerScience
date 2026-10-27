Here is a comprehensive summary of the uploaded lectures, organized by topic and core concepts:

### **Lecture 1: Temporal Databases**

* 
**Definition**: Temporal databases manage time-varying data, allowing systems to store historical information rather than just a "snapshot" of the current state.


* **Time Types**:
* 
**Valid Time**: When a fact is true in the real world.


* 
**Transaction Time**: When a fact is recorded in the database; it cannot be changed once stored.


* 
**Bi-temporal**: Supports both valid and transaction time.




* 
**Data Types**: Core types include **Instants** (anchored points), **Intervals** (durations), and **Periods** (anchored durations).



### **Lecture 2-1: Temporal DB in Commercial Products (Oracle Focus)**

* **Oracle Flashback**: A suite of features to "rewind" data.
* 
**Flashback Database**: Restores the entire DB to a past state to fix logical corruption.


* 
**Flashback Drop**: Recovers accidentally deleted tables using a "Recycle Bin".


* 
**Flashback Query (AS OF)**: Interrogates data as it existed at a specific timestamp or SCN.




* 
**Temporal Validity**: Allows users to define explicit validity periods (`PERIOD FOR`) for records.



### **Lecture 2-2: Cloud Introduction**

* **Service Models**:
* 
**IaaS**: Virtual machines and networking (e.g., AWS EC2).


* 
**PaaS**: Development platforms without managing infrastructure (e.g., Google App Engine).


* 
**SaaS**: Fully managed software applications (e.g., Google Suite).




* 
**Deployment Models**: Includes Public, Private, Community, and Hybrid clouds.


* 
**Pricing**: Typically based on time (IaaS/PaaS) or usage (FaaS/NoSQL storage).



### **Lecture 3: Cloud Database Scalability**

* **Scalability**:
* 
**Vertical**: Adding more RAM/CPU to a single machine.


* 
**Horizontal**: Adding more nodes to a cluster; requires stateless applications.




* 
**Load Balancing**: Distributes traffic using strategies like **Round-Robin** or **Least Connections**.


* 
**CAP Theorem**: States a distributed system can only provide two of three: **Consistency**, **Availability**, and **Partition Tolerance**.



### **Lecture 4: RDBMS vs. NoSQL**

* 
**Workloads**: OLTP (Predefined schema, write-heavy) vs. OLAP (Ad-hoc, read-heavy, large volumes).


* 
**Google File System (GFS)**: Uses a **Master** for metadata and **Chunk Servers** to store 64-MB data replicas.


* 
**Consistency Models**: ACID (Strong consistency for RDBMS) vs. **BASE** (Basically Available, Soft state, Eventual consistency for NoSQL).



### **Lecture 5: Key-Value Stores**

* 
**Model**: Massive distributed hash maps optimized for `GET(key)` and `PUT(key, value)`.


* 
**Internal Storage**: Often uses **LSM Trees** (Log-Structured Merge Trees) for write-heavy performance, flushing data from in-memory **MemTables** to on-disk **SSTables**.


* 
**AWS DynamoDB**: A fully managed KV store using **Partition Keys** for sharding and **Sort Keys** for hierarchical range queries.



### **Lecture 6: Document Databases**

* 
**JSON vs. BSON**: Document databases typically store data in **BSON** (Binary JSON) on disk for faster traversal and indexing of native types.


* 
**MongoDB Architecture**: Scaled via **Sharding** and **Replica Sets** for high availability.


* 
**Modeling**: Choosing between **Embedding** (nesting related data) for performance or **Referencing** (links) for normalized data.



### **Lecture 7: Vector Databases**

* 
**Embeddings**: Objects (images, text) are converted into high-dimensional numerical vectors.


* 
**Similarity Search**: Uses distance metrics like **Cosine Similarity**, **Euclidean Distance**, or **Manhattan Distance** to find related points.


* 
**Algorithms**: Uses **Approximate Nearest Neighbor (ANN)** algorithms like **HNSW** for fast querying at scale.



### **Lecture 8: Change Data Capture (CDC)**

* **CDC Methods**:
* 
**Log-based**: Captures changes from DB transaction logs (highly efficient).


* 
**Trigger-based**: High overhead but works without log access.




* 
**Debezium**: An open-source CDC platform that streams real-time data changes into **Apache Kafka**.



### **Lecture 10: Wide Column Stores**

* 
**Nature**: Sits between Key-Value and Relational models; uses **Column Families**.


* 
**Apache Cassandra**: A masterless (Peer-to-Peer) system using a **Gossip Protocol** for node communication and **Consistent Hashing** (Token Ring) for data distribution.


* 
**Modeling**: **Query-Driven Design**; data is denormalized specifically to satisfy access patterns rather than entities.

Here is a summary of the last two lectures, focused on Graph Databases and Hierarchical Data in Relational Systems:

### **Lecture 11: NoSQL - Graph Databases**

* 
**Definition and Foundation**: Graph databases model data as a connected network of nodes and relationships rather than rigid tables. They are based on graph theory, where data is represented as a set of vertices (nodes) and edges (relationships).


* **Core Components**:
* 
**Nodes**: Represent entities like people, products, or cities.


* 
**Relationships**: Directed or undirected connections between nodes.


* 
**Properties**: Key-value pairs stored on both nodes and relationships for descriptive richness.




* **Data Models**:
* 
**Labeled Property Graph (LPG)**: The most common model (e.g., Neo4j), where nodes and edges are first-class entities carrying properties.


* 
**Resource Description Framework (RDF)**: Based on "triples" (subject-predicate-object) and used for the semantic web.


* 
**Hypergraphs**: Allow edges to connect more than two entities.




* 
**Graph vs. Relational**: Unlike relational databases that rely on expensive JOIN operations at query time, graph databases use **index-free adjacency**, where nodes directly reference neighbors. This enables near constant-time traversal regardless of global data size.


* **Query Languages**:
* 
**Cypher**: A declarative, pattern-matching language (ASCII-art style) used by Neo4j.


* 
**Gremlin**: A procedural, traversal-oriented language from the Apache TinkerPop framework.




* 
**Cloud Providers**: Major services include **Neo4j Aura** (fully managed Neo4j), **Amazon Neptune** (supports LPG and RDF), and **Azure Cosmos DB** (via Gremlin API).



### **Lecture 12: Hierarchical Data in RDBMS**

* 
**Introduction**: Hierarchical data is essential for modeling organizational structures, sitemaps, and product categories. While all hierarchies are trees, they specifically include properties of subordination and inheritance.


* **Design Models for RDBMS**:
* 
**Adjacency List**: Each record contains a reference to its parent. It is simple for insertions but requires recursive Common Table Expressions (CTEs) to retrieve full subtrees.


* 
**Path Enumeration**: Stores the entire path from the root as a string (e.g., "A/B/C"). It allows for easy subtree searching using `LIKE` predicates but can be inefficient if wildcards are used at the start of strings.


* 
**Nested Sets (Multimi Imbricate)**: Assigns `left` and `right` values to nodes based on a depth-first traversal. This makes finding all descendants extremely fast via a simple range query, though updates and deletions are very expensive due to renumbering.


* 
**Bridge Table (Closure Table)**: A separate table that stores every ancestor-descendant relationship and their depth. This simplifies subtree retrieval to a single JOIN but requires more storage.


* 
**Nested Intervals**: A generalization of nested sets using rational numbers to provide a "dense" domain, which helps avoid the massive renumbering issues of the standard nested sets model.