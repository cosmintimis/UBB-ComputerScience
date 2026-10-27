# Bitemporal Data Modeling Report

## 1. Approach
**Two Time Dimensions**
- **Valid Time:** When data is true in reality (business time)  
- **Transaction Time:** When system knew about it (audit time)  

**MySQL:**  
- Manual columns (`valid_start/end`, `transaction_start/end`)  
- Triggers for versioning and overlap prevention  
- Single table stores all versions (current marker `9999-12-31`)  

**PostgreSQL:**  
- `periods` extension (SQL:2011 compliant)  
- Auto-managed `valid_from/to`, `system_time_start/end`  
- Automatic history tables and system versioning  
- Exclusion constraints prevent overlapping periods  

## 2. Challenges & Solutions
| Challenge | MySQL Solution | PostgreSQL Solution |
|-----------|----------------|-------------------|
| Overlapping periods | Triggers | `EXCLUDE USING gist` |
| History management | Manual triggers | Automatic via `periods` |
| Late/backdated entries | Views detect transaction > valid | Same logic using `periods.contains()` |
| Complex queries | Manual views | Built-in temporal functions (`__as_of()`) |

## 3. Key Insights
- **Query past reality:** “What was salary on June 1?”  
- **Query past knowledge:** “What did we know on May 1 about June 1 salary?”  
- **Never DELETE, always close periods** to preserve audit trail  
- **Both times are essential:** Valid time alone cannot track late entries; transaction time alone cannot handle corrections
