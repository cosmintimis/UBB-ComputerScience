This lecture provides a comprehensive overview of **Temporal Databases**, focusing on the mathematical structure of time, the different types of temporal data models, and the implementation of these concepts within the **SQL:2011 standard**.

---

## 1. Concepts and Structure of Time

Time in databases is defined as a measurable but intangible dimension. It is modeled using various structures:

* 
**Time Structure**: Can be **Linear** (a total order of instants), **Hypothetical** (a tree of possible futures), or **Cyclic** (recurring units like weeks).


* 
**Boundedness**: Time may be unbounded, bounded from the left (having an origin), or bounded at both ends .


* **Density**:
* 
**Discrete**: Viewed as a sequence of non-decomposable units called **chronons**.


* 
**Dense**: Modeled by rational numbers with infinite instants between chronons .


* 
**Continuous**: Modeled by real numbers.





---

## 2. Temporal Data Types

The SQL-92 standard and subsequent models identify three fundamental temporal types:

* 
**Instant**: A specific "anchored" point on the timeline (e.g., `DATE`, `TIME`, `TIMESTAMP`) .


* 
**Interval**: A relative duration of time (e.g., "three months") that has direction (positive or negative) but no fixed start or end .


* 
**Period**: An anchored duration with a specific start and end instant (e.g., "Spring Semester"). While critical, SQL-92 does not have a native period literal, often requiring simulation by developers .



---

## 3. Taxonomy of Temporal Databases

Temporal databases are categorized by how they handle different "dimensions" of time:

* 
**Valid Time (Historical)**: The time a fact is true in the real world. Supports physical deletions and updates at any point in the past, present, or future .


* 
**Transaction Time (Rollback)**: The time a fact is actually stored in the database. These databases only allow updates to the "current" state; the past is immutable . Deletions are logical rather than physical.


* 
**Bi-temporal**: Supports both dimensions, allowing queries about the history of the world ("Where did John live in 1992?") and the history of the database ("In 1992, what did the DB *believe* about where John lived?") .



---

## 4. SQL:2011 Standard Implementation

The SQL:2011 standard introduced formal support for temporal data using **period definitions** as table metadata rather than a new standalone data type.

### Application-Time Period Tables (Valid Time)

* Used for data valid in the real world.


* Users manually manage start and end columns.


* 
**Special Syntax**: `FOR PORTION OF` allows updating or deleting records for specific time segments, which may trigger the system to automatically **split** one row into multiple contiguous rows to maintain data integrity.


* 
**Constraints**: Supports `WITHOUT OVERLAPS` for primary keys and temporal referential integrity.



### System-Versioned Tables (Transaction Time)

* Used for auditing and legal compliance.


* The system automatically maintains the `SYSTEM_TIME` period; users cannot modify historical rows .


* An `UPDATE` or `DELETE` automatically archives the old row as a "historical" record and creates/modifies the current row with the transaction timestamp .


* 
**Queries**: Uses extensions like `FOR SYSTEM_TIME AS OF`, `FROM...TO` (closed-open), and `BETWEEN...AND` (closed-closed) .



### Bitemporal Tables

These combine both features, where the user manages application time and the system manages versioning via transaction time .
