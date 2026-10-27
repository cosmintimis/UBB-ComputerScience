## Executive Summary: ArtSoft Consult and CDC Technologies

ArtSoft Consult is a Romanian private digital engineering firm headquartered in **Cluj-Napoca**. With over **25 years** in business and a team of **140+ professionals**, the company provides strategic technology partnerships to Tier 1 private clients across Europe and the US.

---

### Company Overview

* 
**Performance Metrics**: ArtSoft maintains a high customer retention rate, with **80% of revenue** generated from repeat clients and over **300 completed projects**.


* **Industry Focus (2020-2024)**: Their primary revenue streams come from the following sectors:
* 
**Traveling**: 24% 


* 
**Education**: 19% 


* 
**Telecom & Commerce/Marketing**: 16% each 


* 
**Manufacturing**: 12% 




* 
**Core Services**: Offerings include full-stack software development, cloud-native architecture, mobile development (iOS/Android), and QA/Testing.



### Technical Expertise: Change Data Capture (CDC)

A significant portion of the company's expertise involves **Business Intelligence (BI)** and **ETL/ELT strategies**. They emphasize **Log-based CDC** as a highly efficient method for near real-time data updates.

| Method | Accuracy | Performance | Detects Deletes |
| --- | --- | --- | --- |
| **Log-based** | High | High | Yes 

 |
| **Trigger-based** | High | Medium | Yes 

 |
| **Timestamp-based** | Medium | High | No (only soft) 

 |

### Debezium Platform Integration

ArtSoft utilizes **Debezium**, an open-source distributed CDC platform, to enable real-time streaming without modifying application logic.

* 
**Architecture**: It captures changes from source databases (e.g., MySQL, PostgreSQL) and streams them through **Apache Kafka** to various sinks like **ElasticSearch** or **Data Warehouses**.


* **Key Features**:
* 
**Incremental Snapshots**: Allows for capturing historical data from large tables without suppressing new change events.


* 
**Schema Tracking**: Automatically detects and handles changes in database schemas.


* 
**Low Latency**: Supports real-time analytics through integration with Flink and Apache Beam.