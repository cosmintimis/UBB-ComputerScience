This lecture provides a comprehensive overview of **Key-Value (KV) Stores**, focusing on their fundamental architecture, internal implementations, and a deep dive into **Amazon DynamoDB**.

---

## 1. Fundamentals of Key-Value Stores

Key-value stores are the simplest NoSQL data model, essentially acting as a massive, distributed hash map.

* 
**Core Operations:** Optimized strictly for `GET(key)` and `PUT(key, value)`.


* **Structure:**
* 
**Key:** A unique identifier (string or hash) used as an address for data retrieval.


* 
**Value:** An "opaque blob" (JSON, images, strings) that the database does not inspect or structure.




* 
**Performance:** Offers  constant-time access. They typically prioritize availability and partition tolerance (AP in the CAP model) and scale horizontally with ease.



---

## 2. Internal Implementation & Persistence

* 
**In-Memory Stores:** Use **Hash Tables** for fast average access (e.g., Redis, Memcached).


* 
**Persistent Stores:** Use **LSM Trees** (Log-Structured Merge Trees) to optimize write-heavy workloads on disk (e.g., LevelDB, RocksDB).


* 
**Durability:** Achieved through **Write-Ahead Logs (WAL)**, which log updates before applying them, and **Snapshots**, which periodically dump in-memory states to disk.


* 
**Conflict Resolution:** Systems like Dynamo use **Vector Clocks** to track version history and strategies like **Last Write Wins (LWW)** or **Read Repair** to resolve inconsistencies.



---

## 3. Amazon DynamoDB Deep Dive

DynamoDB is a fully managed NoSQL service designed for single-digit millisecond performance at any scale.

### Data Model & Indexing

* **Primary Key Types:**
* 
**Partition Key (Simple):** A single attribute used as input for a hash function to determine physical storage.


* 
**Composite Key:** Combines a **Partition Key** and a **Sort Key**. This allows for range queries and sorting within a partition.




* **Secondary Indexes:**
* 
**Local Secondary Index (LSI):** Shares the same partition key as the table but uses a different sort key; supports strong consistency.


* 
**Global Secondary Index (GSI):** Can have a different partition and sort key; spans the entire table and is always eventually consistent.





### Key Features

* 
**Capacity Modes:** **Provisioned** (pay for set capacity) or **On-Demand** (pay per request).


* 
**Streams:** Captures item-level changes (adds, updates, deletes) in near-real time. These are often used with **AWS Lambda** for event-driven programming.


* 
**Transactions:** Unlike many KV stores, DynamoDB supports **ACID transactions** for complex, multi-item operations.



---

## 4. API and Operations

DynamoDB operations are categorized into three planes:

* 
**Control Plane:** Manage tables and indexes (e.g., `CreateTable`, `UpdateTable`).


* 
**Data Plane:** Perform CRUD operations via the **Classic API** (`PutItem`, `GetItem`, `Query`, `Scan`) or **PartiQL** (SQL-compatible).


* 
**Streams/Transactions:** Specialized APIs for reading stream records or performing atomic multi-step updates.
