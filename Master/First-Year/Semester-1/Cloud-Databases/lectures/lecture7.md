This lecture provides a comprehensive overview of **Vector Databases**, covering their fundamental components, underlying mechanisms, and how they compare to traditional relational systems.

---

## What is a Vector?

* 
**Abstract Representation:** A vector is an abstract representation of "something".


* 
**Data Structure:** It is structured as an array of elements with associated indices.


* 
**Encodings:** Vectors can be represented through **one-hot encoding** (e.g., categorizing food items like borscht or shawarma) or mapped across dimensions like "sandwich-y," "dessertness," and "liquidness".



## Embeddings and Embedding Models

* 
**Definition:** Embeddings are vectorized representations of any object, including images, documents, and audio.


* 
**Models:** An embedding model is an algorithm (often a **Deep Neural Network**) that generates these vector representations.


* 
**Embedding Space:** Data points are represented within a multi-dimensional "Embedding Space," where their positions relative to one another indicate relationships.



## Vector Database Architecture

* 
**Definition:** A database specifically designed to store and work with vector embeddings.


* 
**Data Point Components:** A "Point" in a vector DB consists of an **ID**, the **vector representation** (dimensions), and **Metadata** (the payload).


* 
**Query Process:** Applications send a query to an embedding model, which produces a vector embedding that is then searched against the Vector Database to return a result.



## Key Features and Mechanisms

### Distance Metrics

To determine relationships between points, databases use various metrics:

* 
**Euclidean Distance:** Measuring the straight-line distance between points.


* 
**Cosine Similarity:** Measuring the angle between vectors to find similar or opposite items.


* 
**Manhattan and Chebyshev:** Other methods for calculating distance in the vector space.



### Indexing Algorithms

These enable fast querying within complex data structures:

* 
**Approximate Nearest Neighbor (ANN):** Finding the closest neighbors to a query point.


* 
**Dimensionality Reduction:** Techniques like **Random Projection** or **Product Quantization** (using k-means clustering) simplify high-dimensional data.


* 
**HNSW (Hierarchical Navigable Small World):** Considered the state-of-the-art algorithm for efficient searching.


* 
**Locality-Sensitive Hashing:** Reducing search space by grouping vectors into buckets.



### Metadata Filtering

* 
**Pre-filtering:** Filtering metadata before the vector search.


* 
**Post-filtering:** Conducting the search first, then filtering the top results.



## Comparison: Relational vs. Vector Databases

| Feature | Relational DBs 

 | Vector DBs 

 |
| --- | --- | --- |
| **Focus** | Storage and persistence 

 | Search focused 

 |
| **Search Type** | Exact matches/precise searches 

 | Approximate results 

 |
| **Logic** | ACID transactions, table joins 

 | Similarity and semantic search 

 |
| **Data Types** | Standard data types 

 | Anything that can be vectorized 

 |

## Types of Vector Databases

* 
**Fully Fledged:** Purpose-built systems like **Pinecone**, **Milvus**, **Chroma DB**, **Weaviate**, and **Qdrant**.


* 
**Vector Search Libraries:** Tools like **FAISS** (Facebook AI Similarity Search) and **Annoy** (Spotify).


* 
**RDB Plugins:** Extensions for existing databases, such as **pgVector** for PostgreSQL.
