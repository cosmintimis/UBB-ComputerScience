The provided documents cover two primary topics: **Temporal Database** implementations in major commercial products (Oracle, SQL Server, and PostgreSQL) and an **Introduction to Cloud Computing**.

---

## 1. Temporal Databases in Commercial Products

Modern relational databases like Oracle, Microsoft SQL Server, and PostgreSQL offer advanced facilities to manage temporal data, allowing users to track multiple versions of data over time.

### Oracle: Flashback Technology and Temporal Validity

Oracle manages temporal data through two primary concepts:

* 
**Valid Time (VT):** Managed via **Temporal Validity**, allowing users to explicitly define periods using `PERIOD FOR` to indicate when data is active or relevant.


* 
**Transaction Time (TT):** Managed automatically via **Flashback Data Archive (FDA)**, which records the exact time transactions occur.



**Key Flashback Features:**

* 
**Flashback Query:** Interrogates data at a specific point in the past using the `AS OF` clause.


* 
**Flashback Version Query:** Retrieves different versions of a record within a time interval using `VERSIONS BETWEEN`.


* 
**Flashback Table & Drop:** Restores a table to a previous state or recovers a dropped table from a "Recycle Bin".


* 
**Flashback Database:** Acts like a "rewind" button for the entire database to recover from logical corruption without restoring a full backup.



### Microsoft SQL Server: System-Versioned Temporal Tables

Introduced in 2016, SQL Server uses **System-Versioned Temporal Tables** to automatically track history.

* 
**Structure:** Utilizes two physical tables: one for current data and a history table for past versions.


* 
**Mechanism:** Every record includes `SysStartTime` and `SysEndTime` columns to define validity.


* 
**Querying:** Uses the `FOR SYSTEM_TIME` clause with options like `AS OF`, `FROM...TO`, or `BETWEEN`.


* 
**Constraints:** Requires a primary key, uses `datetime2` data types, and prohibits modification of data within the history table.



### PostgreSQL: Extensions and Manual Implementation

PostgreSQL does not have the same level of native support but offers temporal capabilities through extensions.

* 
**Temporal Tables Extension:** Provides automatic versioning similar to SQL Server by automatically creating and managing history tables.


* 
**Manual Management:** Users can manually add `valid_from` and `valid_to` columns combined with triggers to manage historical states.



---

## 2. Introduction to Cloud Computing

Cloud computing provides on-demand availability of computing resources, shifting from traditional "on-premises" hardware to flexible, service-based models.

### Cloud Classification

* 
**Deployment Models:** Public, Private, Community, and Hybrid.


* **Service Models:**
* 
**IaaS (Infrastructure):** Provides virtual machines (e.g., Amazon EC2).


* 
**PaaS (Platform):** Tools for development without managing underlying systems (e.g., Google App Engine, managed databases).


* 
**SaaS (Software):** Ready-to-use applications via UI or API (e.g., Office365, Dropbox).





### Pricing and Architecture

* 
**Pricing Models:** Costs can be **Time-based** (pay per hour/second), **Usage-based** (pay per transaction/request), or **Subscription-based**. Discounts are often available for reservations or sustained use.


* 
**Well-Architected Frameworks:** Providers like AWS, Azure, and Google emphasize five pillars: Operational Excellence, Security, Reliability, Performance, and Cost Optimization.


* 
**The 12-Factor App:** A methodology for building modern, cloud-native applications focusing on factors like codebase, dependencies, and disposability.
