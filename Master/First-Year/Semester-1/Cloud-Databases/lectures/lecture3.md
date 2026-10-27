This course material explores the fundamental concepts of system scalability, focusing on how cloud databases and applications handle varying loads through different architectural strategies.

### **Core Concepts of Scalability**

Scalability is the system's ability to handle load requirements, whether they are sudden traffic spikes (like Black Friday) or gradual growth, while minimizing costs during low-usage periods.

* 
**Vertical Scalability (Up/Down):** Involves updating the resources (like a VM) of a single node. It is straightforward and compatible with stateful apps but usually requires restarting the service.


* 
**Horizontal Scalability (In/Out):** Involves adding more nodes. This offers "infinite" scale and no downtime during expansion, but it requires stateless application architectures and often necessitates load balancers.



---

### **Scaling Strategies and Traffic Routing**

* 
**Dynamic Scaling:** Automatically adjusts resources based on real-time metrics such as CPU usage, memory, or number of requests. To account for delays in provisioning or health checks, systems often aim to keep load under 50%.


* 
**Scheduled Scaling:** Used for predictable patterns (e.g., lower usage at night) to avoid delays by "pre-warming" resources.


* 
**Routing Methods:** Traffic can be directed via a **Load Balancer** (single point of entry), **DNS load balancing**, or by making the application itself aware of the scaling. Load balancers also provide health monitoring, caching, and SSL offloading.



---

### **Application Layer Scalability**

Modern scalable systems favor **stateless applications**. Unlike traditional stateful apps that store session data in the application layer, stateless apps handle each request independently, deducing context from the current request only.

* 
**"Pets vs. Cattle" Analogy:** This concept highlights the shift toward automation. **Pets** are unique, hand-built servers that are difficult to replace, while **Cattle** are automated, interchangeable resources that can be easily replaced if they fail.



---

### **Database Layer Scalability**

Scaling databases is more complex, particularly for SQL (RDBMS) compared to NoSQL.

* 
**CAP Theorem:** States that a distributed system can only provide two of three guarantees: **C**onsistency, **A**vailability, and **P**artition Tolerance.


* 
**Consistency Types:** * **Strong:** All clients see new data immediately.


* 
**Eventual:** Clients see updates after a slight delay; common in read-heavy scaling where data replication is asynchronous.




* 
**Partitioning and Sharding:** * **Partitioning:** Splits data into subsets within a system based on a partition key to improve query performance.


* 
**Sharding:** Distributes these partitions across multiple physical nodes. While common in NoSQL, sharding is not well-supported in traditional RDBMS.
