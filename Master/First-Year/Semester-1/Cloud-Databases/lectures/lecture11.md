This course material explores the fundamentals of **graph databases**, focusing on their architectural advantages over relational models and a deep dive into **Neo4j**, the industry's most widely adopted graph database.

---

## 1. Why Graph Databases?

Traditional relational models often struggle with highly interconnected datasets. Graph databases offer:

* 
**Performance**: They use **index-free adjacency**, where nodes directly reference neighbors, allowing near constant-time traversals regardless of total data size.


* 
**Semantic Clarity**: Data is modeled as a network of **nodes** (entities), **relationships** (connections), and **properties** (attributes) rather than rigid tables.


* 
**Flexibility**: They support **schema-optional** (schema-on-read) modeling, allowing data structures to evolve organically, unlike the strict JOIN-heavy requirements of relational systems.



## 2. Graph Data Models

The material identifies four primary ways to model graph data:

* 
**Labeled Property Graph (LPG)**: The most common model (used by Neo4j and TigerGraph) where nodes and edges are first-class entities that can carry arbitrary key-value properties.


* 
**Resource Description Framework (RDF)**: The foundation of the semantic web, using **triples** (subject, predicate, object) and URIs to ensure semantic interoperability and logical inference.


* 
**Hypergraph**: Allows a single **hyperedge** to connect any number of nodes, which is useful for complex biological networks where relationships are not strictly binary.


* 
**Relation-Centric**: Treats relationships as rich entities that can participate in other relationships or exist independently of node pairs.



## 3. Neo4j Architecture & Storage

Neo4j is a native graph database providing **ACID transactions**.

* **Internal Storage**: Data is persisted in fixed-size record files. For example, a node record is **15 bytes**, while a relationship record is **34 bytes**.


* 
**Query Processing**: A client query enters through the **Transport** layer, is parsed and optimized by the **Cypher Query Planner**, and finally carried out by the **Execution Engine**.


* 
**Indexing**: While it relies on index-free adjacency for traversals, it uses **B-tree** (exact matches), **Token lookup** (labels/types), and **Full-text** (Lucene-based search) indexes for initial node lookups.



## 4. Cypher Query Language

Cypher is a declarative, pattern-matching language that uses **ASCII-art syntax** to represent graph structures:

* 
**Nodes**: Represented by parentheses, e.g., `(p:Person)`.


* 
**Relationships**: Represented by brackets and arrows, e.g., `-[:LIKES]->`.


* 
**Operations**: Supports standard CRUD actions such as `MATCH`, `CREATE`, `SET`, `DELETE`, and `RETURN`.



## 5. Use Cases & Cloud Providers

| Category | Common Use Cases |
| --- | --- |
| **Applications** | Social networks, fraud detection (financial patterns), knowledge graphs, and supply chain optimization.

 |
| **Cloud Services** | <br>**Neo4j Aura** (fully managed native graph), **Amazon Neptune** (supports LPG and RDF), and **Azure Cosmos DB** (multi-model with Gremlin API).