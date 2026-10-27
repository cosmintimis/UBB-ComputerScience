This course material explores the fundamental differences between **Relational Database Management Systems (RDBMS)** and **NoSQL** systems, detailing various architectures, scaling strategies, and storage models.

### Database Workloads and Scaling

The document distinguishes between two primary types of data workloads:

* 
**OLTP (Online Transactional Processing):** Traditional, write-heavy workloads based on transactions with predefined schemas and known access patterns.


* 
**OLAP (Online Analytical Processing):** Read-heavy workloads used for data warehouses, often involving large data volumes and long-running ad-hoc queries.



Systems scale using two strategies: **Scale-Up (vertical)** by adding more RAM, CPU, or HDD to a single machine, or **Scale-Out (horizontal)** by adding more commodity hardware.

---

### The NoSQL Movement

NoSQL ("Not Only SQL") refers to non-relational storage systems that typically lack a fixed schema and eliminate joins. While RDBMS provides precise answers, NoSQL is preferred for approximate answers delivered quickly at scale. Key foundational papers include Google's **BigTable** and Amazon's **Dynamo**.

#### Google File System (GFS) and BigTable

* 
**GFS:** A cluster-based system designed for huge files and inexpensive commodity hardware that frequently fails. It consists of **Clients**, **Master servers** (coordinators), and **Chunk servers** (storing 64-MB data replicas).


* 
**BigTable:** A sparsely populated, distributed hash mechanism built on top of GFS. It is a wide-column store where data is accessed via row keys, column keys, and timestamps.



---

### Distributed Computing Principles

The **CAP Theorem** states that a distributed system can only provide two of three properties at once:

1. 
**Consistency (C):** All clients see the same data.


2. 
**Availability (A):** The system remains operational despite node failures.


3. 
**Partition Tolerance (P):** The system functions despite network disruptions.



Most NoSQL systems use the **BASE** model (Basically Available, Soft state, Eventual consistency) rather than the RDBMS **ACID** model. **Eventual Consistency** ensures that if no new updates occur, all nodes will eventually become consistent.

---

### NoSQL Storage Models

| Model | Key Features | Examples |
| --- | --- | --- |
| **Key-Value** | Simple unique key/value pairs; highly scalable.

 | Redis, DynamoDB 

 |
| **Document** | Stores semi-structured data (JSON, XML) in "collections".

 | MongoDB, CouchDB 

 |
| **Columnar** | Stores data by column; efficient for analytics and sparse data.

 | HBase, Cassandra 

 |
| **Graph** | Focuses on "node-relationship" structures for interconnected data.

 | Neo4j 

 |

---

### Industry Trends

* 
**Polyglot Persistence:** The practice of using multiple database technologies within a single set of applications to solve different segments of a complex problem.


* 
**Market Status:** As of October 2025, traditional RDBMSs like **Oracle**, **MySQL**, and **Microsoft SQL Server** remain the highest-ranked systems, with **MongoDB** being the top-ranked NoSQL (Document) database.
